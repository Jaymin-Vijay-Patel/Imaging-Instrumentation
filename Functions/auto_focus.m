function [focus,position,A_power] = auto_focus(varargin)
%AUTO_FOCUS Automatically focus a DCC3240M camera.
%   
%
%Syntax:    AUTO_FOCUS()
%           AUTO_FOCUS(...,C)
%           AUTO_FOCUS(...,S)
%           AUTO_FOCUS(...,mode)
%           AUTO_FOCUS(...,parameter)
%
%Input:     C         - Camera object.
%           S         - Stage object.
%           mode      - {'once'}
%                        'dynamic'
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
%                       steps       [1,inf) integers {10}                      Number of steps prior to fitting a Gaussian.
%
%Output:    A
%
%See also:
%Required   CAMERA, CAPTURE_FRAMES.
%
%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  02/17/16
%---------------------------------------------------

%SET INPUTS
%---------------------------------------------------
%Check the number of inputs.
    narginchk(0,9);
%Assign varargin.
    setC = false;
    for n = 1:nargin
        if isa(varargin{n},'Camera')
            C = varargin{n};
            setC = true;
        elseif isa(varargin{n},'APT.LinearStage')
            S = varargin{n};
            setS = true;
        elseif ischar(varargin{n})
            mode = varargin{n};
        elseif iscell(varargin{n})
            if numel(varargin{n})==2 && ischar(varargin{n}{1}) && any(strcmp(varargin{n}{1},{'pixelclock','aoi','exposure','frames','steps'})) && isnumeric(varargin{n}{2})
                if strcmp(varargin{n}{1},'pixelclock')
                    pixelclock = varargin{n}{2};
                elseif strcmp(varargin{n}{1},'aoi')
                    aoi = varargin{n}{2};
                elseif strcmp(varargin{n}{1},'exposure')
                    exposure = varargin{n}{2};
                elseif strcmp(varargin{n}{1},'frames')
                    frames = varargin{n}{2};
                elseif strcmp(varargin{n}{1},'steps')
                    steps = varargin{n}{2};
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
%Assign S.
    if ~exist('S','var')
        S = APT.getstage('linear');
    end
    S.velocity = 40;
%Assign mode.
    if ~exist('mode','var')
        mode = 'once';
    end
%Assign pixelclock.
    if exist('pixelclock','var')
        if ~isequal(round(pixelclock),pixelclock) || pixelclock<1 || isinf(pixelclock)
            throw(MException([mfilename ':in_pixelclock'],'\t"pixelclock" must be an integer within [1,inf).'));
        end
    else
        if ~setC
            pixelclock = 7;
        end
    end
    C.pixelclock = pixelclock;
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
        if exposure<C.exposurerange(2)
            throw(MException([mfilename ':in_exposure'],['\t"exposure" must be greater than ' num2str(C.exposurerange(2)) '.']));
        end
        if exposure>C.exposurerange(3)
            throw(MException([mfilename ':in_exposure'],['\t"exposure" must be less than ' num2str(C.exposurerange(3)) '.']));
        end
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
%Assign steps.
    if exist('steps','var')
        if ~isequal(round(steps),steps) || steps<1 || isinf(steps)
            throw(MException([mfilename ':in_steps'],'\t"steps" must be an integer within [1,inf).'));
        end
    else
        steps = 10;
    end
%---------------------------------------------------
%RUN FUNCTION
%---------------------------------------------------
position = linspace(0,100,steps);
position = position(:);
A_power = zeros(numel(position),1); %Power spectrum of the log of the Fourier transform of the image.
for i = 1:numel(position)
    S.move_abs(position(i));
    A = capture_frames(C,{'frames',frames});
    A_fft = fftshift(fft2(A));
    A_power(i) = sum(abs(A_fft(:)));
end
if strcmp(mode,'dynamic')
    figure;
end
while ~exist('focus','var') || (abs(position(end-1)-position(end))>0.1 || strcmp(mode,'dynamic'))
    curve = fit(position,A_power,'gauss1'); %Fit a Gaussian based on the points obtained.
    focus = curve.b1;
    try
        S.move_abs(focus); %Move the camera to the maximum of the Gaussian.
    catch err %#ok<NASGU>
    end
    position(end+1) = focus;
    A = capture_frames(C,{'frames',frames});
    A_fft = fftshift(fft2(A));
    A_power(end+1) = sum(abs(A_fft(:)));
    if strcmp(mode,'dynamic')
        position = position(2:end);
        A_power = A_power(2:end);
        disp_image(A);
    end
end
if ~setC
    delete(C);
    clear C;
end
if ~setS
    delete(S);
end
end