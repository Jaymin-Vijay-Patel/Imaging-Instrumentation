function covA = cov_pixel(A,pixel)
%COV_PIXEL Compute the covariance at a pixel given a set of frames.
%
%Syntax:    covA = COV_PIXEL(A,pixel)
%
%Input:     A     - An image array where the 3rd dimension is the frames.
%           pixel - A 2 element vector containing pixel row and column.
%
%Output:    covA - Covariance array for the selected pixel.
%
%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  02/10/16
%---------------------------------------------------

%SET INPUTS
%---------------------------------------------------
%Check A.
    if ~isnumeric(A) || size(A,3)<2
        throw(MException([mfilename ':in_A'],'\t"A" must be a 3 dimensional numeric array.'));
    end
%Check pixel.
    if ~isnumeric(pixel) || numel(pixel)~=2 || ~isequal(round(pixel),pixel) || any(pixel<1) || pixel(1)>size(A,1) || pixel(2)>size(A,2)
        throw(MException([mfilename ':in_pixel'],'\t"pixel" must be a 2 element vector with integer values within the size of "A".'));
    end
%---------------------------------------------------
%RUN FUNCTION
%---------------------------------------------------
meanA = mean(A,3);
difA = double(A)-repmat(meanA,1,1,size(A,3));
difPixel = difA(pixel(1),pixel(2),:);
covA = mean(repmat(difPixel,100,100,1).*difA,3);
end