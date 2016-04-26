function [psf] = fit_triag(mtf)
%FIT_TRIAG Fits a triangle function on 1D profile of MTF, generate new MTF
%with the fitted 1D profile, and computes psf from the MTF.

ttofit = mtf(:,ceil(size(mtf,1)));
maxpt = find(ttofit==max(ttofit));
maxpt = maxpt(1);
slope = (ttofit(maxpt)-ttofit(ceil(maxpt/2)))/(maxpt-ceil(maxpt/2)); % Positive slope

trifit = makedist('Triangular','a',1,'b',ceil(ttofit(maxpt)/slope)+1,'c',2*ceil(ttofit(maxpt)/slope)+1);
x= 1:2*ceil(ttofit(maxpt)/slope)+1;
tripdf = pdf(trifit,x);
scale = max(ttofit)/max(tripdf);
tripdf_sc_profile = -(tripdf*scale)+max(tripdf*scale);
mtf_sc = zeros(length(tripdf_sc_profile));

center = size(mtf_sc)/2;
Colind = repmat((1:size(mtf_sc,1)),size(mtf_sc,1),1);
Rowind = repmat((1:size(mtf_sc,1))',1,size(mtf_sc,1));
Dmat = sqrt((Rowind-center(1)).^2 + (Colind-center(2)).^2);
for i = 1:size(mtf_sc,1)
    mtf_sc(:,i) = interp1(abs(tripdf_sc_profile),Dmat(:,i)+1);
end

psf = otf2psf(mtf_sc/max(mtf_sc(:))); % Dividing mtf with its max for normalization
end