function h = disp_image(A,titleA)
%DISP_IMAGE Display an image.
%
%Syntax:    DISP_IMAGE(A,titleA)
%           h = DISP_IMAGE(...)
%
%Input:     A      - An image array; the 3rd dimension can contain frames.
%           titleA - Figure title.
%
%Output     h - Cell containing figure and colorbar handles.
%
%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  02/16/16
%---------------------------------------------------

%SET INPUTS
%---------------------------------------------------
%Check the number of inputs.
    narginchk(1,2);
%Check A.
    if ~isnumeric(A) || size(A,1)<2 || size(A,2)<2
        throw(MException([mfilename ':in_A'],'\t"A" must be at least a 2 dimensional numeric array.'));
    end
%---------------------------------------------------
%RUN FUNCTION
%---------------------------------------------------
h = cell(1,2);
if nargout==1
    h{1} = figure;
end
for i = 1:size(A,3)
    if mod(i,2) == 0
        r4 = 1:size(A,4);
    else
        r4 = size(A,4):-1:1;
    end
    for p = r4
        colormap('gray'); imagesc(A(:,:,i,p)'); axis('image'); h{2} = colorbar;
        if size(A,3)>1 || size(A,4) > 1
            pause(0.1);
        end
    end

end
end