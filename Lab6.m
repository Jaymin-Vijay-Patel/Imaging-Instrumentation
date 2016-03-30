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


%Phantoms
%     phantom4_450 = zeros([aoi(3) aoi(4) 360],'int16');
%     phantom4_550 = zeros([aoi(3) aoi(4) 360],'int16');
%     phantom4_nofilter = zeros([aoi(3) aoi(4) 360],'int16');
%     phantommag_nofilter = zeros([aoi(3) aoi(4) 360],'int16');
%     phantommag_450 = zeros([aoi(3) aoi(4) 360],'int16');
%     phantommag_650 = zeros([aoi(3) aoi(4) 360],'int16');
%       [~,ruler_nofilter_near] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',10});
%     [~,ruler_nofilter_far] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',10});

    exposure = 100;
%     exposure = 25;
%     for i = 1:360
%         disp([num2str(i) ' degrees']);
%         [~,phantommag_650(:,:,i)] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
%         S.move_rel(1,'timeout',timeout);
%     end
    
%Analysis
    u0 = 97;
    SAD = 393.03; %mm
    pixelsize = 0.054; %mm
    
    images = phantom4_450;
    I0 = nophantom_450;
    dark_current_100 = D100;
    
    images_slice = double(images(:,502:522,:));
    dark_current_100_slice = repmat(dark_current_100(:,502:522),1,1,360);
    I0_slice = double(repmat(I0(:,502:522),1,1,360));
    sinogram = squeeze(mean((images_slice-dark_current_100_slice)./I0_slice,2));
    recon = reconstruct(sinogram(u0:end,:), 512, SAD, pixelsize);
    figure; imagesc(recon); axis equal; colorbar; colormap gray;