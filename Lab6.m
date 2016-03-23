img = zeros(size(y,1));

%assuming SAD, pixels size both in mm (or at least, same units).
uip = horzcat(pixelsize * ((1:size(y,1))' - (size(y,1)+1)/2), ...
              zeros(numel(uxip),1));
%The unrotaed focal point of the system
ufpt = [0 SAD];

a_deg = 10;
a = deg2rad(a_deg);

R = [cos(a) sin(a); -sin(a) cos(a)];
ip = uip * R;
fpt = ufpt * R;

%The centers of each pixel of img
[ppx, ppy] = meshgrid(uxip, uxip);
img_side = size(y,1) * pixelsize;

%For each point in ip, traverse the line from the front face of img to the
% back.

%There are a few different ways to do this.  One, we can traverse the line
% in small steps and increment the contribution to a particular pixel
% each time the step is within that pixel.
%Or, we can figure out the major axis of traversal, x or y, find the
% traversed distance between rows in that direction, and go row by row,
% adding the contribution to each pixel proportionally.