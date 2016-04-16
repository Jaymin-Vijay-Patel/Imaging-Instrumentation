%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  04/15/16
%---------------------------------------------------
%Final Project.

C = Camera(0);
S_x = APT.getstage('linear');
S_y = APT.getstage('vertical');
% S.velocity = 40;
%S_x.home();

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

    y_positions = 6-3*0.01:0.005:6+3*0.01;
    x_positions = 21-3*0.01:0.005:21+3*0.01;
%     star_low_005 = zeros([aoi(3) aoi(4) 5],'double');
%     star_low_005_6x = zeros([aoi(3) aoi(4) numel(y_positions), numel(x_positions)],'double');
%     knife_low_005 = zeros([aoi(3) aoi(4) 5],'double');
%     knife_low_005_6x = zeros([aoi(3) aoi(4) 5],'double');
%     line_low_005 = zeros([aoi(3) aoi(4) 5],'double');
%     line_low_005_6x = zeros([aoi(3) aoi(4) 5],'double');

%        positions = 21-0.01:0.001:21+0.01;
%        star_low_001 = zeros([aoi(3) aoi(4) numel(positions)],'double');   
%image3dplay
    for j = 1:numel(y_positions);
         S_y.move_abs(y_positions(j));
        for i = 1:numel(x_positions);
            S_x.move_abs(x_positions(i));
            [~,star_low_005_13x13(:,:,j,i)] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
        end
    end
    aoi_center = define_aoi(star_low_005_13x13(:,:,1,1));
    
    while true
        disp_image(squeeze(star_low_005_13x13(aoi_center(1):aoi_center(1)+aoi_center(3),aoi_center(2):aoi_center(2)+aoi_center(4),:,1,:)));
    end