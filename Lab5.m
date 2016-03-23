%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  03/22/16
%---------------------------------------------------
%Laboratory 5. Spectral Imaging.

C = Camera(0);
pixelclock = 7; %Set the speed of pixel readout.
%Filters start at red.

%Part 1. Reflective Color Scene.    
%     Rvf = cell(1,7); %Reflective scene with variable focus for each filter.
%     Rsf = cell(1,7); %Reflective scene with set focus.
    aoi = [0 0 1280 1024]; %AOI.
    frames = 100; %Number of frames to capture.
    exposure = 100;
%     loop_camera(C,{'pixelclock',pixelclock},{'exposure',exposure},{'frames',1});
    [~,Rsf{1}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,Rsf{2}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,Rsf{3}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,Rsf{4}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,Rsf{5}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,Rsf{6}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    exposure = 25;
    [~,Rsf{7}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    R3D = cat(3,cat(3,Rsf{1:6})-repmat(D100,1,1,6),Rsf{7}-D25); %Subtract dark current at appropriate exposure time.
    
%Part 2. Transmissive Color Scene.
%     T = cell(1,7); %Transmissive scene.
    exposure = 100;
    [~,T{1}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,T{2}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,T{3}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,T{4}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,T{5}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    [~,T{6}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    exposure = 25;
    [~,T{7}] = capture_frames(C,{'pixelclock',pixelclock},{'aoi',aoi},{'exposure',exposure},{'frames',frames});
    T3D = cat(3,cat(3,T{1:6})-repmat(D100,1,1,6),T{7}-D25); %Subtract dark current at appropriate exposure time.
    
%Part 3. Analyze Data.
    %Form Color Images.
        %Determine Matrix A.
            e = 0.02;
            D = inv(diag(db1.*ds.*dl+e));
            A = inv(L'*L)*L'*D*F(1:5,:)'*inv(F(1:5,:)*F(1:5,:)');
        %Reflective.
            Rv = zeros(5,1280*1024);
            for i = 1:size(Rv,1)
                Rv(i,:) = reshape(permute(R3D(:,:,i)',[2 1]),1280*1024,1);
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
                Tv(i,:) = reshape(permute(T3D(:,:,i)',[2 1]),1280*1024,1);
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
            Rpca = zeros(1280,1024,5);
            for i = 1:size(Vr,2)
                Rpca(:,:,i) = reshape(Vr(:,i),[1280 1024]);
            end
        %Transmissive.
            [Ut,St,Vt] = svd(Tv,'econ');
            Tpca = zeros(1280,1024,5);
            for i = 1:size(Vt,2)
                Tpca(:,:,i) = reshape(Vt(:,i),[1280 1024]);
            end
    %K-Means Clustering
        %Reflective
            Ridx = kmeans(Rv',12,'MaxIter',1000);
            Rk = reshape(Ridx,[1280 1024]);
            imagesc(Rk'); colorbar;
        %Transmissive
            Tidx = kmeans(Tv',12,'MaxIter',1000);
            Tk = reshape(Tidx,[1280 1024]);
            imagesc(Tk'); colorbar;
            
%Generate figures for the report.
    %Figure 2: Diagram and matrix equation indicating the relationship 
    %          between the actual spectrum of light x(?) and the detected 
    %          spectrum of light at a pixel v(?).
        %Sensor spectral sensitivity.
            figure; plot(lambda,ds); title('Sensor (Ds)'); xlabel('Wavelength <nm>'); ylabel('Spectral Sensitivity');
        %Lens transmission.
            figure; plot(lambda,dl); title('Lens (Dl)'); xlabel('Wavelength <nm>'); ylabel('Transmission');
        %Filter transmissions.
            figure; plot(lambda,F(1,:),'Color',[255 0 0]/255); hold on;
            plot(lambda,F(2,:),'Color',[255 190 0]/255); hold on;
            plot(lambda,F(3,:),'Color',[163 255 0]/255); hold on; 
            plot(lambda,F(4,:),'Color',[0 255 146]/255); hold on;
            plot(lambda,F(5,:),'Color',[0 70 255]/255); hold on;
            plot(lambda,F(6,:),'Color',[131 0 181]/255);
            title('Filters (F)'); xlabel('Wavelength <nm>'); ylabel('Tranmission');
    %Figure 3: Diagram and matrix equation indicating the relationship
    %          between the inputted RGB values z and spectrum of light m 
    %          displayed by a monitor at a pixel.
        %White and RGB LEDs backlight spectra.
            figure; plot(lambda,db1); hold on; plot(lambda,db2); axis([300 700 0 1]); legend('White','RGB'); legend('boxoff');
            title('White/RGB LEDs (Db1/Db2)'); xlabel('Wavelength <nm>'); ylabel('Spectrum'); 
        %LCD RGB filter transmissions.
            figure; plot(lambda,L(:,1),'Color',[1 0 0]); hold on;
            plot(lambda,L(:,2),'Color',[0 1 0]); hold on;
            plot(lambda,L(:,3),'Color',[0 0 1]);
            title('LCD RGB Filters (L)'); xlabel('Wavelength <nm>'); ylabel('Transmission');
    %Figure 4: Reflective color scene images through each filter and without filter.
        figure; colormap('gray');
        subplot(3,3,1); imagesc(R3D(:,:,1)'); axis('image'); colorbar;
        title('Reflective Scene 650 nm Filter');
        subplot(3,3,2); imagesc(R3D(:,:,2)'); axis('image'); colorbar;
        title('Reflective Scene 600 nm Filter');
        subplot(3,3,3); imagesc(R3D(:,:,3)'); axis('image'); colorbar;
        title('Reflective Scene 550 nm Filter');
        subplot(3,3,4); imagesc(R3D(:,:,4)'); axis('image'); colorbar;
        title('Reflective Scene 500 nm Filter');
        subplot(3,3,5); imagesc(R3D(:,:,5)'); axis('image'); colorbar;
        title('Reflective Scene 450 nm Filter');
        subplot(3,3,6); imagesc(R3D(:,:,6)'); axis('image'); colorbar;
        title('Reflective Scene 400 nm Filter');
        subplot(3,3,8); imagesc(R3D(:,:,7)'); axis('image'); colorbar;
        title('Reflective Scene No Filter');
    %Figure 6: Transmissive color scene images through each filter and without filter.
        figure; colormap('gray');
        subplot(3,3,1); imagesc(T3D(:,:,1)'); axis('image'); colorbar;
        title('Transmissive Scene 650 nm Filter');
        subplot(3,3,2); imagesc(T3D(:,:,2)'); axis('image'); colorbar;
        title('Transmissive Scene 600 nm Filter');
        subplot(3,3,3); imagesc(T3D(:,:,3)'); axis('image'); colorbar;
        title('Transmissive Scene 550 nm Filter');
        subplot(3,3,4); imagesc(T3D(:,:,4)'); axis('image'); colorbar;
        title('Transmissive Scene 500 nm Filter');
        subplot(3,3,5); imagesc(T3D(:,:,5)'); axis('image'); colorbar;
        title('Transmissive Scene 450 nm Filter');
        subplot(3,3,6); imagesc(T3D(:,:,6)'); axis('image'); colorbar;
        title('Transmissive Scene 400 nm Filter');
        subplot(3,3,8); imagesc(T3D(:,:,7)'); axis('image'); colorbar;
        title('Transmissive Scene No Filter');
    %Figure 10. PCA with SVD of the reflective scene narrowband channels.
        figure; colormap('gray');
        subplot(2,3,1); imagesc(Rpca(:,:,1)'); axis('image'); colorbar;
        title('Reflective Scene SVD Channel 1');
        subplot(2,3,2); imagesc(Rpca(:,:,2)'); axis('image'); colorbar;
        title('Reflective Scene SVD Channel 2');
        subplot(2,3,3); imagesc(Rpca(:,:,3)'); axis('image'); colorbar;
        title('Reflective Scene SVD Channel 3');
        subplot(2,3,4); imagesc(Rpca(:,:,4)'); axis('image'); colorbar;
        title('Reflective Scene SVD Channel 4');
        subplot(2,3,5); imagesc(Rpca(:,:,5)'); axis('image'); colorbar;
        title('Reflective Scene SVD Channel 5');
    %Figure 11. PCA with SVD of the transmissive scene narrowband channels.
        figure; colormap('gray');
        subplot(2,3,1); imagesc(Tpca(:,:,1)'); axis('image'); colorbar;
        title('Transmissive Scene SVD Channel 1');
        subplot(2,3,2); imagesc(Tpca(:,:,2)'); axis('image'); colorbar;
        title('Transmissive Scene SVD Channel 2');
        subplot(2,3,3); imagesc(Tpca(:,:,3)'); axis('image'); colorbar;
        title('Transmissive Scene SVD Channel 3');
        subplot(2,3,4); imagesc(Tpca(:,:,4)'); axis('image'); colorbar;
        title('Transmissive Scene SVD Channel 4');
        subplot(2,3,5); imagesc(Tpca(:,:,5)'); axis('image'); colorbar;
        title('Transmissive Scene SVD Channel 5');
        
% delete(C);
% clear C;