%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  04/01/16
%---------------------------------------------------
%Final Project.

C = Camera(0);
S = APT.getstage('linear');
% S.velocity = 40;
S.home();

pixelclock = 7; %Set the speed of pixel readout.
aoi = [0 0 1280 1024]; %AOI.
frames = 10; %Number of frames to capture.
exposure_max = 227.8060;
exposure = exposure_max;

% %Confirm there is aliasing with 450 nm filter.
%     [~,star_450nm] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
%     
%Capture subpixel series of images.
    position_center = 21;
    x1 = 325;
    x2 = 655;
    d = 10;
    pixel_size = d/(x2-x1);

    positions = 21-3*0.01:0.005:21+3*0.01;
%     star_low_005 = zeros([aoi(3) aoi(4) 5],'double');
    star_low_005_6x = zeros([aoi(3) aoi(4) 5],'double');
%     knife_low_005 = zeros([aoi(3) aoi(4) 5],'double');
%     knife_low_005_6x = zeros([aoi(3) aoi(4) 5],'double');
%     line_low_005 = zeros([aoi(3) aoi(4) 5],'double');
%     line_low_005_6x = zeros([aoi(3) aoi(4) 5],'double');

%        positions = 21-0.01:0.001:21+0.01;
%        star_low_001 = zeros([aoi(3) aoi(4) numel(positions)],'double');   
image3dplay
    for i = 1:numel(positions);
        S.move_abs(positions(i));
        [~,star_low_005_6x(:,:,i)] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    end

    aoi_center = define_aoi(star_low_005_6x);
    
    while true
        disp_image(star_low_005_6x(aoi_center(1):aoi_center(1)+aoi_center(3),aoi_center(2):aoi_center(2)+aoi_center(4),:));
    end