function animate_matrix( imgs )
%ANIMATE_MATRIX Summary of this function goes here
%   Detailed explanation goes here
figure;
colormap gray;
for i=1:size(imgs,3)
    imagesc(imgs(:,:,i))
    colorbar;
    drawnow;
end

end

