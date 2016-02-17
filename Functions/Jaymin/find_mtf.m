function [mtf,region] = find_mtf(A,type,varargin)
%FIND_MTF Find the MTF from an line pair, edge, or star.
%
%Syntax:    mtf = FIND_MTF(A,type)
%           mtf = FIND_MTF(...,angle)
%
%Input:     A      - An image array.
%           type   - Image type.
%                     'line'     Line pair.
%                     'edge'     Edge.
%                     'star'     Star.
%           angle  - {'hough'} Calculate the angle of the edge or line with the Hough transform.
%                    'manual' Select points on the line to calculate the angle.
%           region - A cell containing area of interest and crop to reproduce data.
%
%Output:    mtf    - Modulation transfer function of array A.
%           region - A cell containing area of interest and crop.
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
    narginchk(2,3);
%Check A.
    if ~isnumeric(A) || size(A,3)<1
        throw(MException([mfilename ':in_A'],'\t"A" must be a 2 dimensional numeric array.'));
    end
%Check type.
    if ~any(strcmp(type,{'line','edge','star'}))
        throw(MException([mfilename ':in_type'],'\t"type" must ''line'', ''edge'', or ''star''.'));
    end
    if any(strcmp(type,{'line','star'}))
        throw(MException([mfilename ':in_type'],'\t"type" must ''line'' and ''star'' are unsupported.'));
    end
%Check varargin.
    for n = 1:nargin-2
        if ischar(varargin{n})
            if any(strcmp(varargin{n},{'hough','manual'}))
                angle = varargin{n};
            else
                throw(MException([mfilename ':in_varargin'],'\tUnrecognized string input.'));
            end
        elseif iscell(varargin{n})
            region = varargin{n};
        else
            throw(MException([mfilename ':in_varargin'],'\tUnrecognized input.'));
        end
    end
%Set angle.
    if ~exist('angle','var')
        angle = 'hough';
    end
%---------------------------------------------------
%RUN FUNCTION
%---------------------------------------------------
    if exist('region','var');
        aoi = region{1};
    else
        aoi = define_aoi(A,'center');
    end
    A_aoi = A(aoi(1):aoi(1)+aoi(3),aoi(2):aoi(2)+aoi(4));    
    if any(strcmp(type,{'line','edge'}))
        if strcmp(angle,'hough')
            A_aoi = A_aoi/max(A_aoi(:));
            ibw = edge(A_aoi,'canny');
            [H,theta,rho] = hough(ibw);
            peaks = houghpeaks(H,1);
            lines = houghlines(ibw,theta,rho,peaks);
%             figure,imagesc(ibw),colorbar;
%             hold on
            xy = [lines(1).point1; lines(1).point2];
%             disp(xy);
%             plot(xy(:,1),xy(:,2),'Color','g','LineWidth',2);
%             hold off;
            l = xy(2,:)-xy(1,:);
            theta = acos(dot(l,[1 0])/norm(l));
            A_rotate = imrotate(A_aoi,-radtodeg(theta),'bilinear','crop');
%             disp_image(A_rotate,'Rotated image.');
        elseif strcmp(angle,'manual')
            button = 'No';
            while strcmp(button,'No')
                disp_image(A_aoi,'Select two points along the line.');
                [x,y] = ginput(2);
                theta = atan((y(1)-y(2))/(x(2)-x(1)));
                A_rotate = imrotate(A_aoi,radtodeg(theta),'bilinear','crop');
                disp_image(A_rotate,'Rotated image.');
                button = questdlg('Is this rotation acceptable?','','Yes','No','Yes');
            end
        end
        if exist('region','var');
            crop = region{2};
        else
            crop = define_aoi(A_rotate);
        end
        if ~exist('region','var')
            region = {aoi,crop};
        end
        A_crop = A_rotate(crop(1):crop(1)+crop(3),crop(2):crop(2)+crop(4));  
        A_line = sum(A_crop,2);
        A_line = A_line(:);
        if strcmp(type,'line')
           	A_lsf = A_line;
        elseif strcmp(type,'edge')
            A_lsf = [diff(A_line); 0];
        end
        A_fft = fft(A_lsf);
        mtf = zeros(size(A_fft,1),size(A_fft,1));
        center = size(mtf)/2;
        for i = 1:size(mtf,1)
            for j = 1:size(mtf,2)
                r = norm([i,j]-center);
                mtf(i,j) = interp1(abs(A_fft),r+1);
            end
        end
    elseif strcmp(type,'star')
    end
end