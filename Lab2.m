%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  02/16/16
%---------------------------------------------------
%Laboratory 2.

C = Camera(0);
pixelclock = 7; %Set the speed of pixel readout.

%Part 1: Measuring spatial covariance in your imaging system.
    aoi = [462 590 100 100]; %AOI.
    exposure = 25; %Exposure time in milliseconds.
    pixel = [50 50]; %Pixel within AOI to measure spatial covariance of.
    frames = 5000; %Number of frames to capture.
    %A. Empty.
        if ~exist('empty','var')
            empty = capture_frames({'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
            empty_cov = cov_pixel(empty,pixel);
            empty_nps = fftshift(fft2(empty_cov));
        end
        h = disp_image(empty_cov,['No Scene: Covariance of Pixel at ' mat2str(pixel)]);
        xlabel('Horizontal Axis <Pixels>'); ylabel('Vertical Axis <Pixels>'); ylabel(h{2},'Intensity <Arbitrary Units>');
        h = disp_image(log(abs(empty_nps)),['No Scene: Noise Power Spectrum of Pixel at ' mat2str(pixel)]);
        xlabel('Horizontal Axis <Pixels>'); ylabel('Vertical Axis <Pixels>'); ylabel(h{2},'Noise Power <Logscale Arbitrary Units>');
    %B. Uniform Patch.
        %B-1. Focused.
            if ~exist('focus','var')
                focus = capture_frames({'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
                focus_cov = cov_pixel(focus,pixel);
                focus_nps = fftshift(fft2(focus_cov));
            end
            h = disp_image(focus_cov,['Focused Uniform Patch: Covariance of Pixel at ' mat2str(pixel)]);
            xlabel('Horizontal Axis <Pixels>'); ylabel('Vertical Axis <Pixels>'); ylabel(h{2},'Intensity <Arbitrary Units>');
            h = disp_image(log(abs(focus_nps)),['Focused Uniform Patch: Noise Power Spectrum of Pixel at ' mat2str(pixel)]);
            xlabel('Horizontal Axis <Pixels>'); ylabel('Vertical Axis <Pixels>'); ylabel(h{2},'Noise Power <Logscale Arbitrary Units>');
        %B-2. Defocused.
            if ~exist('defocus','var')
                defocus = capture_frames({'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
                defocus_cov = cov_pixel(defocus,pixel);
                defocus_nps = fftshift(fft2(defocus_cov));
            end
            h = disp_image(defocus_cov,['Defocused Uniform Patch: Covariance of Pixel at ' mat2str(pixel)]);
            xlabel('Horizontal Axis <Pixels>'); ylabel('Vertical Axis <Pixels>'); ylabel(h{2},'Intensity <Arbitrary Units>');
            h = disp_image(log(abs(defocus_nps)),['Defocused Uniform Patch: Noise Power Spectrum of Pixel at ' mat2str(pixel)]);
            xlabel('Horizontal Axis <Pixels>'); ylabel('Vertical Axis <Pixels>'); ylabel(h{2},'Noise Power <Logscale Arbitrary Units>');
        
%Part 2: Measuring spatial resolution properties of your imaging system.
%Aperture = 16.
    exposure = 25; %Exposure time in milliseconds.
%     loop_camera(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',10});
    frames = 100; %Number of frames to capture.    
    %A. Line pair target 2 lp/mm to 10 lp/mm.
        if ~exist('line2','var')
            [line2,line2_mean] = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
        end
        if ~exist('star2','var')
            [star2,star2_mean] = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
        end
        if ~exist('edge2_angle1','var')
            [edge2_angle1,edge2_angle1_mean] = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
        end
        if ~exist('edge2_angle2','var')
            [edge2_angle2,edge2_angle2_mean] = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
        end
        if ~exist('edge2_angle1_mtf','var')
            [edge2_angle1_mtf,edge2_angle1_region] = find_mtf(edge2_angle1_mean,'edge','hough');
        end
        if ~exist('edge2_angle2_mtf','var')
            [edge2_angle2_mtf,edge2_angle2_region] = find_mtf(edge2_angle2_mean,'edge','hough');
        end
    %B. Line pair target so that 4 lp/mm is blurred (e.g. flat).
        if ~exist('line4','var')
            [line4,line4_mean] = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
        end
        if ~exist('star4','var')
            [star4,star4_mean] = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
        end
        if ~exist('edge4_angle1','var')
            [edge4_angle1,edge4_angle1_mean] = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
        end
        if ~exist('edge4_angle2','var')
            [edge4_angle2,edge4_angle2_mean] = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
        end
        if ~exist('edge4_angle1_mtf','var')
            [edge4_angle1_mtf,edge4_angle1_region] = find_mtf(edge4_angle1_mean,'edge','hough');
        end
        if ~exist('edge4_angle2_mtf','var')
            [edge4_angle2_mtf,edge4_angle2_region] = find_mtf(edge4_angle2_mean,'edge','hough');
        end
    %C. Line pair target so that 8 lp/mm is blurred (e.g. flat).
        if ~exist('line8','var')
            [line8,line8_mean] = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
        end
        if ~exist('star8','var')
            [star8,star8_mean] = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
        end
        if ~exist('edge8_angle1','var')
            [edge8_angle1,edge8_angle1_mean] = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
        end
        if ~exist('edge8_angle2','var')
            [edge8_angle2,edge8_angle2_mean] = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
        end
        if ~exist('edge8_angle1_mtf','var')
            [edge8_angle1_mtf,edge8_angle1_region] = find_mtf(edge8_angle1_mean,'edge','hough');
        end
        if ~exist('edge8_angle2_mtf','var')
            [edge8_angle2_mtf,edge8_angle2_region] = find_mtf(edge8_angle2_mean,'edge','hough');
        end
        
%Part 3: Obtain the sharpest possible image of the star pattern target.
    exposure = 25; %Exposure time in milliseconds.
    frames = 100; %Number of frames to capture.
    %Best star pattern target.
%         loop_camera(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',10});
        aoi = [843 459 80 84]; %AOI.
%         loop_camera(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',10});
        if ~exist('star_mean','var')
            [~,star_mean] = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
        end
        star_mean_aoi = star_mean(aoi(1):aoi(1)+aoi(3)-1,aoi(2):aoi(2)+aoi(4)-1);
        h = disp_image(star_mean_aoi,'AOI Used to Sharpen Star Pattern Target');
        xlabel('Horizontal Axis <Pixels>'); ylabel('Vertical Axis <Pixels>'); ylabel(h{2},'Intensity <Arbitrary Units>');
        h = disp_image(star_mean,'Sharpest Possible Image of Star Pattern Target');
        xlabel('Horizontal Axis <Pixels>'); ylabel('Vertical Axis <Pixels>'); ylabel(h{2},'Intensity <Arbitrary Units>');
    %Best line pair.
%         loop_camera(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',10});
        aoi = [401 633 84 264]; %AOI.
%         loop_camera(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',10});
        if ~exist('line_mean','var')
            [~,line_mean] = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
        end
        line_mean_aoi = line_mean(aoi(1):aoi(1)+aoi(3)-1,aoi(2):aoi(2)+aoi(4)-1);
        h = disp_image(line_mean_aoi,'AOI Used to Sharpen Line Pairs');
        xlabel('Horizontal Axis <Pixels>'); ylabel('Vertical Axis <Pixels>'); ylabel(h{2},'Intensity <Arbitrary Units>');
        h = disp_image(line_mean,'Sharpest Possible Image of Line Pairs');
        xlabel('Horizontal Axis <Pixels>'); ylabel('Vertical Axis <Pixels>'); ylabel(h{2},'Intensity <Arbitrary Units>');
   %Comparing Part 2 and Part 3.
        figure; subplot(1,2,1); colormap('gray'); imagesc(star2_mean'); axis('image'); title('Image of Star Pattern Target with 2 to 10 lp/mm in Focus'); hold on;
        xlabel('Horizontal Axis <Pixels>'); ylabel('Vertical Axis <Pixels>'); h = colorbar; ylabel(h,'Intensity <Arbitrary Units>');
        subplot(1,2,2); imagesc(star_mean');  axis('image'); title('Sharpest Possible Image of Star Pattern Target');
        xlabel('Horizontal Axis <Pixels>'); ylabel('Vertical Axis <Pixels>'); h = colorbar; ylabel(h,'Intensity <Arbitrary Units>');
        figure; subplot(1,2,1); colormap('gray'); imagesc(line2_mean'); axis('image'); title('Image of Line Pairs with 2 to 10 lp/mm in Focus'); hold on;
        xlabel('Horizontal Axis <Pixels>'); ylabel('Vertical Axis <Pixels>'); h = colorbar; ylabel(h,'Intensity <Arbitrary Units>');
        subplot(1,2,2); imagesc(line_mean');  axis('image'); title('Sharpest Possible Image of Line Pairs');
        xlabel('Horizontal Axis <Pixels>'); ylabel('Vertical Axis <Pixels>'); h = colorbar; ylabel(h,'Intensity <Arbitrary Units>');