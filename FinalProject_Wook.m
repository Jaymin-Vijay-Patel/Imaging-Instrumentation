load FinalProject_Knife_005_13x13.mat

region = cell(1,2);
region{1} = [484   228   322   456];
region{2} = [ 35    22   270   412];

H = find_mtf(knife_low_005_13x13(:,:,1,1),'edge',[region, 'hough']);
clear knife_low_005_13x13

% Generate psf with triangle fit on MTF
psf = fit_triag(H);
% Crop out 
psf_crop = abs(psf(ceil(size(psf,2)/2)-4:ceil(size(psf,2)/2)+4,ceil(size(psf,2)/2)-4:ceil(size(psf,2)/2)+4));

%Using star part
star_part = star_low_005_13x13(500:800,300:600,:,:);
superresolution(star_part(:,:,1:3:end,1:3:end),2,.6,10,.005,2,20,1,psf_crop);
