dim = [1024 1024];
% dim = [1 8];
% img = zeros(dim);
% img(1:2:end) = 1;
% 
% img = zeros(dim);
% up = [0 1];
% switch_angle = pi/12;
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
% rdim = [256 256];
% % rdim = [1 4];
% 
% [xt,yt] = meshgrid(0:dim(1)/rdim(1)-1, 0:dim(2)/rdim(2)-1);
% imgs = fproj(img, rdim, xt, yt);
% figure; disp_image(imgs(:,:,:));

%%
x1 = 325;
x2 = 655;
d = 10;
pixel_size = d/(x2-x1);

Xn = superresolution(imgs,4,[1 1],0.1,20);
% aimg = zeros(dim);

% for i=1:20
%     aimgs = fproj(aimg, rdim, xt, yt);
%     simgs = sign(aimgs-imgs);
%     bimgs = bproj(simgs, dim, xt, yt);
%     bimg = sum(bimgs, 3);
%     aimg = aimg-0.1*bimg;
% end

figure; disp_image(Xn);