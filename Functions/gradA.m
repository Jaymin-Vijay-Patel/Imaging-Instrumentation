function Out = gradA( In, sizes )
%GRADA Summary of this function goes here
%   Detailed explanation goes here
% I = reshape(In,sizes);
% [Gx,Gy] = imgradientxy(I, 'CentralDifference');
% Out = [Gx(:); Gy(:)];
r = sizes(1);
c = sizes(2);
assert(r*c == numel(In));
Out = zeros(2*r*c, 1);
for i = 1:r
    Out(i) = In(i+r)-In(i);
end
for i = r+1:c*r-r
    Out(i) = In(i+r)-In(i-r);
end
for i = c*r-r+1:c*r
    Out(i) = In(i) - In(i-r);
end

for i = 1:c*r
    if mod(i-1, r) == 0
        Out(c*r+i) = In(i+1) - In(i);
    elseif mod(i,r) == 0
        Out(c*r+i) = In(i) - In(i-1);
    else
        Out(c*r+i) = In(i+1) - In(i-1);
    end
end

end

