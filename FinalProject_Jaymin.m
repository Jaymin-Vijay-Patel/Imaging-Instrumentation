%---------------------------------------------------
%Author:    Nathan Crookston, Seung Wook Lee, Jaymin Patel
%           Department of Biomedical Engineering
%           Johns Hopkins University, Baltimore, MD.
%E-mail:    nathan.crookston@gmail.com, slee333@jhu.edu, jpatel18@jhmi.edu
%Revision:  04/01/16
%---------------------------------------------------
%Final Project. Jaymin's Processing.

positions = 21-3*0.01:0.005:21+3*0.01;
position_center = 21;
x1 = 325;
x2 = 655;
d = 10;
pixel_size = d/(x2-x1);
shift = 0.005;
star_low_005_13x13_motion = motion_operator_2d(star_low_005_13x13,pixel_size,-shift);



