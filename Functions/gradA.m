function Out = gradA( In )
%GRADA Summary of this function goes here
%   Detailed explanation goes here
Out = zeros(2*numel(In),1);
for i = 1:numel(In)-1280
    Out(i) = In(i+1280)-In(i);
end
for i = 1:numel(In)
    if mod(i,1024)~=0
        Out(i+numel(In)) = In(i+1)-In(i);
    end
end
end

