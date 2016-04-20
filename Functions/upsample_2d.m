function [ usimg ] = upsample_2d(img,n)
%UPSAMPLE_2D produces upsampled image of an original image. Add n-1 zeros between each element of the original image, both in rows and columns. 
%Say:
%   Original Image:
%    a b 
%    c d
%   Upsampled image (n=2) 
%   a 0 b 0
%   0 0 0 0
%   c 0 d 0
%   0 0 0 0

usimg = upsample(upsample(img',n)',n);

end

