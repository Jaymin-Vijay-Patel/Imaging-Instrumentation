%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  04/22/16
%---------------------------------------------------
%Final Project. Jaymin's Updates.

%Create some phantoms
    %Line phantom.
%         dim = [1 8];
%         line_phantom = zeros(dim);
%         line_phantom(1:2:end) = 1;
%         line_rdim = [1 4];
    %Star pattern phantom.
%         dim = [1024 1024];
%         star_phantom = zeros(dim);
%         up = [0 1];
%         switch_angle = pi/12;
%         for ii=1:dim(1)
%             for jj=1:dim(2)
%                 v = [ii jj] - dim/2;
%                 a = acos(v * up' / norm(v));
%                 if xor(mod(a,switch_angle) > switch_angle/2, ii > dim(1)/2)
%                     star_phantom(ii,jj) = 1;
%                 end
%             end
%         end
%         disp_image(star_phantom);
%         star_rdim = [256 256];

%Downsample and move the phantom.
%     phantom = star_phantom;
%     rdim = star_rdim;
%     [xt,yt] = meshgrid(0:dim(1)/rdim(1)-1, 0:dim(2)/rdim(2)-1);
%     phantom_images = fproj(phantom, rdim, xt, yt);
%     figure; disp_image(phantom_images(:,:,:));

%Generate high resolution images.
    beta = 0.1;
    steps = 20;

    %High resolution from phantom
%         factor = dim./rdim;
%         pixel_shift = [1 1];
%         Xn = superresolution(phantom_images,factor,pixel_shift,beta,steps);
%         figure; disp_image(Xn);
    
    %High resolution from collected data.
%         load('C:\My Files\School\JHU\2015-2016\Classes\EN.580.693 Imaging Instrumentation\Final Project\FinalProject_Star_005_13x13.mat')
        data_images = star_low_005_13x13;
        aoi = [0 0 50 50];
        shift = [0.005 0.005]; %mm.
        pixel_size = 10/330; %mm.
        factor = round(pixel_size./shift)-1;
        pixel_shift = shift./pixel_size;
        dim = size(data_images);
        data_images = data_images(dim(1)/2-aoi(3)/2:dim(1)/2+aoi(3)/2,dim(2)/2-aoi(4)/2-1:dim(2)/2+aoi(4)/2-1,:,:);
        Xn = superresolution(data_images,factor,pixel_shift,beta,steps);
        figure; disp_image(Xn);