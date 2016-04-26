function Xn_hat = superresolution(Yk,factor,alpha,beta,lambda,P,N,show_debug,psf)
%SUPERRESOLUTION:
tic
sf = size(factor);
if sf(1) == 1 && sf(2) == 1
    factor = [1 1] * factor;
end

Y_dim = [size(Yk,1) size(Yk,2)];
X_dim = [size(Yk,1) size(Yk,2)].*factor;

Xn_hat = zeros(X_dim);
[xt,yt] = meshgrid(1:size(Yk,3),1:size(Yk,4));
for ii=1:size(Yk,3)
    for jj=1:size(Yk,4)
        regout = dftregistration(fft2(Yk(:,:,ii,jj)), fft2(Yk(:,:,1,1)),100);
        xt(ii,jj) = regout(4);
        yt(ii,jj) = regout(3);
    end
end
xt = factor(2) * xt;
yt = factor(1) * yt;

%return
do_clear_memory = 0;
if show_debug ~= 0
    xt
    yt
    figure;
end
for nn = 1:N
    if ~exist('psf','var')
        Yk_hat = fproj_psf(Xn_hat,Y_dim, xt, yt);
    else
        Yk_hat = fproj_psf(Xn_hat,Y_dim, xt, yt, psf);
    end
    sign_Yk_hat = sign(Yk_hat-Yk);
    if do_clear_memory > 0
        clear('Yk_hat');
    end
    if ~exist('psf','var')
        back_sign_Yk_hat = bproj_psf(sign_Yk_hat, X_dim, xt, yt);
    else
        back_sign_Yk_hat = bproj_psf(sign_Yk_hat, X_dim, xt, yt, psf);
    end
    if do_clear_memory > 0
        clear('sign_Yk_hat');
    end
    Xn_hat_error = sum(sum(back_sign_Yk_hat,3),4);
    if do_clear_memory > 0
        clear('back_sign_Yk_hat');
    end
    Xn_reg = zeros(X_dim);
    for l = -P:P
        for m = -P:P
            Xn_reg_sign = sign(Xn_hat - imtranslate(Xn_hat, [l m]));
            Xn_reg = Xn_reg + (Xn_reg_sign - imtranslate(Xn_reg_sign, [-l -m])) * alpha^(abs(m) + abs(l));
        end
    end
    Xn_hat = Xn_hat - beta*(Xn_hat_error + lambda * Xn_reg);
    if do_clear_memory > 0
        clear('Xn_hat_error');
    end
    if show_debug ~= 0
        disp_image(Xn_hat);
        set(gcf,'Name',sprintf('Update %d',nn));
        drawnow
    end
end
toc
end
