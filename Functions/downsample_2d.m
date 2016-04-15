function [ dsimg ] = downsample_2d(img,n)
%DOWNSAMPLE_2D produces downedsampled image of an original image.
%Say:
%   Original Image:
%   a 0 b 0
%   0 0 0 0
%   c 0 d 0
%   0 0 0 0
%   When downsamplefactor = 2: result:
%   a b
%   c d

dsimg = zeros(ceil(size(img)/n));
for i =1:ceil(size(img,2)/n)
    dsimg(:,i) = downsample(img(:,1+(i-1)*n),n);
end

end

