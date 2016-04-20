function [ imgs ] = fproj( img, rdim, xt, yt )
%FPROJ Forward projects img into multiple shifted images.
%   Detailed explanation goes here
fac = size(img)./rdim;
imgs = zeros(rdim(1),rdim(2),size(yt,1),size(yt,2));
% imgs = zeros([size(img) numel(yt)]);
for i = 1:size(yt,1)
    for j = 1:size(yt,2)
        img_t = imtranslate(img, [xt(i,j) yt(i,j)]);
        %deblur here.
    %     imgs(:,:,i,j) = img_t;
        imgs(:,:,i,j) = downsample_2d(img_t, fac(1), fac(2));
    end
end

end

