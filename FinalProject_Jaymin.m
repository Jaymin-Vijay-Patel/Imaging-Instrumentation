%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  04/28/16
%---------------------------------------------------
%Final Project. Jaymin.

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
        
    figure;
    colormap('gray');
    for i = 1:6
        subplot(2,3,i); imagesc(star_high(i).Xn_hat(280:450,310:480)); title(['Exposure = ' num2str(exposure(i)) ' <ms>']); axis('image'); h{2} = colorbar;
    end