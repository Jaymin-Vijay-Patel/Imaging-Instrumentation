%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  04/28/16
%---------------------------------------------------
%Final Project Demo.

    %Stage settings.
        S_x = APT.getstage('linear');
        S_y = APT.getstage('vertical');
        S_x.home();
        S_y.home();
    %Camera settings.
        C = Camera(0);
        pixelclock = 7; %Set the speed of pixel readout.
        aoi = [0 0 1280 1024]; %AOI.
        frames = 1; %Number of frames to capture.
        exposure_max = 227.8060;
        exposure = exposure_max;
    %Set absolute positions for x and y shifts.
        shift = 0.015;
        y_shift = 6-3*0.01:shift:6+3*0.01;
        x_shift = 21-3*0.01:shift:21+3*0.01;
    %Initialize data set.
        star_low_015_5x5_227 = zeros([aoi(3) aoi(4) numel(y_shift), numel(x_shift)],'double');
    %Capture images.
        for j = 1:numel(y_shift);
            S_y.move_abs(y_shift(j));
            for i = 1:numel(x_shift);
                S_x.move_abs(x_shift(i));
                [~,star_low_015_5x5_227(:,:,j,i)] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
            end
        end
    %Display AOI from captured images.
        aoi_low = define_aoi(star_low_015_5x5_227(:,:,1,1));
        star_part = star_low_015_5x5_227(aoi_low(1):aoi_low(1)+aoi_low(3),aoi_low(2):aoi_low(2)+aoi_low(4),:,:);
        disp_image(star_part);
        close('all');
    %Reconstruct high resolution image.
        alpha = 0.6;
        lambda = 0.005;
        P = 2;
        pixelL = 0.0303; %Pixel size in low resolution image <mm>.
        star_high_2 = superresolution(star_part,2,[],10,20,alpha,lambda,P,pixelL,true);
        close('all');
    %Display low and high resolution images side by side.
        figure; colormap('gray');
        subplot(1,2,1); imagesc(star_high_2.Y0); axis('image'); colorbar;
        subplot(1,2,2); imagesc(star_high_2.Xn_hat); axis('image'); colorbar;