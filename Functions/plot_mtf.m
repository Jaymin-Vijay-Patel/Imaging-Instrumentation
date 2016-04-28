function [F,FFT,MTF,LSF,region] = plot_mtf(A,pixel_size,image_size,region)
%PLOT_MTF Plots the 1D profile of an MTF function using FIND_MTF.
%   A is either the image or LSF.
%   pixel_size is the pixel size.
%   image_size is the number of pixels
%   region is defined in FIND_MTF
    if size(A,1)~=1 && size(A,2)~=1
        if exist('region','var')
            [MTF,region,LSF] = find_mtf(A,'edge',region);
        else
            [MTF,region,LSF] = find_mtf(A,'edge');
        end
    else
        LSF = A;
    end
    FFT = fftshift(fft(LSF,image_size));
    F = 1/(pixel_size*image_size)*(-image_size/2:image_size/2-1);
    figure; plot(F,abs(FFT));
end