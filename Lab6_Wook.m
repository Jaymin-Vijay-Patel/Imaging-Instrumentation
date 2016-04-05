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


% created structure to store all u0s just for convenience
types = {'phantommag_','phantom4_'};
seeds = {'650','600','550','500','450','nofilter'};
u_mag = [110, -91, -89, -84, 107, 106];
u_p4 = [107, 99, 103];
% Define u0
u0s = struct;
for i = 1:6
    name = strcat(types{1},seeds{i});
    u0s.(name) = u_mag(i);
end
for i = 1:3
    j = [3,5,6];
    name = strcat(types{2},seeds{j(i)});
    u0s.(name) = u_p4(i);
end

%Analysis

%     u0 = 107; % For phantommag_450
%     u0 = -83; % For phantommag_500
%     u0 = -89; % For phantommag_550
%     u0 = -91; % For phantommag_600
%     u0 = 106; % For phantommag_650
%     u0 = 99; % For phantom4_450
%     u0 = 107; % For phantom4_550
%     u0 = 103; % For phantom4_nofilter

    SAD = 393.03; %mm
    pixelsize = 0.054; %mm
    
    images = phantommag_nofilter;
    I0 = nophantom_nofilter;
    u0 = u0s.phantommag_nofilter;
    dark_current_100 = D25;
    
    images_slice = double(images(:,502:522,:));
    dark_current_100_slice = repmat(dark_current_100(:,502:522),1,1,360);
    I0_slice = double(repmat(I0(:,502:522),1,1,360));
    sinogram = squeeze(mean((images_slice-dark_current_100_slice)./I0_slice,2));
    if u0 > 0
        recon = reconstruct(sinogram(u0:end,:), 512, SAD, pixelsize);
    elseif u0 < 0
        recon = reconstruct(sinogram(1:end+u0,:), 512, SAD, pixelsize);
    end
    figure; imagesc(recon); axis equal; colorbar; colormap gray; 
    title('Title'); axis([0 512 0 512]);
    
% end