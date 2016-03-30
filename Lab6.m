%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  03/25/16
%---------------------------------------------------
%Laboratory 6. Optical Tomography

% C = Camera(0);
timeout = 100;
% S = APT.getstage('rotation','timeout',timeout);

pixelclock = 7; %Set the speed of pixel readout.
aoi = [0 0 1280 1024]; %AOI.
frames = 1; %Number of frames to capture.


%Phantom 4
%     phantom4_450 = zeros([aoi(3) aoi(4) 360],'int16');
%     phantom4_550 = zeros([aoi(3) aoi(4) 360],'int16');
%     phantom4_nofilter = zeros([aoi(3) aoi(4) 360],'int16');
%     phantommag_nofilter = zeros([aoi(3) aoi(4) 360],'int16');
%     phantommag_450 = zeros([aoi(3) aoi(4) 360],'int16');
    phantommag_650 = zeros([aoi(3) aoi(4) 360],'int16');
%       [~,ruler_nofilter_near] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',10});
%     [~,ruler_nofilter_far] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',10});

    exposure = 100;
%     exposure = 25;
    for i = 1:360
        disp([num2str(i) ' degrees']);
        [~,phantommag_650(:,:,i)] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
        S.move_rel(1,'timeout',timeout);
    end


% %img_pixels = size(y,1);
% img_pixels = 32;
% img = zeros(img_pixels);
% sy = size(y,1);
% %mask = 2/img_pixels * abs(arrayfun(@(x) (x < sy/2) * (x+.5) + (x >= sy/2) * (x-sy+.5), 0:sy-1))';
% %fy = real(ifft(fft(y') * diag(mask))');
% fy = log(y);
% 
% %assuming SAD, pixels size both in mm (or at least, same units).
% find_centers = @(n) pixelsize * sy / n * ((1:n)' - (n+1)/2);
% fp_centers = find_centers(sy);
% %The unrotated focal point of the system
% fpt = [0 SAD];
% find_pt = @(rx,ry) fp_centers(1) + ...
%     find_t([fp_centers(1) 0],[fp_centers(end) 0],fpt,[rx ry]) * ...
%     (fp_centers(end)-fp_centers(1));
% 
% %The centers of each pixel of img
% pixel_centers = find_centers(img_pixels);
% [xpl, ypl] = meshgrid(pixel_centers(:,1), pixel_centers(:,1));
% img_side = img_pixels * pixelsize;
% 
% for i = 1:360
%     a = -deg2rad(i-1);
% 
%     R = [cos(a) -sin(a); sin(a) cos(a)];
%     rpl = [xpl(:) ypl(:)] * R;
% 
%     xs = arrayfun(find_pt, rpl(:,1), rpl(:,2));
%     vals = reshape(interp1(fp_centers, fy(:,i), xs), size(img));
%     img = img + vals;
% end

%img_pixels = size(y,1);
img_pixels = 32;
img = zeros(img_pixels);
sy = size(y,1);
%mask = 2/img_pixels * abs(linspace(-1,1,sy));%abs(arrayfun(@(x) (x < sy/2) * (x+.5) + (x >= sy/2) * (x-sy+.5), 0:sy-1))';
%fy = real(ifft(ifftshift(fftshift(fft(y')) * diag(mask)))');
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

