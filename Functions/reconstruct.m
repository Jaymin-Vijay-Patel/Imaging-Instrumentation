function [recon_image,sinogram,u0,sinogram_u0] = reconstruct(images,lines,I0,dark_current,u0,recon_pixels,SAD,pixel_size)
%RECONSTRUCT Reconstruct an image using filtered backprojection on a set of captured images at different angles.
%
%Syntax:    RECONSTRUCT(sinogram,recon_pixels,SAD,pixel_size)
%
%Input:     images       - 3-D array containing captured images for each angle in the 3rd dimension.
%           lines        - Number of lines around the center of the image to average.
%           I0           - Gain image associated with the number of photons incident on the phantom and any systemic sensitivities.
%           dark_current - Dark current image at the exposure at which the images were captured.
%           u0           - Distance of the central ray to the origin of the detector.
%           recon_pixels - Reconstructed image size.
%           SAD          - Source to axis distance. 
%           pixel_size   - Pixel size. 
%
%Output:    recon_image - Reconstructed image.
%           sinogram    - Sinogram.
%           u0          - Distance of the central ray to the origin of the detector.
%           sinogram_u0 - Sinogram adjusted by u0.
%
%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  04/05/16
%---------------------------------------------------
%Assemble a sinogram.
    lines_index = size(images,2)/2-floor(lines/2):size(images,2)/2+floor(lines/2);
    images_slice = double(images(:,lines_index,:));
    dark_current_slice = repmat(dark_current(:,lines_index),1,1,size(images,3));
    I0_slice = double(repmat(I0(:,lines_index),1,1,size(images,3)));
    sinogram = squeeze(mean((images_slice-dark_current_slice)./I0_slice,2));
%Adjust the sinogram by u0.
    if isempty(u0)
        h = figure;
        button = 'No';
        while strcmp(button,'No')
            colormap('gray'); imagesc(sinogram');
            title('Set u0.');
            [u0,~] = ginput(1);
            u0 = round(u0);
            colormap('gray'); imagesc(sinogram(u0:end,:)');
            button = questdlg('Use this u0?','','Yes','No','Yes');
            if strcmp(button,'Yes')
                close(h);
            elseif strcmp(button,'No')
                clf(h);
            end
        end
    end
    sinogram_u0 = sinogram(u0:end,:);
%Filter the projections.
    proj_pixels = size(sinogram_u0,1); %Number of pixels in an individual projection.
    log_sinogram = -log(sinogram_u0); %Attentuation coefficients from exponential.
    weighting_function = 2/recon_pixels*abs(linspace(-1,1,proj_pixels)); %Weighting function to approximate pie-shaped regions in Fourier space from strip-shaped regions.
    filtered_sinogram = real(ifft((ifftshift(fftshift(fft(log_sinogram))'*diag(weighting_function))'))); %Applying weighting function in Fourier space.

proj_centers = find_centers(proj_pixels,proj_pixels,pixel_size);
cg = [0 SAD]; %The unrotated focal point of the system.

recon_centers = find_centers(recon_pixels,proj_pixels,pixel_size); %The distance from centers of each pixel of recon_img to the center of recon_img in mm.
[X0,Y0] = meshgrid(recon_centers,recon_centers);

recon_image = zeros(recon_pixels); %Reconstructed image.
for i = 1:size(images,3)
    theta = -deg2rad(i-1);
    R_theta = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    XY_theta = [X0(:) Y0(:)]*R_theta;

    xs = cg(1) + cg(2) * (XY_theta(:,1) - cg(1)) ./ (cg(2) - XY_theta(:,2));
    vals = reshape(interp1(proj_centers, filtered_sinogram(:,i), xs), size(recon_image));
    recon_image = recon_image+vals;
end
recon_image(recon_image<0) = 0;

end

function pixel_centers = find_centers(recon_pixels,proj_pixels,pixel_size)
    R = (1:recon_pixels)'-(recon_pixels+1)/2;
    v = pixel_size*proj_pixels;
    n = recon_pixels;
    pixel_centers = v/n*R;
end