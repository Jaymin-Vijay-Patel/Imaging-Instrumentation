%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  04/28/16
%---------------------------------------------------
%Final Project. Jaymin's Slides.

%Parameters
    alpha = 0.6;
    lambda = 0.005;
    P = 2;
    pixelL = 0.0303; %Pixel size in low resolution image <mm>.
    star_x = 430:790;
    star_y = 240:620;
    star_high = struct('Xn_hat',[],'Y0',[],'time',[],'r',[],'Hk',[],'beta',[],'alpha',[],'lambda',[],'P',[],'x_shift',[],'y_shift',[],'pixelL',[],'pixelH',[]);
    exposure = [7 14 28 57 114 227];
    for i = 1:numel(exposure)
        eval(['star_part = star_low_015_5x5_' num2str(exposure(i)) '(star_x,star_y,:,:);']);
        beta = 0.01*range(star_part(:));
        star_high(i) = superresolution(star_part,2,[],beta,20,alpha,lambda,P,pixelL,true); %r = 2, N = 20, Hk = [].
    end
    for i = 1:numel(exposure)
        star_high(i).exposure = exposure(i);
    end
    
%Low resolution images.
    figure;
    colormap('gray');
    for i = 1:6
        subplot(2,3,i); imagesc(star_high(i).Y0(140:225,155:240)); title(['Exposure = ' num2str(exposure(i)) ' <ms>']); axis('image'); h{2} = colorbar;
    end
    
%De-aliased images.
    figure;
    colormap('gray');
    for i = 1:6
        subplot(2,3,i); imagesc(star_high(i).Xn_hat(280:450,310:480)); title(['Exposure = ' num2str(exposure(i)) ' <ms>']); axis('image'); h{2} = colorbar;
    end
    
%Compare total power in power spectrums before and after de-aliasing at different exposure times.
    ps_low_total = zeros(1,numel(exposure));
    ps_high_total = zeros(1,numel(exposure));
    for i = 1:numel(exposure)
        ps_low = abs(fft2(star_high(i).Y0(140:225,155:240),171,171).^2);
        ps_high = abs(fft2(star_high(i).Xn_hat(280:450,310:480)).^2);
        ps_low_total(i) = sum(ps_low(:));
        ps_high_total(i) = sum(ps_high(:));
    end
    figure; plot(exposure,ps_low_total); hold on;
    plot(exposure,ps_high_total); legend('Low Resolution','High Resolution (after de-aliasing)');
    xlabel('Exposure Time <ms>');
    ylabel('Total Power <1/pixel^2>');
    axis([7 227 0 3e14]);
    figure; plot(exposure,ps_high_total./ps_low_total);
    xlabel('Exposure Time <ms>');
    ylabel('Total Power Ratio (High/Low)');
    axis([7 227 2 5]);
    
%Objects
    chipotle_part = chipotle_5x5_015_100_nofilter(400:600,50:250,:,:);
    chipotle_high_2 = superresolution(chipotle_part,2,[],10,100,alpha,lambda,P,pixelL,true);
    figure; disp_image(chipotle_high_2.Y0);
    figure; disp_image(chipotle_high_2.Xn_hat);  