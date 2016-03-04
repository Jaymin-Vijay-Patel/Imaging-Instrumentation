function Atx = calcgradt(x,sizes)
%CALCGRADT Calculates the gradient transpose of a column vector x whose 
% matrix size is [sizes(1) sizes(2)].

r = sizes(1);
c = sizes(2);
assert(2*r*c == numel(x));
Atx = zeros(r*c,1);
for i = 1:r
    Atx(i) = -x(i) - x(i+r);
end
for i = r+1:r*c-r
    Atx(i) = x(i-r) - x(i+r);
end
for i = r*c-r+1:r*c
    Atx(i) = x(i-r) + x(i);
end
for i = 1:c*r
    if mod(i-1,r)==0
        Atx(i) = Atx(i) - x(r*c+i+1) - x(r*c+i);
    elseif mod(i,r)==0
        Atx(i) = Atx(i) + x(r*c+i) + x(r*c+i-1);
    else
        Atx(i) = Atx(i) - x(r*c+i+1) + x(r*c+i-1);
    end
end
end
