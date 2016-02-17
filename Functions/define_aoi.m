function aoi = define_aoi(varargin)
%DEFINE_AOI Determine an area of interest (AOI) for a DCC3240M camera.
%   Shows an image from the camera. Then the user selects one point if 
%   "dim" is set or two points if it is not.
%
%Syntax:    aoi = DEFINE_AOI()
%           aoi = DEFINE_AOI(...,A)
%           aoi = DEFINE_AOI(...,C)
%           aoi = DEFINE_AOI(...,dim)
%           aoi = DEFINE_AOI(...,parameter)
%
%Input:     A         - A 2D image array.
%           C         - Camera object.
%           dim       - Set AOI dimensions.
%           parameter - A cell containing {name,value}.
%
%                       Name        Value                                      Description
%                       ----        -----                                      -----------
%                       pixelclock  [1,inf) integers {7}                       Speed of pixel readout.
%                       exposure    [exposurerange(2),exposurerange(3)] double Exposure time in milliseconds.
%                       frames      [1,inf) integers {1}                       Number of frames.
%           options   - 'center'  Set a center point.
%
%Output:    aoi - Area of interest.
%
%See also:
%Required   CAMERA, CAPTURE_FRAMES.
%
%---------------------------------------------------
%Author:    Ang Li, Ho Namkung, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    ang.li@jhmi.edu, ho.namkung@jhmi.edu, jpatel18@jhmi.edu
%Revision:  02/16/16
%---------------------------------------------------

%SET INPUTS
%---------------------------------------------------
%Check the number of inputs.
    narginchk(0,5);
%Assign varargin.
    n = 1;
    options = {};
    while n<=numel(varargin)
        if isnumeric(varargin{n})
            if size(varargin{n},1)>1 && size(varargin{n},1)>2
                A = varargin{n};
                varargin(n) = [];
                n = n-1;
            else
                dim = varargin{n};
                varargin(n) = [];
                n = n-1;
            end
        elseif ischar(varargin{n})
            if any(strcmp(varargin{n},{'center'}))
                options{end+1} = varargin{n};
                varargin(n) = [];
                n = n-1;
            end
        end
        n = n+1;
    end
%Assign A.
    if exist('A','var')
        image = 'Array';
        modS = 2;
    else
        image = 'Camera';
        modS = 4;
    end
%Assign dim.
    aoi = [0 0 1280 1024];
    if exist('dim','var')
        if numel(dim)~=2 || ~isequal(round(dim),dim) || any(dim<1)
            throw(MException([mfilename ':in_aoi'],'\t"dim" must be a pair of integers greater than 1.'));
        end
        aoi(3) = dim(1);
        aoi(4) = dim(2);
    end
%---------------------------------------------------
%RUN FUNCTION
%---------------------------------------------------
    if ~exist('A','var')
        A = capture_frames(varargin{:});
    end
    h = figure;
    button = 'No';
    while strcmp(button,'No')
        colormap('gray'); imagesc(A'); axis('image'); colorbar;
        if ~exist('dim','var')
            title('Select two opposite corners.');
            [x,y] = ginput(2);
            aoi(1) = min(x);
            aoi(2) = min(y);
            aoi(3) = max(x)-min(x);
            aoi(4) = max(y)-min(y);
            if any(strcmp(options,'center'))
                title('Select a center point.');
                [xc,yc] = ginput(1);
            end
        else
            if any(strcmp(options,'center'))
                title('Select a center point.');
                [xc,yc] = ginput(1);
            else
                title('Select the top left corner.');
                [aoi(1),aoi(2)] = ginput(1);
            end
        end
        aoi = round(aoi);
        if any(strcmp(options,'center'))
            xc = round(xc);
            yc = round(yc);
            x1d = xc-aoi(1);
            y1d = yc-aoi(2);
            x2d = aoi(3)+aoi(1)-xc;
            y2d = aoi(4)+aoi(2)-yc;
            if x1d>x2d
                aoi(3) = aoi(3)+(x1d-x2d); 
            elseif x1d<x2d
                aoi(1) = aoi(1)-(x2d-x1d);
            end
            if y1d>y2d
                aoi(4) = aoi(4)+(y1d-y2d); 
            elseif y1d<y2d
                aoi(2) = aoi(2)-(y2d-y1d);
            end
        end
        if strcmp(image,'Camera')
            if aoi(1)+aoi(3)>1280
                aoi(3) = 1280-aoi(1);
            end
            if aoi(2)+aoi(4)>1024
                aoi(4) = 1024-aoi(2);
            end
        end
        aoi(3) = aoi(3)-rem(aoi(3),modS);
        aoi(4) = aoi(4)-rem(aoi(4),modS);
        rectangle('position',aoi,'EdgeColor','r');
        button = questdlg('Use this AOI?','','Yes','No','Yes');
        if strcmp(button,'Yes')
            close(h);
        elseif strcmp(button,'No')
            clf(h);
        end
    end
end