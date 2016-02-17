%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  02/12/16
%---------------------------------------------------
%Laboratory 3. Autofocus.

% C = Camera(0);
% S = APT.getstage('linear');
pixelclock = 7; %Set the speed of pixel readout.
aoi = [0 0 1280 1024]; %AOI.
exposure = 25; %Exposure time in milliseconds.
frames = 1; %Number of frames to capture.

S.home();
% positions = 0:1:100;
positions = 40:0.2:70;
A = zeros(aoi(3),aoi(4),numel(positions));
for i = 1:numel(positions)
    S.move_abs(positions(i));
    A(:,:,i) = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',1});
end
fftA = zeros(size(A));
powerA = zeros(1,numel(positions));
windowA = 0;
for i = 1:numel(positions)
    fftA(:,:,i) = fftshift(fft2(A(:,:,i)));
end
for i = 1:numel(positions)
    fftAi = fftA(:,:,i);
    fftAi(aoi(3)/2-windowA:aoi(3)/2+windowA,aoi(4)/2-windowA:aoi(4)/2+windowA) = 0;
    powerA(i) = sum(abs(fftAi(:)))^2;
end
figure; plot(positions,powerA);
% for i = 1:numel(positions)
%     subplot(1,2,1); colormap('gray'); imagesc(A(:,:,i)'); axis('image'); colorbar;
%     subplot(1,2,2); colormap('gray'); imagesc(log(abs(fftA(:,:,i)+1))'); axis('image'); colorbar;
%     pause(0.1);
% end
