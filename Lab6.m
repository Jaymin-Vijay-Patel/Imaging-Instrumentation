%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  04/05/16
%---------------------------------------------------
%Laboratory 6. Optical Tomography

% C = Camera(0);
timeout = 100;
% S = APT.getstage('rotation','timeout',timeout);

pixelclock = 7; %Set the speed of pixel readout.
aoi = [0 0 1280 1024]; %AOI.
frames = 1; %Number of frames to capture.

% %Part 1. Collect Data.
%     %Phantoms.
%         %No Filter.
%             exposure = 25;
%             phantom4_nofilter = zeros([aoi(3) aoi(4) 360],'int16'); %Yellow dye.
%             phantommag_nofilter = zeros([aoi(3) aoi(4) 360],'int16'); %Red, white, and blue dyes.
%         %Filters.
%             exposure = 100;
%             phantom4_450 = zeros([aoi(3) aoi(4) 360],'int16');
%             phantom4_550 = zeros([aoi(3) aoi(4) 360],'int16');
%             phantommag_450 = zeros([aoi(3) aoi(4) 360],'int16');
%             phantommag_500 = zeros([aoi(3) aoi(4) 360],'int16');
%             phantommag_550 = zeros([aoi(3) aoi(4) 360],'int16');
%             phantommag_600 = zeros([aoi(3) aoi(4) 360],'int16');
%             phantommag_650 = zeros([aoi(3) aoi(4) 360],'int16');
%         %Capturing data.
%             for i = 1:360
%                 disp([num2str(i) ' degrees']);
%                 [~,phantommag_650(:,:,i)] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
%                 S.move_rel(1,'timeout',timeout);
%             end
%     %Ruler.
%         [~,ruler_nofilter_near] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',10});
%         [~,ruler_nofilter_far] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',10});

%Part 2. Reconstruct Data.
    %Reconstruction parameters.
        lines = 21;
        recon_pixels = 512;
        SAD = 393.03; %mm
        pixel_size = 0.054; %mm
%         u0 = 107; % For phantommag_450
%         u0 = -83; % For phantommag_500
%         u0 = -89; % For phantommag_550
%         u0 = -91; % For phantommag_600
%         u0 = 106; % For phantommag_650
%         u0 = 99; % For phantom4_450
%         u0 = 107; % For phantom4_550
%         u0 = 103; % For phantom4_nofilter
    %A structure for measured u0's.
        types = {'phantommag_','phantom4_'};
        seeds = {'650','600','550','500','450','nofilter'};
        u0_mag = [110, -91, -89, -84, 107, 106];
        u0_p4 = [107, 99, 103];
        u0 = struct;
        for i = 1:6
            name = strcat(types{1},seeds{i});
            u0.(name) = u0_mag(i);
        end
        for i = 1:3
            j = [3,5,6];
            name = strcat(types{2},seeds{j(i)});
            u0.(name) = u0_p4(i);
        end
    %An example call to reconstruct.m with no specified u0.
%         phantom_450_image = reconstruct(phantom4_450,lines,nophantom_450,D100,[],recon_pixels,SAD,pixel_size);
    %An example call to reconstruct.m with a measured u0.
        phantom4_450_image = reconstruct(phantom4_450,lines,nophantom_450,D100,u0.phantom4_450,recon_pixels,SAD,pixel_size);
        
%Generate figures for the report.
    %Figure .
    figure; imagesc(recon_image); axis equal; colorbar; colormap gray;