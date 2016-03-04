%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  03/03/16
%---------------------------------------------------
%Laboratory 4. High Dynamic Range Imaging.

C = Camera(0);
pixelclock = 7; %Set the speed of pixel readout.

%Part 1. Determine a range of exposures to form an HDR acquisition.
    %A. Capture the images.
        aoi = [0 0 1280 1024]; %AOI.
        frames = 10; %Number of frames to capture.
        max_exposure = 227.806;
        min_exposure = 0.009;
        exposure = linspace(max_exposure,min_exposure,100); %Exposure times linearly spaced from the maximum to the minimum exposure.
        [~,~,~,A] = capture_hdr(C,{'pixelclock',7},{'aoi',aoi},{'exposure',exposure},{'frames',frames},'capture'); %Images of scene at each exposure.
        [~,~,~,D] = capture_hdr(C,{'pixelclock',7},{'aoi',aoi},{'exposure',exposure},{'frames',frames},'capture'); %Dark current images at each exposure.
        di = A<1023;
        As = A;
        As(di) = A(di)-D(di); %Image with dark current signal subtracted.
        As(As<0) = 0;
    %B. Determine which exposure times to use.
        F = [1.3,1.5,2]; %Determine a factor that generates a good HDR image.
        F_exp = cell(numel(F),1); %Exposure times separated by factors in milliseconds.
        fi = cell(numel(F)+1,1); %Indices of exposures closest to factor exposure times.
        for f = 1:numel(F)
            i = 0;
            while max_exposure/(F(f)^i)>min_exposure
                F_exp{f}(i+1) = max_exposure/(F(f)^i);
                i = i+1;
            end
            F_exp{f}(end+1) = min_exposure;
        end
        F(end+1) = 10;
        F_exp{end+1} = logspace(log10(max_exposure),log10(min_exposure),10);
        for f = 1:numel(F)
            for i = 1:numel(F_exp{f}) %Determine the indices of exposures closest to factor exposure times.
                [~,fi{f}(i)] = min(abs(exposure-F_exp{f}(i)));
            end
            fi{f} = unique(fi{f}); %Remove repeated exposure times.
            F_exp{f} = F_exp{f}(1:numel(fi{f}));
            F_exp{f}(end+1) = min_exposure;
        end
    
%Part 2. Determine an algorithm to assemble a HDR data set.
    [~,HDR,E] = capture_hdr(A,{'exposure',exposure},'hdr');
    [~,HDRs] = capture_hdr(As,{'exposure',exposure},'hdr');
    [~,HDRs_2] = capture_hdr(As(:,:,[1:2:100 100]),{'exposure',exposure([1:2:100 100])},'hdr'); %HDR image for half of the exposures equispaced.
    [~,HDRs_4] = capture_hdr(As(:,:,[1:4:100 100]),{'exposure',exposure([1:4:100 100])},'hdr'); %HDR image for quarter of the exposures equispaced. 
    HDR_F = cell(numel(F),1); %HDR images for factors 1.3, 1.5, 2, 10 (log).
    E_F = cell(numel(F),1);
    for f = 1:numel(F)
        [~,HDR_F{f},E_F{f}] = capture_hdr(As(:,:,fi{f}),{'exposure',F_exp{f}},'hdr');
    end
    
%Part 3. Compress image data into a HDR image.
    LDR = capture_hdr(A,{'exposure',exposure});
    LDRs = capture_hdr(As,{'exposure',exposure});

delete(C);
clear C;
    
%Generate figures for the report.
    %Figure 2. Images of the scene at different exposure times.
        figure; colormap('gray'); 
        I = [1,20,40,60,80,100];
        for i = 1:numel(I)
            subplot(3,2,i); imagesc(A(:,:,I(i))'); axis('image'); colorbar;
            title(['Exposure = ' num2str(exposure(I(i))) ' <ms>']);
        end
        
    %Figure 3. Image of scene at exposure 92.0482 ms before (left) and after (middle) subtracting dark current (right) from unsaturated pixels.
        figure; colormap('gray');
        subplot(1,3,1); imagesc(A(:,:,60)'); axis('image'); colorbar;
        title('Before removing dark current');
        subplot(1,3,2); imagesc(As(:,:,60)'); axis('image'); colorbar;
        title('After removing dark current');
        subplot(1,3,3); imagesc(D(:,:,60)'); axis('image'); colorbar;
        title('Dark current');
    
    %Figure 4. Comparing HDR images obtained with and without subtracting dark current noise using 100 exposures equispaced.
        figure; colormap('gray');
        subplot(1,2,1); imagesc(log(HDR')); axis('image'); colorbar;
        title('HDR with dark current noise');
        subplot(1,2,2); imagesc(log(HDRs')); axis('image'); colorbar;
        title('HDR with subtracted dark current noise');
    
    %Figure 5. Comparing equispaced HDR images to factor (1.3, 1.5, 2, 10) spaced HDR images.
        figure; colormap('gray');
        subplot(3,2,1); imagesc(log(HDRs')); axis('image'); colorbar;
        title('100 exposures equispaced');
        subplot(3,2,3); imagesc(log(HDRs_2')); axis('image'); colorbar;
        title('50 exposures equispaced');
        subplot(3,2,5); imagesc(log(HDRs_4')); axis('image'); colorbar;
        title('25 exposures equispaced');
        subplot(3,2,2); imagesc(log(HDR_F{1}')); axis('image'); colorbar;
        title('Exposures spaced by factors of 1.3');
        subplot(3,2,4); imagesc(log(HDR_F{3}')); axis('image'); colorbar;
        title('Exposures spaced by factors of 2');
        subplot(3,2,6); imagesc(log(HDR_F{4}')); axis('image'); colorbar;
        title('Exposures log spaced');
        
    %Figure 6. Number of saturated pixels at each exposure time.
        
