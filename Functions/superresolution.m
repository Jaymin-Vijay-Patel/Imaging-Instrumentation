function Xn_hat = superresolution(Yk,factor,alpha,beta,lambda,P,steps)
%SUPERRESOLUTION:  

Y_dim = [size(Yk,1) size(Yk,2)];
X_dim = [size(Yk,1) size(Yk,2)].*factor;

Xn_hat = zeros(X_dim);
[xt,yt] = meshgrid(0:size(Yk,3)-1,0:size(Yk,4)-1);
%xt = xt * .5;
%yt = yt * .5;
for N = 1:steps
    Yk_hat = fproj(Xn_hat,Y_dim, xt, yt);
    sign_Yk_hat = sign(Yk_hat-Yk);
    back_sign_Yk_hat = bproj(sign_Yk_hat, X_dim, xt, yt);
    Xn_hat_error = sum(sum(back_sign_Yk_hat,3),4);
    Xn_reg = zeros(X_dim);
    for l = 0:P
        for m = -l:P
            Xn_reg_sign = sign(Xn_hat - imtranslate(Xn_hat, [l m]));
            Xn_reg = Xn_reg + (Xn_reg_sign - imtranslate(Xn_hat, [-l -m])) * alpha^(abs(m) + abs(l));
        end
    end
    Xn_hat = Xn_hat-beta*(Xn_hat_error + lambda * Xn_reg);
end
end