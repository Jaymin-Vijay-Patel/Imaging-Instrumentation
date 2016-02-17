function loop_camera(varargin)
%LOOP_CAMERA Capture and display images in a loop from a DCC3240M camera.
%
%Syntax:    LOOP_CAMERA()
%           LOOP_CAMERA(...,C)
%           LOOP_CAMERA(...,parameter)
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
%See also:
%Required   CAMERA.
%
%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  02/10/16
%---------------------------------------------------

%RUN FUNCTION
%---------------------------------------------------
button = 'No';
while strcmp(button,'No')
    [~,meanA] = capture_frames(varargin{:});
    disp_image(meanA);
    %button = questdlg('Stop?','','Yes','No','No');
    %if strcmp(button,'No')
%         clf();
   %end
end
end