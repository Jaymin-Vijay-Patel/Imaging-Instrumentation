% Processing for Refelctive data
% load transfer_functions.mat
% load Lab5_Reflective.mat
% load Lab5_Transmissive.mat
% load D  % Dark current data. Dref (when exp = 100ms) came from D(:,:,57) of Lab4_D. Dtrans (exp =25ms) from D(:,:,89).

% Reflective
R3r = cat(3,R{:})-repmat(Dref,1,1,6);  %Subtract Dark Current

ep = 0.0001;
Dinv = pinv(diag(db1+ep))*pinv(diag(dl+ep))*pinv(diag(ds+ep));
L_diag = pinv(L'*L)*L';
F_diag = F(1:5,:)'*pinv(F(1:5,:)*F(1:5,:)');

R3dd = R3r(:,:,1:5);
rgb = zeros(1280,1024,3);
A = L_diag*Dinv*F_diag;

for row = 1:1280
    for col = 1:1024
        rgb(row,col,:) = A*squeeze(R3r(row,col,1:5)); %Inefficient. Takes longer time
    end
end

rgbp = rgb/max(max(max(rgb)));
for i =1:3
    rgb_ref(:,:,i) = rgbp(:,:,i)';
end

figure; imagesc(rgb_ref);

% Transmissive

R3t = cat(3,T{:})-repmat(Dref,1,1,7);  % Subtract Dark current

R3dd2 = R3t(:,:,1:5);
rgb2 = zeros(1280,1024,3);

for row = 1:1280
    for col = 1:1024
        rgb2(row,col,:) = A*squeeze(R3t(row,col,1:5));
    end
end

rgbp2 = rgb2/max(max(max(rgb2)));
for i =1:3
    rgb_trans(:,:,i) = rgbp2(:,:,i)';
end

figure; imagesc(rgb_trans);

%%
filter_colors = [131 0 181; 0 70 255; 0 255 146; 163 255 0; 255 190 0; 255 0 0];
filter_peaks = [400 450 500 550 600 650];

figure;
for i=1:6
    subplot(2,3,i); imagesc(R3r(:,:,i));
end
colormap gray;

figure;
for i=1:6
    subplot(2,3,i); imagesc(R3t(:,:,i));
end
colormap gray;

figure;
hold on;
for i=1:6
    plot(lambda, F(i,:), 'color', filter_colors(7-i,:)/255);
end
xlabel('Wavelength in nm');
ylabel('Relative transmittivity of each filter at all wavelengths');

to_proper_image = @(i) permute(i / max(i(:)), [2 1 3]);
naive_ref_rgb = to_proper_image(R3r(:,:,[2, 3, 5]));
figure;
image(naive_ref_rgb);

naive_trans_rgb = to_proper_image(R3t(:,:,[2, 3, 5]));
figure;
image(naive_trans_rgb);
