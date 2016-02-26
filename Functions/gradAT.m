function Out = gradAT( In, sizes )
%GRADA Summary of this function goes here
%   Detailed explanation goes here

r = sizes(1);
c = sizes(2);
assert(2*r*c == numel(In));
Out = zeros(r*c,1);
for i=1:r
    Out(i) = -In(i) - In(i+r);
end
for i=r+1:r*c-r
    Out(i) = In(i-r) - In(i+r);
end
for i=r*c-r+1:r*c
    Out(i) = In(i-r) + In(i);
end

for i = 1:c*r
    if mod(i-1, r) == 0
        Out(i) = Out(i) - In(r*c+i+1) - In(r*c+i);
    elseif mod(i,r) == 0
        Out(i) = Out(i) + In(r*c+i) + In(r*c+i-1);
    else
        Out(i) = Out(i) - In(r*c+i+1) + In(r*c+i-1);
    end
end

end
