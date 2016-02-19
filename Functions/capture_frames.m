function varargout = capture_frames(varargin)
%CAPTURE_FRAMES Capture multiple frames from a DCC3240M camera.
%
%Syntax:    [A,meanA,varA,covA] = CAPTURE_FRAMES()
%           [...] = CAPTURE_FRAMES(...,C)
%           [...] = CAPTURE_FRAMES(...,parameter)
%
%Input:     C         - Camera object.
%           parameter - A cell containing {name,value}.
%
%                       Name        Value                                      Description
%                       ----        -----                                      -----------
%                       pixelclock  [1,inf) integers {7}                       Speed of pixel readout.
%                       aoi         [0<=x<=1280-xrange; 0<=y<=1024-yrange;     Area of interest within images where x and y determine the top left corner.
%                                   0<xrange<=1280; 0<yrange<=1024]        
%                                   {[0 0 1280 1024]}
%                       exposure    [exposurerange(2),exposurerange(3)] double Exposure time in milliseconds.
%                       frames      [1,inf) integers {1}                       Number of frames.
%
%Output:    A     - Image array.
%           meanA - Mean image array.
%           varA  - Variance image array.
%
%See also:
%Required   CAMERA.
%
%---------------------------------------------------
%Author:    Ang Li, Ho Namkung, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    ang.li@jhmi.edu, ho.namkung@jhmi.edu, jpatel18@jhmi.edu
%Revision:  02/09/16
%---------------------------------------------------

%SET INPUTS
%---------------------------------------------------
%Check the number of inputs.
    narginchk(0,5); 
%Assign varargin.
    setC = false;
    for n = 1:nargin
        if isa(varargin{n},'Camera')
            C = varargin{n};
            setC = true;
        elseif iscell(varargin{n})
            if numel(varargin{n})==2 && ischar(varargin{n}{1}) && any(strcmp(varargin{n}{1},{'pixelclock','aoi','exposure','frames'})) && isnumeric(varargin{n}{2})
                if strcmp(varargin{n}{1},'pixelclock')
                    pixelclock = varargin{n}{2};
                elseif strcmp(varargin{n}{1},'aoi')
                    aoi = varargin{n}{2};
                elseif strcmp(varargin{n}{1},'exposure')
                    exposure = varargin{n}{2};
                elseif strcmp(varargin{n}{1},'frames')
                    frames = varargin{n}{2};
                end
            else
                throw(MException([mfilename ':in_varargin'],'\tUnrecognized cell input.'));
            end
        else
            throw(MException([mfilename ':in_varargin'],'\tUnrecognized input.'));
        end
    end
%Assign C.
    if ~exist('C','var')
        C = Camera(0);
    end
%Assign pixelclock.
    if exist('pixelclock','var')
        if ~isequal(round(pixelclock),pixelclock) || pixelclock<1 || isinf(pixelclock)
            throw(MException([mfilename ':in_pixelclock'],'\t"pixelclock" must be an integer within [1,inf).'));
        end
        C.pixelclock = pixelclock;
    else
        if ~setC
            C.pixelclock = 7;
        end
    end    
%Assign aoi.
    if exist('aoi','var')
        if ~isequal(round(aoi),aoi)
            throw(MException([mfilename ':in_aoi'],'\t"aoi" must contain integers.'));
        end  
        if aoi(1)<0 || aoi(1)>1279
            throw(MException([mfilename ':in_aoi'],'\t"aoi(1)" (x) must be within 0<=x<=1280-xrange.'));
        end
        if aoi(2)<0 || aoi(2)>1023
            throw(MException([mfilename ':in_aoi'],'\t"aoi(2)" (y) must be within 0<=y<=1024-yrange.'));
        end
        if aoi(3)<1 || aoi(3)>1280
            throw(MException([mfilename ':in_aoi'],'\t"aoi(3)" (xrange) must be within 0<xrange<=1280.'));
        end
        if aoi(4)<1 || aoi(4)>1024
            throw(MException([mfilename ':in_aoi'],'\t"aoi(4)" (yrange) must be within 0<yrange<=1024.'));
        end
    else
        aoi = [0 0 1280 1024];
    end
    C.aoi = aoi;
%Assign exposure.
    if exist('exposure','var')
%         if exposure<C.exposurerange(1)
%             throw(MException([mfilename ':in_exposure'],['\t"exposure" must be greater than or equal to ' num2str(C.exposurerange(1)) '.']));
%         end
%         if exposure>C.exposurerange(3)
%             throw(MException([mfilename ':in_exposure'],['\t"exposure" must be less than or equal to ' num2str(C.exposurerange(3)) '.']));
%         end
        C.exposure = exposure;
    end
%Assign frames.
    if exist('frames','var')
        if ~isequal(round(frames),frames) || frames<1 || isinf(frames)
            throw(MException([mfilename ':in_frames'],'\t"frames" must be an integer within [1,inf).'));
        end
    else
        frames = 1;
    end
%---------------------------------------------------
%RUN FUNCTION
%---------------------------------------------------
varargout{1} = zeros([C.aoi(3:4) frames],'uint16');
for i = 1:frames %Capture multiple frames.
    varargout{1}(:,:,i) = C.capture();
end
if nargout>1 %Compute the mean of the frames.
    varargout{2} = mean(varargout{1},3);
end
if nargout>2 %Compute the variance of the frames.
    varargout{3} = var(double(varargout{1}),0,3);
end
if ~setC
    delete(C);
    clear C;
end