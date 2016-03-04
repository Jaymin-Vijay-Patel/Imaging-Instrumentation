function [LDR,HDR,E,A,Phi] = capture_hdr(varargin)
%CAPTURE_HDR Capture images to generate an HDR image with a DCC3240M camera.
%
%Syntax:    LDR = CAPTURE_HDR()
%           LDR = CAPTURE_HDR(...,C)
%           LDR = CAPTURE_HDR(...,parameter)
%           LDR = CAPTURE_HDR(...,A)
%           LDR = CAPTURE_HDR(...,mode)
%           [LDR,HDR] = CAPTURE_HDR(...)
%           [LDR,HDR,A] = CAPTURE_HDR(...)
%
%Input:     C         - Camera object.
%           parameter - A cell containing {name,value}.
%
%                       Name        Value                                       Description
%                       ----        -----                                       -----------
%                       pixelclock  [1,inf) integers {7}                        Speed of pixel readout.
%                       aoi         [0<=x<=1280-xrange; 0<=y<=1024-yrange;      Area of interest within images where x and y determine the top left corner.
%                                   0<xrange<=1280; 0<yrange<=1024]        
%                                   {[0 0 1280 1024]}
%                       exposure    [exposurerange(2),exposurerange(3)] doubles Exposure times in milliseconds.
%                       frames      [1,inf) integers {1}                        Number of frames.
%           A         - Images at each exposure.
%           beta      - Gradient magnification/attenuation factor.
%           mode      - Determines whether to only assign certain outputs. All outputs are assigned by default.
%                       'capture'   Only captures images at each exposure.
%                       'hdr'       Only returns the HDR image. 
%
%Output:    LDR - LDR image.
%           HDR - HDR image.
%           E   - Image with exposure chosen at each pixel.
%           A   - Images at each exposure.
%           Phi - Gradient attenuation factor.
%
%See also:
%Required   CAMERA, CAPTURE_FRAMES.
%
%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  03/03/16
%---------------------------------------------------

%SET INPUTS
%---------------------------------------------------
%Check the number of inputs.
    narginchk(0,5);
%Assign varargin.
    P = struct();
    setC = false;
    n = 1;
    while n<=numel(varargin)
        if isa(varargin{n},'Camera')
            C = varargin{n};
            setC = true;
            varargin(n) = [];
            n = n-1;
        elseif iscell(varargin{n})
            if numel(varargin{n})==2 && ischar(varargin{n}{1}) && any(strcmp(varargin{n}{1},{'pixelclock','aoi','exposure','frames'})) && isnumeric(varargin{n}{2})
                P.(varargin{n}{1}) = varargin{n}{2};
                varargin(n) = [];
                n = n-1;
            else
                throw(MException([mfilename ':in_varargin'],'\tUnrecognized cell input.'));
            end
        elseif isnumeric(varargin{n})
            if numel(varargin{n})>1
                A = varargin{n};
            elseif numel(varargin{n})==1
                beta = varargin{n};
            end
            varargin(n) = [];
            n = n-1;
        elseif ischar(varargin{n})
            if any(strcmp(varargin{n},{'','capture','hdr'}))
                mode = varargin{n};
            end
            varargin(n) = [];
            n = n-1;
        end
        n = n+1;
    end
existA = false;
if exist('A','var')
    %Check A.
        if ~isnumeric(A) || size(A,1)<2 || size(A,2)<2  || size(A,3)<2
            throw(MException([mfilename ':in_A'],'\t"A" must be a 3 dimensional numeric array.'));
        end
        existA = true;
