function S = superresolution(Yk,r,Hk,beta,N,alpha,lambda,P,pixelL,show)
%SUPERRESOLUTION .
%   Detailed description.
%
%Syntax:    Xn_hat = SUPERRESOLUTION(Yk,factor,alpha,beta,lambda,P,N,show_debug,psf)
%
%Input:     Yk     - Low resolution images [y x y_shift x_shift].
%           r      - Resolution enhancement factor.
%           Hk     - Camera point spread function.
%           beta   - Scalar defining step size in direction of the gradient.
%           N      - Steps to use for steepest descent.
%           alpha  - 
%           lambda - 
%           P      - 
%           pixelL - Pixel size at low resolution.
%           show   - Display. 
%
%Output:    S - Struct containing superresolution image and parameters.
%               Xn_hat  -- High resolution image.
%               Y0      -- A low resolution image.
%               time    -- Elapsed time.
%               r       -- Resolution enhancement factor.
%               Hk      -- Camera point spread function.
%               beta    -- Scalar defining step size in direction of the gradient.
%               N       -- Steps to use for steepest descent.
%               alpha   -- 
%               lambda  -- 
%               P       -- 
%               x_shift -- 
%               y_shift -- 
%               pixelL  -- Pixel size at low resolution.
%               pixelH  -- Pixel size at high resolution.
%
%See also:
%Required   BPROJ, FPROJ
%
%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  04/27/16
%---------------------------------------------------
%Start timer.
    tic;
    
%Initialize a struct S.
    S = struct(...
            'Xn_hat',[],...
            'Y0',Yk(:,:,1,1),...
            'time',[],...
            'r',r,...
            'Hk',Hk,...
            'beta',beta,...
            'alpha',alpha,...
            'lambda',lambda,...
            'P',P...
        );
    
%Assign image dimensions and initiliaze high resolution image Xn_hat.
    if numel(r)==1
        r = [r r];
    end
    Y_dim = [size(Yk,1) size(Yk,2)]; %Low resolution dimensions.
    X_dim = r.*Y_dim; %High resolution dimensions.
    S.Xn_hat = zeros(X_dim); %High resolution image.
    
%Determine the high resolution subpixel shifts.
    [S.x_shift,S.y_shift] = meshgrid(1:size(Yk,3),1:size(Yk,4));
    for ii = 1:size(Yk,3)
        for jj = 1:size(Yk,4)
            regout = dftregistration(fft2(Yk(:,:,ii,jj)), fft2(Yk(:,:,1,1)),100); %Use dftregistration to determine the low resolution subpixel shifts.
            S.x_shift(ii,jj) = regout(4);
            S.y_shift(ii,jj) = regout(3);
        end
    end
    S.x_shift = r(2)*S.x_shift; %Multiply by the resolution enhancement factor to determine high resolution subpixel shifts.
    S.y_shift = r(1)*S.y_shift;

%Clear memory.
    clear_memory = false;
    
%Display steps.
    if show
        figure;
    end

%Determine the high resolution image with steepest descent.
    for nn = 1:N
        %Forward and back projections.
            Yk_hat = fproj(S.Xn_hat,Y_dim,S.x_shift,S.y_shift,Hk);
            sign_Yk_hat = sign(Yk_hat-Yk);
            if clear_memory
                clear('Yk_hat');
            end
            back_sign_Yk_hat = bproj(sign_Yk_hat,X_dim,S.x_shift,S.y_shift,Hk);
            if clear_memory
                clear('sign_Yk_hat');
            end
            Xn_hat_error = sum(sum(back_sign_Yk_hat,3),4);
            if clear_memory
                clear('back_sign_Yk_hat');
            end
        %Regularization.
            Xn_reg = zeros(X_dim);
            for l = -P:P
                for m = -P:P
                    Xn_reg_sign = sign(S.Xn_hat - imtranslate(S.Xn_hat, [l m]));
                    Xn_reg = Xn_reg + (Xn_reg_sign - imtranslate(Xn_reg_sign, [-l -m])) * alpha^(abs(m) + abs(l));
                end
            end
        %Calculate Xn_hat.
            S.Xn_hat = S.Xn_hat - beta*(Xn_hat_error + lambda * Xn_reg);
            if clear_memory
                clear('Xn_hat_error','Xn_reg');
            end
        %Display steps.
            if show
                disp_image(S.Xn_hat);
                set(gcf,'Name',sprintf('Step %d',nn));
                drawnow;
            end
    end
    
%Assign outputs into struct S.
    S.time = toc;
    if nueml(pixelL)==1
        pixelL = [pixelL pixelL];
    end
    S.pixelL = pixelL;
    S.pixelH = pixelL./r;
end