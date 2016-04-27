function bimages = bproj(images,dim,x_shift,y_shift,Hk)
%BPROJ Summary of this function goes here
%   Detailed explanation goes here

if ~exist('Hk','var')
    Hk = [];
end
r = dim ./ [size(images,1) size(images,2)];
bimages = zeros(dim(1),dim(2),numel(x_shift));
for i = 1:size(images,3)
    for j = 1:size(images,4)
        upsampled_image = upsample_2d(images(:,:,i,j),r(1),r(2));
        if ~isempty(Hk)
            upsampled_image = convolve2(upsampled_image,rot90(Hk,2),'same');
        end
        bimages(:,:,i,j) = imtranslate(upsampled_image,[-x_shift(i,j) -y_shift(i,j)]);
    end
end