%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  02/26/16
%---------------------------------------------------
%Laboratory 5. Spectral Imaging.

C = Camera(0);
pixelclock = 7; %Set the speed of pixel readout.
%Filters start at red.

%Part 1. Reflective Color Scene.    
%     R = cell(1,7);
    R2 = cell(1,7);
    aoi = [0 0 1280 1024]; %AOI.
    frames = 100; %Number of frames to capture.
    exposure = 100;
%     loop_camera(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',1});
    [~,R2{1}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,R2{2}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,R2{3}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,R2{4}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,R2{5}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,R2{6}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,R2{7}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
%     end
        
%Part 2. Transmissive Color Scene.
    
% delete(C);
% clear C;