function [ imgs ] = fproj( img, rdim, xt, yt )
%FPROJ Forward projects img into multiple shifted images.
%   Detailed explanation goes here
fac = size(img,1)/rdim;
imgs = zeros(rdim,rdim,numel(yt));
for ii=1:numel(yt)
    imgs(:,:,ii) = downsample_2d(imtranslate(img, [xt(ii) yt(ii)]), fac);
end

end

