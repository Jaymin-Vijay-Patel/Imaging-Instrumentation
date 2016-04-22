function Xn_hat = superresolution(Yk,factor,pixel_shift,beta,steps)
%SUPERRESOLUTION:  

Y_dim = [size(Yk,1) size(Yk,2)];
X_dim = [size(Yk,1) size(Yk,2)].*factor;

Xn_hat = zeros(X_dim);
[xt,yt] = meshgrid(0:pixel_shift(1):pixel_shift(1)*size(Yk,3)-pixel_shift(1),0:pixel_shift(2):pixel_shift(2)*size(Yk,4)-pixel_shift(2));
for N = 1:steps
    Yk_hat = fproj(Xn_hat,Y_dim, xt, yt);
    sign_Yk_hat = sign(Yk_hat-Yk); clear('Yk_hat');
    back_sign_Yk_hat = bproj(sign_Yk_hat, X_dim, xt, yt); clear('sign_Yk_hat');
    Xn_hat_error = sum(sum(back_sign_Yk_hat,3),4); clear('back_sign_Yk_hat');
    Xn_hat = Xn_hat-beta*Xn_hat_error; clear('Xn_hat_error');
end
end