function [ bimgs ] = bproj( imgs, dim, xt, yt )
%BPROJ Summary of this function goes here
%   Detailed explanation goes here
fac = dim / size(imgs,1);
bimgs = zeros(dim,dim,numel(xt));
for ii=size(imgs,3)
    uimg = upsample_2d(imgs(:,:,ii),fac);
    bimgs(:,:,ii) = imtranslate(uimg, [-xt(ii) -yt(ii)]);
end

