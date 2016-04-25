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