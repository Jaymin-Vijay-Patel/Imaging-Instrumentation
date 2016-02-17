function exposure = auto_exposure(varargin)
%AUTO_EXPOSURE Determine the optimal exposure time for a DCC3240M camera.
%   Calculates the slope of the SNR across different exposure times. The 
%   first point at which the slope is negative is considered the optimal 
%   exposure time.
%
%Syntax:    exposure = AUTO_EXPOSURE()
%           exposure = AUTO_EXPOSURE(...,C)
%           exposure = AUTO_EXPOSURE(...,exposures)
%           exposure = AUTO_EXPOSURE(...,parameter)
%
%Input:     C         - Camera object.
%           exposures - Exposure times in milliseconds.
%           parameter - A cell containing {name,value}.
%
%                       Name        Value                                Description
%                       ----        -----                                -----------
%                       pixelclock  [1,inf) integers {7}                 Speed of pixel readout.
%                       aoi         [0<x<1280-xrange; 0<y<1024-yrange;   Area of interest within images where x and y determine the top left corner.
%                                       0<xrange<1280; 0<yrange<1024]    
%                                       {[590 462 100 100]}
%                       frames      [1,inf) integers {100}               Number of frames.
%
%Output:    exposure - Exposure time.
%
%See also:
%Required   CAMERA, CAPTURE_FRAMES.
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
    n = 1;
    setC = false;
    while n<=numel(varargin)
        if isa(varargin{n},'Camera')
            C = varargin{n};
            setC = true;
            varargin(n) = [];
            n = n-1;
        elseif isnumeric(varargin{n})
            exposures = varargin{n};
            varargin(n) = [];
            n = n-1;
        elseif iscell(varargin{n})
            if numel(varargin{n})==2 && ischar(varargin{n}{1}) && any(strcmp(varargin{n}{1},{'pixelclock','aoi','frames'})) && isnumeric(varargin{n}{2})
                if strcmp(varargin{n}{1},'aoi')
                    aoi = varargin{n}{2};
                    varargin(n) = [];
                    n = n-1;
                elseif strcmp(varargin{n}{1},'frames')
                    frames = varargin{n}{2};
                    varargin(n) = [];
                    n = n-1;
                end
            else
                throw(MException([mfilename ':in_varargin'],'\tUnrecognized cell input.'));
            end
        end
        n = n+1;
    end
%Assign C.
    if ~exist('C','var')
        C = Camera(0);
    end
    if ~setC
        C.pixelclock = 7;
    end
%Assign aoi.
    if exist('aoi','var')
        if ~isequal(round(aoi),aoi)
            throw(MException([mfilename ':in_aoi'],'\t"aoi" must contain integers.'));
        end  
        if aoi(1)<1 || aoi(1)>1279
            throw(MException([mfilename ':in_aoi'],'\t"aoi(1)" (x) must be within 0<x<1280-xrange.'));
        end
        if aoi(2)<1 || aoi(2)>1023
            throw(MException([mfilename ':in_aoi'],'\t"aoi(2)" (y) must be within 0<y<1024-yrange.'));
        end
        if aoi(3)<1 || aoi(3)>1280
            throw(MException([mfilename ':in_aoi'],'\t"aoi(3)" (xrange) must be within 0<xrange<1280.'));
        end
        if aoi(4)<1 || aoi(4)>1024
            throw(MException([mfilename ':in_aoi'],'\t"aoi(4)" (yrange) must be within 0<yrange<1024.'));
        end
    else
        aoi = [1280/2-50 1024/2-50 100 100];
    end
    C.aoi = aoi;
%Assign exposurerange.
    if ~exist('exposures','var')
        exposures = linspace(C.exposurerange(2),C.exposurerange(3),30);
    else
        if any(exposures<C.exposurerange(2))
            throw(MException([mfilename ':in_exposures'],['\t"exposures" must be greater than ' num2str(C.exposurerange(2)) '.']));
        end
        if any(exposures>C.exposurerange(3))
            throw(MException([mfilename ':in_exposure'],['\t"exposures" must be less than ' num2str(C.exposurerange(3)) '.']));
        end
    end
%Assign frames.
    if ~exist('frames','var')
        frames = 100;
    end
%---------------------------------------------------
%RUN FUNCTION
%---------------------------------------------------
    A = zeros([C.aoi(3:4) numel(exposures)]);
    meanA = zeros(numel(exposures),1); %Mean pixel value for each exposure time.
    varA = zeros(numel(exposures),1); %Variance of pixels for each exposure time.
    for i = 1:numel(exposures)
        [~,A(:,:,i)] = capture_frames(C,{'pixelclock',7},{'aoi',aoi},{'exposure',exposures(i)},{'frames',frames},varargin{:});
        meanA(i) = mean2(A(:,:,i));
        varA(i) = var(reshape(A(:,:,i),C.aoi(3)*C.aoi(4),1));
    end
    SNR = meanA./sqrt(varA);
    dSNR = diff(SNR);
    exposure = exposures(find(dSNR<=0,1,'first')); %Look for the first exposure at which the slope is negative.
    delete(C);
    clear C;
end