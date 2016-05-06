% dim = [1024 1024];
% dim = [256 256];
% img = zeros(dim);
% up = [0 1];
% switch_angle = deg2rad(5);
% for ii=1:dim(1)
%     for jj=1:dim(2)
%         v = [ii jj] - dim/2;
%         a = acos(v * up' / norm(v));
%         if xor(mod(a,switch_angle) > switch_angle/2, ii > dim(1)/2)
%             img(ii,jj) = 1;
%         end
%     end
% end
% % 
% imagesc(img);

%%
% rdim = dim / 4;
% % rdim = [1 4];
% 
% [xt,yt] = meshgrid(0:dim(1)/rdim(1)-1, 0:dim(2)/rdim(2)-1);
%
% imgs = fproj(img, rdim, xt, yt);
% figure; disp_image(imgs(:,:,:));

%%

Xn = superresolution(imgs,2,.6,0.1,.005,2,100,1);
Xn(Xn < 0) = 0;
Xn(Xn > max(img(:))) = max(img(:));

figure; disp_image(Xn);

%% All calls pass 1 at the end for debug output.
star_part = star_low_005_13x13(500:800,300:600,:,:);
superresolution(star_part(:,:,1:3:end,1:3:end),2,.6,10,.005,2,20,1);
%% Larger reconstructed image requires a larger beta
superresolution(star_part(100:200,100:200,1:2:end,1:2:end),4,.6,15,.005,2,30,1);
%% More images used requires a smaller beta
superresolution(star_part(100:200,100:200,1:end,1:end),4,.6,4,.005,2,30,1);

%%
kp = knife_low_005_13x13(550:650,800:900,:,:);
[x_shift,y_shift] = meshgrid(1:size(kp,3),1:size(kp,4));
for ii = 1:size(kp,3)
    for jj = 1:size(kp,4)
        regout = dftregistration(fft2(kp(:,:,ii,jj)), fft2(kp(:,:,1,1)),100); %Use dftregistration to determine the low resolution subpixel shifts.
        x_shift(ii,jj) = regout(4);
        y_shift(ii,jj) = regout(3);
    end
end
s = 1:3:13;
knife_part = knife_low_005_13x13(200:1000,300:600,:,:);
knife_high_2 = superresolution(knife_part(:,:,s,s),2,[],1,100,alpha,lambda,2,pixelL,true,x_shift(s,s),y_shift(s,s));
thigh = knife_high_2.Xn_hat;
thigh(thigh < 0) = 0;

[F_high_2,FFT_high_2,MTF_high_2,LSF_high_2] = plot_mtf(thigh,knife_high_2.pixelH(1),1024);
[F_low,FFT_low,MTF_low,LSF_low] = plot_mtf(knife_part(:,:,1,1),pixelL,1024);

figure;
high_side = abs(FFT_high_2(512:end));
low_side = abs(FFT_low(512:end));
plot(F_low(512:end),low_side/max(low_side))
hold on
plot(F_high_2(512:end),high_side/max(high_side))
axis([0 35 0 1]);
legend('Original', '2x HR');
ylabel('MTF (normalized)');
xlabel('frequency (lines/mm)');
title('MTF (normalized) for original and reconstructed');