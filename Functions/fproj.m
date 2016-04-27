function fimages = fproj(image,rdim,x_shift,y_shift,Hk)
%FPROJ Forward projects image into multiple shifted images.
%   Detailed explanation goes here

if ~exist('Hk','var')
    Hk = [];
end
r = size(image)./rdim;
fimages = zeros(rdim(1),rdim(2),size(y_shift,1),size(y_shift,2));
for i = 1:size(y_shift,1)
    for j = 1:size(y_shift,2)
        img_t = imtranslate(image, [x_shift(i,j) y_shift(i,j)]);
        if ~isempty(Hk)
            img_t = convolve2(img_t,Hk,'same');
        end
        fimages(:,:,i,j) = downsample_2d(img_t, r(1), r(2));
    end
end

end

