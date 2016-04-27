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
%         y_shift = 6-3*0.01:0.005:6+3*0.01;
%         x_shift = 21-3*0.01:0.005:21+3*0.01;
%     %Initialize data sets.
%         star_low_005_13x13 = zeros([aoi(3) aoi(4) numel(y_shift), numel(x_shift)],'double');
%         knife_low_005_13x13 = zeros([aoi(3) aoi(4) numel(y_shift), numel(x_shift)],'double');
%         line_low_005_13x13 = zeros([aoi(3) aoi(4) numel(y_shift), numel(x_shift)],'double');
%     %Capture images.
%         for j = 1:numel(y_shift);
%             S_y.move_abs(y_shift(j));
%             for i = 1:numel(x_shift);
%                 S_x.move_abs(x_shift(i));
%                 [~,star_low_005_13x13(:,:,j,i)] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
%             end
%         end
%     %Display AOI from captured images.
%         aoi_center = define_aoi(star_low_005_13x13(:,:,1,1));
%         while true
%             disp_image(squeeze(star_low_005_13x13(aoi_center(1):aoi_center(1)+aoi_center(3),aoi_center(2):aoi_center(2)+aoi_center(4),:,1,:)));
%         end

%3. Generate high resolution images from captured images.
    %Set consistent parameters.
        Hk = [];
        alpha = 0.6;
        lambda = 0.005;
        P = 2;        
        show = true;
    %Star pattern
        star_part = star_low_005_13x13(500:800,300:600,:,:);
        %Smaller image.
            r = 2;
            beta = 10;
            N = 20;
            star_high_2 = superresolution(star_part(:,:,1:3:end,1:3:end),r,Hk,beta,N,alpha,lambda,P,show);
        %Larger image (requires larger beta).
            r = 4;
            beta = 15;
            N = 30;
            star_high_4_half = superresolution(star_part(100:200,100:200,1:2:end,1:2:end),r,Hk,beta,N,alpha,lambda,P,show);
        %More images (requires smaller beta).
            r = 4;
            beta = 4;
            N = 30;
            star_high_4_full = superresolution(star_part(100:200,100:200,:,:),r,Hk,beta,N,alpha,lambda,P,show);
        %Use camera blur (Hk).
            region = cell(1,2);
            region{1} = [484 228 322 456];
            region{2} = [35 22 270 412];
            Hk = find_mtf(knife_low_005_13x13(:,:,1,1),'edge',[region,'hough']);
            Hk = fit_triag(Hk); %Generate psf with triangle fit on MTF
            Hk = abs(Hk(ceil(size(Hk,2)/2)-4:ceil(size(Hk,2)/2)+4,ceil(size(Hk,2)/2)-4:ceil(size(Hk,2)/2)+4)); %Crop Hk.
            r = 2;
            beta = 10;
            N = 20;
            superresolution(star_part(:,:,1:3:end,1:3:end),r,Hk,beta,N,alpha,lambda,P,show);