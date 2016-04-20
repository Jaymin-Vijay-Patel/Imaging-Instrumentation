function img = motion_operator_2d(img,pixel_size,shift)
%MOTION_OPERATOR_2D Interpolate images based on position relative to first image.
%img is four dimensional. Rows are the 3rd dimension, columns are 4th dimension.

    X = pixel_size*(0:size(img,3)-1);
    Y = pixel_size*(0:size(img,4)-1);
    for i = 1:size(img,3)
        for j = 1:size(img,4)          
            XV = X+shift*(i-1);
            YV = Y+shift*(j-1);
            img(:,:,i,j) = interp2(X,Y,img(:,:,i,j),XV,YV);
        end
    end
end