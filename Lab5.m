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
%     R2 = cell(1,7);
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
    exposure = 25;
    [~,R2{7}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
%     end
        
%Part 2. Transmissive Color Scene.
%     T = cell(1,7);
    exposure = 100;
    [~,T{1}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,T{2}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,T{3}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,T{4}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,T{5}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,T{6}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    exposure = 25;
    [~,T{7}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    
%Part 3. Analyze Data.
    %Form Color Images.
        %Determine Matrix A.
            e = 0.02;
            D = inv(diag(db1.*ds.*dl+e));
            A = inv(L'*L)*L'*D*F(1:5,:)'*inv(F(1:5,:)*F(1:5,:)');
        %Reflective.
            Rv = zeros(5,1280*1024);
            for i = 1:size(Rv,1)
                Rv(i,:) = R2{i}(:)';
            end
            Rz = A*Rv;
            Rrgb = zeros(1280,1024,3); 
            for i = 1:size(Rrgb,3)
                Rrgb(:,:,i) = reshape(Rz(i,:)',[1280 1024]);
            end
            Rrgb = Rrgb/max(Rrgb(:));
        %Transmissive.
            Tv = zeros(5,1280*1024);
            for i = 1:size(Tv,1)
                Tv(i,:) = T{i}(:)';
            end
            Tz = A*Tv;
            Trgb = zeros(1280,1024,3); 
            for i = 1:size(Trgb,3)
                Trgb(:,:,i) = reshape(Tz(i,:)',[1280 1024]);
            end
            Trgb = Trgb/max(Trgb(:));
    %Principal Component Analysis
        %Reflective.
            [Ur,Sr,Vr] = svd(Rv,'econ');
            Vnb = zeros(1280,1024,5);
            for i = 1:size(Vr,2)
                Vnb(:,:,i) = reshape(Vr(:,i),[1280 1024]);
            end
        %Transmissive.
            [Ut,St,Vt] = svd(Tv,'econ');
            Tnb = zeros(1280,1024,5);
            for i = 1:size(Tr,2)
                Tnb(:,:,i) = reshape(Tr(:,i),[1280 1024]);
            end
    %K-Means Clustering
        %Reflective
            Ridx = kmeans(Rv',12,'MaxIter',1000);
            Rk = reshape(Ridx,[1280 1024]);
            imagesc(Rk'); colorbar;
        %Transmissive
            
        
% delete(C);
% clear C;