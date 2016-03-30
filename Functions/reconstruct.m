function [ img ] = reconstruct( sgram, img_pixels, sad, pixelsize )
%RECONSTRUCT Summary of this function goes here
%   Detailed explanation goes here

%img_pixels = size(y,1);
img = zeros(img_pixels);
sy = size(sgram,1);
mask = 2/img_pixels * abs(linspace(-1,1,sy));
ly = -log(sgram);
fy = real(ifft((ifftshift(fftshift(fft(ly))' * diag(mask))')));

%assuming SAD, pixels size both in mm (or at least, same units).
find_centers = @(n) pixelsize * sy / n * ((1:n)' - (n+1)/2);
fp_centers = find_centers(sy);
%The unrotated focal point of the system
fpt = [0 sad];

%The centers of each pixel of img
pixel_centers = find_centers(img_pixels);
[xpl, ypl] = meshgrid(pixel_centers(:,1), pixel_centers(:,1));

for i = 1:360
    a = -deg2rad(i-1);

    R = [cos(a) -sin(a); sin(a) cos(a)];
    rpl = [xpl(:) ypl(:)] * R;

    xs = fpt(1) + fpt(2) * (rpl(:,1) - fpt(1)) ./ (fpt(2) - rpl(:,2));
    vals = reshape(interp1(fp_centers, fy(:,i), xs), size(img));
    img = img + vals;
end

img(img < 0) = 0;

end

