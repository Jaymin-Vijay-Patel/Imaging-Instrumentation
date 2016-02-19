%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  02/19/16
%---------------------------------------------------
%Laboratory 4. High Dynamic Range Imaging.

% C = Camera(0);
pixelclock = 7; %Set the speed of pixel readout.

%Part 1. Determine a range of exposures to form an HDR acquisition.
    aoi = [0 0 1280 1024]; %AOI.
    frames = 10; %Number of frames to capture.
    exposure = linspace(0.009,227.806,100);
    exposure = exposure(end:-1:1);
%     exposure = logspace(log10(0.009),log10(227.806),10); %Exposure times in milliseconds.
%     [~,~,A] = capture_hdr(C,{'pixelclock',7},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,~,D] = capture_hdr(C,{'pixelclock',7},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    
%Part 2. Determine an algorithm to assemble a HDR data set.
%     [~,HDR] = capture_hdr(A);

%Part 3. Compress image data into a HDR image.
%     LDR = capture_hdr(A);
    
% delete(C);
% clear C;