%---------------------------------------------------
%Author:    Ang Li, Ho Namkung, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    ang.li@jhmi.edu, ho.namkung@jhmi.edu, jpatel18@jhmi.edu
%Revision:  02/09/16
%---------------------------------------------------
%Laboratory 1.

pixelclock = 7; %Set the speed of pixel readout.

%Part 1: Characterize detector offset and readout noise as a function of exposure time.
    %A. Full-field images.
        aoi = [0 0 1280 1024]; %Full-field image.
        exposure = 150; %Exposure time in milliseconds.
        frames = 60; %Number of frames to capture.
        [~,p1_full] = capture_frames({'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
        figure; colormap('gray'); imagesc(p1_full'); axis('image'); colorbar;
        title(['Full-field Mean Offset (Exposure = ' num2str(exposure) ' ms) (Frames = ' num2str(frames) ')']);
    %B. AOI images.
        aoi = [200 200 100 100]; %Area of interest is 100x100.
        exposure = 1:53; %Exposure times in milliseconds.
        frames = 100; %Number of frames to capture.
        p1_aoi = zeros(100,100,numel(exposure));
        p1_aoi_mean = zeros(1,numel(exposure)); %Mean pixel value for each exposure time.
        p1_aoi_var = zeros(1,numel(exposure)); %Variance of pixels for each exposure time.
        for i = 1:numel(exposure)
            [~,p1_aoi(:,:,i)] = capture_frames({'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure(i)},{'frames',frames});
            p1_aoi_mean(i) = mean2(p1_aoi(:,:,i));
            p1_aoi_var(i) = var(reshape(p1_aoi(:,:,i),aoi(3)*aoi(4),1));
        end
        p1_aoi_snr = p1_aoi_mean./sqrt(p1_aoi_var);
        figure; plot(exposure,p1_aoi_mean);
        title('AOI Mean Offset vs. Exposure Time');
        xlabel('Exposure Time <ms>'); ylabel('AOI Mean Offset');
        figure; plot(exposure,p1_aoi_var);
        title('AOI Readout Noise (Variance) vs. Exposure Time');
        xlabel('Exposure Time <ms>'); ylabel('AOI Readout Noise (Variance)');
        figure; plot(exposure,p1_aoi_snr);
        title('AOI SNR vs. Exposure Time');
        xlabel('Exposure Time <ms>'); ylabel('AOI SNR');

%Part 2: Characterize detector response and noise as a function of signal level.
    %A. Full-field images.
        aoi = [0 0 1280 1024]; %Full-field image.
        exposure = 53; %Exposure time in milliseconds.
        frames = 60; %Number of frames to capture.
        [p2_full,p2_full_mean,p2_full_var] = capture_frames({'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
        figure; colormap('gray'); imagesc(p2_full_mean'); axis('image'); colorbar;
        title(['Full-field Mean Image (Exposure = ' num2str(exposure) ' ms) (Frames = ' num2str(frames) ')']);
        figure; colormap('gray'); imagesc(p2_full_var'); axis('image'); colorbar;
        title(['Full-field Variance Image (Exposure = ' num2str(exposure) ' ms) (Frames = ' num2str(frames) ')']);
    %B. AOI images (Aperture Setting = 4) (Focus Setting ~= 0.4).
        exposure = 3:3:50; %Exposure times in milliseconds.
        %White pepper.
            wp_aoi = [200 100 100 100];
            wp = zeros(wp_aoi(3),wp_aoi(4),numel(exposure));
            wp_mean = zeros(1,numel(exposure)); %Mean pixel value for each exposure time.
            wp_var = zeros(1,numel(exposure)); %Variance of pixels for each exposure time.
        %Winter calm.
            wc_aoi = [600 100 100 100];
            wc = zeros(wc_aoi(3),wc_aoi(4),numel(exposure));
            wc_mean = zeros(1,numel(exposure)); %Mean pixel value for each exposure time.
            wc_var = zeros(1,numel(exposure)); %Variance of pixels for each exposure time.
        %Opal slate.
            os_aoi = [1000 100 100 100];
            os = zeros(os_aoi(3),os_aoi(4),numel(exposure));
            os_mean = zeros(1,numel(exposure)); %Mean pixel value for each exposure time.
            os_var = zeros(1,numel(exposure)); %Variance of pixels for each exposure time.
        frames = 100; %Number of frames to capture.
        for i = 1:numel(exposure)
            [~,wp(:,:,i)] = capture_frames({'pixelclock',pixelclock},{'aoi',wp_aoi},{'exposure',exposure(i)},{'frames',frames});
            wp_mean(i) = mean2(wp(:,:,i));
            wp_var(i) = var(reshape(wp(:,:,i),wp_aoi(3)*wp_aoi(4),1));
            [~,wc(:,:,i)] = capture_frames({'pixelclock',pixelclock},{'aoi',wc_aoi},{'exposure',exposure(i)},{'frames',frames});
            wc_mean(i) = mean2(wc(:,:,i));
            wc_var(i) = var(reshape(wc(:,:,i),wc_aoi(3)*wc_aoi(4),1));
            [~,os(:,:,i)] = capture_frames({'pixelclock',pixelclock},{'aoi',os_aoi},{'exposure',exposure(i)},{'frames',frames});
            os_mean(i) = mean2(os(:,:,i));
            os_var(i) = var(reshape(os(:,:,i),os_aoi(3)*os_aoi(4),1));
        end
        wp_snr = wp_mean./sqrt(wp_var);
        wc_snr = wc_mean./sqrt(wc_var);
        os_snr = os_mean./sqrt(os_var);
        figure;
        subplot(3,3,1); plot(exposure,wp_mean);
        title('White Pepper Signal vs. Exposure Time'); xlabel('Exposure Time <ms>'); ylabel('Signal');
        subplot(3,3,2); plot(exposure,wp_var);
        title('White Pepper Noise vs. Exposure Time'); xlabel('Exposure Time <ms>'); ylabel('Noise (Variance)');
        subplot(3,3,3); plot(exposure,wp_snr); axis([0 50 0 250]);
        title('White Pepper SNR vs. Exposure Time'); xlabel('Exposure Time <ms>'); ylabel('SNR');
        subplot(3,3,4); plot(exposure,wc_mean);
        title('Winter Calm Signal vs. Exposure Time'); xlabel('Exposure Time <ms>'); ylabel('Signal');
        subplot(3,3,5); plot(exposure,wc_var);
        title('Winter Calm Noise vs. Exposure Time'); xlabel('Exposure Time <ms>'); ylabel('Noise (Variance)');
        subplot(3,3,6); plot(exposure,wc_snr);
        title('Winter Calm SNR vs. Exposure Time'); xlabel('Exposure Time <ms>'); ylabel('SNR');
        subplot(3,3,7); plot(exposure,os_mean);
        title('Opal Slate Signal vs. Exposure Time'); xlabel('Exposure Time <ms>'); ylabel('Signal');
        subplot(3,3,8); plot(exposure,os_var);
        title('Opal Slate Noise vs. Exposure Time'); xlabel('Exposure Time <ms>'); ylabel('Noise (Variance)');
        subplot(3,3,9); plot(exposure,os_snr);
        title('Opal Slate SNR vs. Exposure Time'); xlabel('Exposure Time <ms>'); ylabel('SNR');
        
%Part 3: Create some tools that will be useful for subsequent labs.
    %A. define_aoi.m
        aoi = define_aoi();
    %B. auto_exposure.m
        exposure = auto_exposure();