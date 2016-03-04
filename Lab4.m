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
        exposure = linspace(min_exposure,max_exposure,100); %Exposure times linearly spaced from the maximum to the minimum exposure.
        exposure = exposure(end:-1:1);
        [~,~,~,A] = capture_hdr(C,{'pixelclock',7},{'aoi',aoi},{'exposure',exposure},{'frames',frames},'capture'); %Images of scene at each exposure.
        [~,~,~,D] = capture_hdr(C,{'pixelclock',7},{'aoi',aoi},{'exposure',exposure},{'frames',frames},'capture'); %Dark current images at each exposure.
        di = A<1022;
        As = A;
        As(di) = A(di)-D(di); %Image with dark current signal subtracted.
    %B. Determine which exposure times to use.
        F = [1.3,1.5,2]; %Determine a factor that generates a good HDR image.
        F_exp = cell(numel(F),1); %Exposure times separated by factors in milliseconds.
        fi = cell(numel(F),1); %Indices of exposures closest to factor exposure times.
        for f = 1:numel(F)
            i = 0;
            while max_exposure/(F(f)^i)>min_exposure
                F_exp{f}(i+1) = max_exposure/(F(f)^i);
                i = i+1;
            end
            F_exp{f}(end+1) = min_exposure;
            for i = 1:numel(F_exp{f}) %Determine the indices of exposures closest to factor exposure times.
                [~,fi{f}(i)] = min(abs(exposure-F_exp{f}(i)));
            end
            fi{f} = unique(fi{f}); %Remove repeated exposure times.
            F_exp{f} = F_exp{f}(1:numel(fi{f}));
            F_exp{f}(end+1) = min_exposure;
        end
    
%Part 2. Determine an algorithm to assemble a HDR data set.
    [~,HDR,E] = capture_hdr(A,{'exposure',exposure},'hdr');
    [~,HDRs,Es] = capture_hdr(As,{'exposure',exposure},'hdr');
    HDR_F = cell(numel(F),1);
    E_F = cell(numel(F),1);
    for f = 1:numel(F)
        [~,HDR_F{f},E_F{f}] = capture_hdr(A(:,:,fi{f}),{'exposure',F_exp{f}},'hdr');
    end
    
%Part 3. Compress image data into a HDR image.
    LDR = capture_hdr(A,{'exposure',exposure});
    LDRs = capture_hdr(As,{'exposure',exposure});

delete(C);
clear C;
    
%Generate figures for the report.
    %Figure 2. Log spaced
        figure; colormap('gray'); 
        f2 = [];
        for i = f2
            subplot(2,5,i); hold on; imagesc(A(:,:,i)'); axis('image'); colorbar;
            title(['Exposure = ' num2str(exposure(i)) ' <ms>']);
        end
        
    %Figure 3.
        
    
    %Figure 4.
        
    
    %Figure 5.
        
