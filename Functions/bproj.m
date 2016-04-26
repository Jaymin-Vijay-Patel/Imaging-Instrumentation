function [ bimgs ] = bproj( imgs, dim, xt, yt, psf)
%BPROJ Summary of this function goes here
%   Detailed explanation goes here
fac = dim ./ [size(imgs,1) size(imgs,2)];
bimgs = zeros(dim(1),dim(2),numel(xt));
for i = 1:size(imgs,3)
    for j = 1:size(imgs,4)
        uimg = upsample_2d(imgs(:,:,i,j),fac(1),fac(2));
        %deblur
        if exist('psf','var')
            uimg = convolve2(uimg,rot90(psf,2),'same');
        end
        bimgs(:,:,i,j) = imtranslate(uimg, [-xt(i,j) -yt(i,j)]);
    end
end