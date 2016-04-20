dim = 1024;

img = zeros(dim);
up = [0 1];
switch_angle = pi/12;
for ii=1:dim
    for jj=1:dim
        v = [ii jj] - [dim/2 dim/2];
        a = acos(v * up' / norm(v));
        if xor(mod(a,switch_angle) > switch_angle/2, ii > dim/2)
            img(ii,jj) = 1;
        end
    end
end

imagesc(img);

%%
rdim = 256;

[xt,yt] = meshgrid(0, 0:dim/rdim);
imgs = fproj(img, rdim, xt, yt);
disp_image(imgs(:,:,:));

%%
aimg = zeros(dim);

for i=1:20
    aimgs = fproj(aimg, rdim, xt, yt);
    simgs = sign(aimgs - imgs);
    aimg = sum(bproj(simgs, dim, xt, yt), 3);
end

disp_image(aimg);
