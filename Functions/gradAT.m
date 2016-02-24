function Out = gradAT( In )
%GRADAT Summary of this function goes here
%   Detailed explanation goes here

Out = zeros(numel(In)/2,1);
for i = 1:numel(Out)/2
    Out(i) = -In(i);
    Out(i+1280*1024/2) = In(i); 
end
for i = 1:numel(Out)/2
    if i==1
        Out(i) = -In(i+1280*1024);
    elseif i>1 && i<1280*1024
        Out(i) = In(i+1280*1024-1)-In(i+1280*1024);
    else
        Out(i) = In(i+1280*1024);
    end
end
end