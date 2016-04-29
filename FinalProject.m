%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  04/27/16
%---------------------------------------------------
%Final Project.

% %1. Generate a high resolution image from a star pattern phantom.
%     %Create star pattern phantom.
%         rdim = [1024 1024];
%         phantom = zeros(rdim);
%         up = [0 1];
%         switch_angle = pi/12; %deg2rad(5);
%         for ii = 1:rdim(1)
%             for jj = 1:rdim(2)
%                 v = [ii jj] - rdim/2;
%                 a = acos(v * up'/norm(v));
%                 if xor(mod(a,switch_angle) > switch_angle/2, ii > rdim(1)/2)
%                     phantom(ii,jj) = 1;
%                 end
%             end
%         end
%         disp_image(phantom);
%     %Downsample and move the star pattern phantom.
%         dim = [256 256];
%         [x_shift,y_shift] = meshgrid(0:rdim(1)/dim(1)-1, 0:rdim(2)/dim(2)-1);
%         phantom_low = fproj(phantom, dim, x_shift, y_shift);
%         figure; disp_image(phantom_low(:,:,:));
%     %Generate a high resolution image.
%         r = rdim./dim;
%         Hk = [];
%         beta = 0.1;
%         N = 100;
%         alpha = 0.6;
%         lambda = 0.005;
%         P = 2;        
%         show = true;
%         phantom_high = superresolution(phantom_low,r,Hk,beta,N,alpha,lambda,P,show);
%         phantom_high(phantom_high < 0) = 0;
%         phantom_high(phantom_high > max(img(:))) = max(img(:));
%         figure; disp_image(phantom_high);
    
% %2. Capture low resolution images.
%     %Stage settings.
%         S_x = APT.getstage('linear');
%         S_y = APT.getstage('vertical');
%         S.velocity = 40;
%         S_x.home();
%     %Camera settings.
%         C = Camera(0);
%         pixelclock = 7; %Set the speed of pixel readout.
%         aoi = [0 0 1280 1024]; %AOI.
%         frames = 10; %Number of frames to capture.
%         exposure_max = 227.8060;
%         exposure = exposure_max;
%     %Set absolute positions for x and y shifts.
%         shift = 0.005;
%         y_shift = 6-3*0.01:shift:6+3*0.01;
%         x_shift = 21-3*0.01:shift:21+3*0.01;
%         shift = 0.015;
%         y_shift = 6-3*0.01:shift:6+3*0.01;
%         x_shift = 21-3*0.01:shift:21+3*0.01;
%     %Initialize data sets.
%         star_low_005_13x13 = zeros([aoi(3) aoi(4) numel(y_shift), numel(x_shift)],'double');
%         knife_low_005_13x13 = zeros([aoi(3) aoi(4) numel(y_shift), numel(x_shift)],'double');
%         line_low_005_13x13 = zeros([aoi(3) aoi(4) numel(y_shift), numel(x_shift)],'double');
%         star_low_015_5x5_227 = zeros([aoi(3) aoi(4) numel(y_shift), numel(x_shift)],'double');
%         star_low_015_5x5_114 = zeros([aoi(3) aoi(4) numel(y_shift), numel(x_shift)],'double'); exposure = 114;
%         star_low_015_5x5_57 = zeros([aoi(3) aoi(4) numel(y_shift), numel(x_shift)],'double'); exposure = 57;
%         star_low_015_5x5_28 = zeros([aoi(3) aoi(4) numel(y_shift), numel(x_shift)],'double'); exposure = 28;
%         star_low_015_5x5_14 = zeros([aoi(3) aoi(4) numel(y_shift), numel(x_shift)],'double'); exposure = 14;
%         star_low_015_5x5_7 = zeros([aoi(3) aoi(4) numel(y_shift), numel(x_shift)],'double'); exposure = 7;
%         star_low_015_5x5_4 = zeros([aoi(3) aoi(4) numel(y_shift), numel(x_shift)],'double'); exposure = 4; %Managed to not save this.
%         star_low_015_5x5_4_nofilter = zeros([aoi(3) aoi(4) numel(y_shift), numel(x_shift)],'double'); exposure = 4;
%         star_low_015_5x5_0009 = zeros([aoi(3) aoi(4) numel(y_shift), numel(x_shift)],'double'); exposure = 0.009;
%     %Capture images.
%         for j = 1:numel(y_shift);
%             S_y.move_abs(y_shift(j));
%             for i = 1:numel(x_shift);
%                 S_x.move_abs(x_shift(i));
%                 [~,star_low_005_5x5_01(:,:,j,i)] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
%             end
%         end
%     %Display AOI from captured images.
%         aoi_center = define_aoi(star_low_005_5x5_01(:,:,1,1));
%         while true
%             disp_image(squeeze(star_low_005_5x5_01(aoi_center(1):aoi_center(1)+aoi_center(3),aoi_center(2):aoi_center(2)+aoi_center(4),:,1,:)));
%         end

%3. Generate high resolution images from captured images.
%  SYNTAX: superresolution(Yk,r,Hk,beta,N,alpha,lambda,P,pixelL,show)
    %Set consistent parameters.
        alpha = 0.6;
        lambda = 0.005;
        P = 2;
        pixelL = 0.0303; %Pixel size in low resolution image <mm>.
        image_size = 1024;
        region = {[484 228 322 456],[35 22 270 412]};
        Hk = find_mtf(knife_low_005_13x13(:,:,1,1),'edge',[region,'hough']);
        Hk = fit_triag(Hk); %Generate virtual PSF with triangle fit on MTF.
        Hk = abs(Hk(ceil(size(Hk,2)/2)-4:ceil(size(Hk,2)/2)+4,ceil(size(Hk,2)/2)-4:ceil(size(Hk,2)/2)+4)); %Crop Hk.
    %Star pattern
        star_part = star_low_005_13x13(500:800,300:600,:,:);
        %Use low resolution images 0.015mm apart 5x5 matrix with r = 2.
            star_high_2 = superresolution(star_part(:,:,1:3:end,1:3:end),2,[],10,20,alpha,lambda,P,pixelL,true); %r = 2, beta = 10, N = 20, Hk = [].
        %Use low resolution images 0.005mm apart 7x7 matrix with r = 4.
            star_high_4_half = superresolution(star_part(100:200,100:200,1:2:end,1:2:end),4,[],15,30,alpha,lambda,P,pixelL,true); % r = 4, beta = 15, N = 30, Hk = [].
        %Use low resolution images 0.005mm apart 13x13 matrix with r = 4.
            star_high_4_full = superresolution(star_part(100:200,100:200,:,:),4,[],4,30,alpha,lambda,P,pixelL,true); % r = 4, beta = 4, N = 30, Hk = [].
        %Use camera blur (Hk) to reproduce star_high_2.
            star_high_2_Hk = superresolution(star_part(:,:,1:3:end,1:3:end),2,Hk,10,20,alpha,lambda,P,pixelL,true); %r = 2, beta = 10, N = 20.
    %Line pairs.
        line_part = line_low_005_13x13(580:780,40:420,:,:);
        %Use low resolution images 0.015mm apart 5x5 matrix with r = 2.
            line_high_2 = superresolution(line_part(:,:,1:3:end,1:3:end),2,[],10,30,alpha,lambda,P,pixelL,true); %r = 2, beta = 10, N = 30, Hk = [].
        %Use low resolution images 0.005mm apart 7x7 matrix with r = 4.
            line_high_4_half = superresolution(line_part(1:200,1:200,1:2:end,1:2:end),4,[],15,30,alpha,lambda,P,pixelL,true); % r = 4, beta = 15, N = 30, Hk = [].
        %Use low resolution images 0.005mm apart 13x13 matrix with r = 4.
            line_high_4_full = superresolution(line_part(1:50,1:200,:,:),4,[],4,30,alpha,lambda,P,pixelL,true); % r = 4, beta = 4, N = 30, Hk = [].
        %Use camera blur (Hk) to reproduce star_high_2.
            line_high_2_Hk = superresolution(line_part(:,:,1:3:end,1:3:end),2,Hk,10,20,alpha,lambda,P,pixelL,true); %r = 2, beta = 10, N = 20.
    %Knife edge.
        knife_part = knife_low_005_13x13(500:800,300:600,:,:);
        %Low resolution.
            region = {ceil([97 1 102 202]/2),ceil([9 10 88 184]/2)};
            [F_low,FFT_low,MTF_low,LSF_low] = plot_mtf(knife_part(100:200,100:200,1,1),pixelL,image_size,region);
%             figure; plot(F_low,abs(FFT_low));
        %High resolution.
            %Use low resolution images 0.015mm apart 5x5 matrix with r = 2.
                knife_high_2 = superresolution(knife_part(100:200,100:200,:,:),2,[],1,20,alpha,lambda,3,pixelL,true); %r = 2, beta = 1, N = 20, P = 3.
                region = {[97 1 102 202],[9 10 88 184]};
                [F_high_2,FFT_high_2,MTF_high_2,LSF_high_2] = plot_mtf(knife_high_2.Xn_hat,knife_high_2.pixelH(1),image_size,region);
%                 figure; plot(F_high_2,abs(FFT_high_2));
            %Use low resolution images 0.005mm apart 13x13 matrix with r = 4.
                knife_high_4_full = superresolution(knife_part(100:200,100:200,:,:),4,Hk,0.5,50,alpha,lambda,P,pixelL,true); %r = 2, beta = 0.5, N = 50.
                [F_high_4_full,FFT_high_4_full,MTF_high_4_full,LSF_high_4_full] = plot_mtf(knife_high_4_full.Xn_hat,knife_high_4_full.pixelH(1),image_size,region);
%                 figure; plot(F_high_4_full,abs(FFT_high_4_full));