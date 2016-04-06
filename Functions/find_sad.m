function center = find_sad( lnear, rnear, lfar, rfar, side )
%FIND_SAD Summary of this function goes here
%   Detailed explanation goes here
rho = abs(rfar - lfar) / abs(rnear - lnear)
center = side * rho / (1 - rho) + side / 2

end