else
    %Assign C.
        if ~exist('C','var')
            C = Camera(0);
        end
    %Assign pixelclock.
        if isfield(P,'pixelclock')
            if ~isequal(round(P.pixelclock),P.pixelclock) || P.pixelclock<1 || isinf(P.pixelclock)
                throw(MException([mfilename ':in_pixelclock'],'\t"pixelclock" must be an integer within [1,inf).'));
            end
            C.pixelclock = P.pixelclock;
        else
            if ~setC
                C.pixelclock = 7;
            end
        end
    %Assign aoi.
        if isfield(P,'aoi')
            if ~isequal(round(P.aoi),P.aoi)
                throw(MException([mfilename ':in_aoi'],'\t"aoi" must contain integers.'));
            end  
            if P.aoi(1)<0 || P.aoi(1)>1279
                throw(MException([mfilename ':in_aoi'],'\t"aoi(1)" (x) must be within 0<=x<=1280-xrange.'));
            end
            if P.aoi(2)<0 || P.aoi(2)>1023
                throw(MException([mfilename ':in_aoi'],'\t"aoi(2)" (y) must be within 0<=y<=1024-yrange.'));
            end
            if P.aoi(3)<1 || P.aoi(3)>1280
                throw(MException([mfilename ':in_aoi'],'\t"aoi(3)" (xrange) must be within 0<xrange<=1280.'));
            end
            if P.aoi(4)<1 || P.aoi(4)>1024
                throw(MException([mfilename ':in_aoi'],'\t"aoi(4)" (yrange) must be within 0<yrange<=1024.'));
            end
            aoi = P.aoi;
        else
            aoi = [0 0 1280 1024];
        end
        C.aoi = aoi;
    %Assign frames.
        if isfield(P,'frames')
            if ~isequal(round(P.frames),P.frames) || P.frames<1 || isinf(P.frames)
                throw(MException([mfilename ':in_frames'],'\t"frames" must be an integer within [1,inf).'));
            end
            frames = P.frames;
        else
            frames = 1;
        end
end
%Assign exposure.
    if isfield(P,'exposure')
        if ~exist('A','var')
            if any(P.exposure<C.exposurerange(1))
                throw(MException([mfilename ':in_exposure'],['\t"exposure" must be greater than ' num2str(C.exposurerange(1)) '.']));
            end
            if any(P.exposure>C.exposurerange(3))
                throw(MException([mfilename ':in_exposure'],['\t"exposure" must be less than ' num2str(C.exposurerange(3)) '.']));
            end
        end
        exposure = P.exposure;
        exposure = sort(exposure,'descend');
    elseif ~exist('exposure','var')
        if ~exist('C','var')
            C.exposurerange(1) = 0.009;
            C.exposurerange(3) = 227.806;
        end
        exposure = linspace(C.exposurerange(3),C.exposurerange(1),100);
    end
%Assign beta.
    if ~exist('beta','var')
        beta = 0.9;
    end
%Assign mode.
    if ~exist('mode','var')
        mode = '';
    end
%---------------------------------------------------
%RUN FUNCTION
%---------------------------------------------------
%Capture images at each exposure.
    if ~exist('A','var')
        A = zeros([C.aoi(3:4) numel(exposure)]);
        for i = 1:numel(exposure)
            [~,A(:,:,i)] = capture_frames(C,{'exposure',exposure(i)},{'frames',frames},varargin{:});
        end
    end
%Combine the image data into an HDR image.
    E = exposure(1)*ones(size(A,1),size(A,2)); %Exposure used for each pixel.
    HDR = zeros(size(A));
    if ~strcmp(mode,'capture')
        HDR = A(:,:,1);
        for i = 2:size(A,3)
            Ap = A(:,:,i-1); %Prior exposure.
            Ac = A(:,:,i); %Current exposure.
            E(Ap>1022) = exposure(i);
            HDR(Ap>1022) = Ac(Ap>1022)*exposure(1)/exposure(i);
        end
    end
%Compress the HDR data into an LDR image.
    LDR = zeros(size(A));
    if ~any(strcmp(mode,{'capture','hdr'}))
        H = log(HDR);
        [Hx,Hy] = imgradientxy(H,'CentralDifference');
        alpha = .1 * mean(abs([Hx(:); Hy(:)]));
        Phi = calcphi(H,alpha,beta,5);
        Gx = Hx.*Phi;
        Gy = Hy.*Phi;
        G = [Gx(:); Gy(:)];
        AtG = calcgradt(G,size(H));
        I = reshape(cgs(@(x)calcgradt(calcgrad(x,size(H)),size(H)),AtG,[],1000),size(H));
        LDR = exp(I);
    end
if ~setC && ~existA
    delete(C);
    clear C;
end
end