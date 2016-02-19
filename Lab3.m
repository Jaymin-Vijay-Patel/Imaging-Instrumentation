%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  02/17/16
%---------------------------------------------------
%Laboratory 3. Autofocus.

% C = Camera(0);
% S = APT.getstage('linear');
% S.velocity = 40;
% pixelclock = 7; %Set the speed of pixel readout.

% %Part 1. Collect data to determine how to write autofocus.
%     aoi = [0 0 1280 1024]; %AOI.
%     exposure = 25; %Exposure time in milliseconds.
%     frames = 1; %Number of frames to capture.
%     S.home();
%     positions = 0:1:100;
%     positions = 40:0.2:70;
%     A = zeros(aoi(3),aoi(4),numel(positions));
%     for i = 1:numel(positions)
%         S.move_abs(positions(i));
%         A(:,:,i) = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
%     end
%     fftA = zeros(size(A));
%     powerA = zeros(1,numel(positions));
%     for i = 1:numel(positions)
%         fftA(:,:,i) = fftshift(fft2(A(:,:,i)));
%     end
%     for i = 1:numel(positions)
%         fftAi = fftA(:,:,i);
%         powerA(i) = sum(log(abs(fftAi(:)).^2+1));
%     end
%     figure; plot(positions,powerA);
%     for i = 1:numel(positions)
%         subplot(1,2,1); colormap('gray'); imagesc(A(:,:,i)'); axis('image'); colorbar;
%         subplot(1,2,2); colormap('gray'); imagesc(log(abs(fftA(:,:,i)+1))'); axis('image'); colorbar;
%         pause(0.1);
%     end

%Part 2. Time auto_focus.m.
    aoi_full = [0 0 1280 1024]; %AOI.
    exposure = 25; %Exposure time in milliseconds.
    frames = 1; %Number of frames to capture.
    S.home(); tic; [focus3,position3,A_power3] = auto_focus(C,S,{'pixelclock',pixelclock},{'aoi',aoi_full},{'exposure',exposure},{'frames',frames},{'steps',3}); toc;
    A3 = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
    S.home(); tic; [focus4,position4,A_power4] = auto_focus(C,S,{'pixelclock',pixelclock},{'aoi',aoi_full},{'exposure',exposure},{'frames',frames},{'steps',4}); toc;
    A4 = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
    S.home(); tic; [focus5,position5,A_power5] = auto_focus(C,S,{'pixelclock',pixelclock},{'aoi',aoi_full},{'exposure',exposure},{'frames',frames},{'steps',5}); toc;
    A5 = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
    S.home(); tic; [focus10,position10,A_power10] = auto_focus(C,S,{'pixelclock',pixelclock},{'aoi',aoi_full},{'exposure',exposure},{'frames',frames},{'steps',10}); toc;
    A10 = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
    S.home(); tic; [focus20,position20,A_power20] = auto_focus(C,S,{'pixelclock',pixelclock},{'aoi',aoi_full},{'exposure',exposure},{'frames',frames},{'steps',20}); toc;
    A20 = capture_frames(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',frames});
    
%     figure; subplot(1,3,1); imagesc(A1');colorbar; axis('image'); colormap('gray'); hold on; 
%     subplot(1,3,2); imagesc(A2');colorbar;axis('image'); colormap('gray'); hold on;
%     subplot(1,3,3); imagesc(A3');colorbar;axis('image'); colormap('gray');
%     

% delete(C);
% clear C;
% delete(S);