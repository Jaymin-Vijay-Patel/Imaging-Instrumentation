%img_pixels = size(y,1);
img_pixels = 32;
img = zeros(img_pixels);
sy = size(y,1);
%mask = 2/img_pixels * abs(arrayfun(@(x) (x < sy/2) * (x+.5) + (x >= sy/2) * (x-sy+.5), 0:sy-1))';
%fy = real(ifft(fft(y') * diag(mask))');
fy = y;

%assuming SAD, pixels size both in mm (or at least, same units).
find_centers = @(n) pixelsize * sy / n * ((1:n)' - (n+1)/2);
fp_centers = find_centers(sy);
%The unrotated focal point of the system
fpt = [0 SAD];
find_pt = @(rx,ry) fp_centers(1) + ...
    find_t([fp_centers(1) 0],[fp_centers(end) 0],fpt,[rx ry]) * ...
    (fp_centers(end)-fp_centers(1));

%The centers of each pixel of img
pixel_centers = find_centers(img_pixels);
[xpl, ypl] = meshgrid(pixel_centers(:,1), pixel_centers(:,1));
img_side = img_pixels * pixelsize;

for i = 1:360
    a = -deg2rad(i-1);

    R = [cos(a) -sin(a); sin(a) cos(a)];
    rpl = [xpl(:) ypl(:)] * R;

    xs = arrayfun(find_pt, rpl(:,1), rpl(:,2));
    vals = reshape(interp1(fp_centers, fy(:,i), xs), size(img));
    img = img + vals;
end
