function Ax = calcgrad(x,sizes)
%CALCGRAD Calculates the gradient of a column vector x whose matrix size 
% is [sizes(1) sizes(2)].

r = sizes(1);
c = sizes(2);
assert(r*c == numel(x));
Ax = zeros(2*r*c,1);
for i = 1:r
    Ax(i) = x(i+r) - x(i);
end
for i = r+1:c*r-r
    Ax(i) = x(i+r) - x(i-r);
end
for i = c*r-r+1:c*r
    Ax(i) = x(i) - x(i-r);
end
for i = 1:c*r
    if mod(i-1,r) == 0
        Ax(c*r+i) = x(i+1) - x(i);
    elseif mod(i,r) == 0
        Ax(c*r+i) = x(i) - x(i-1);
    else
        Ax(c*r+i) = x(i+1) - x(i-1);
    end
end
end