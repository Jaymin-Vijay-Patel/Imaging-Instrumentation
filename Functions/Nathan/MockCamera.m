classdef MockCamera < handle
%MOCKCAMERA Defines a mock camera object.
%---------------------------------------------------
%Author:    Nathan Crookston
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com
%Revision:  02/10/16
%---------------------------------------------------
    properties (Access = private)
        I
    end
    properties(Dependent = true)
        capture
    end
    properties
        pixelclock = 24
        framerate = 8.0196
        exposure = 7
        aoi = [0 0 1280 1024]
        pausetime = 0
    end
    properties(Constant)
        allowedpixelclock = uint32(7:68)'
        exposurerange = [.009 .0549 66.6209]
        frameraterange = [.5 17.2889]
    end
    methods (Access = private)
        function img = subimage(obj, I)
            a = obj.aoi;
            img = I(a(1)+1:a(1)+a(3),a(2)+1:a(2)+a(4));
%            img = reshape(img,1,size(img,1), size(img,2));
        end
    end
    methods
        function obj = MockCamera(~,~)
            if nargin <= 1
                obj.I = rgb2gray(imread('saturn.png'));
            else
                obj.I = zeros(obj.aoi(3), obj.aoi(4));
            end
        end
        function img = get.capture(obj)
            img = imnoise(obj.subimage(obj.I), 'poisson');
        end
        
        function delete(~)
            %Do nothing for the mock.
        end
    end

end

