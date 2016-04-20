function [ dsimg ] = downsample_2d(img,ny,nx)
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
dsimg = downsample(downsample(img',nx)',ny);

end

