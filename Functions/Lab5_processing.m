% Processing for Refelctive data
load transfer_functions.mat
load Lab5_Reflective.mat
load Lab5_Transmissive.mat
load D  % Dark current data. Dref (when exp = 100ms) came from D(:,:,57) of Lab4_D. Dtrans (exp =25ms) from D(:,:,89).

% Reflective
R3d = cat(3,R{:})-repmat(Dref,1,1,6);  %Subtract Dark Current

ep = 0.0001;
Dinv = pinv(diag(db1+ep))*pinv(diag(dl+ep))*pinv(diag(ds+ep));
L_diag = pinv(L'*L)*L';
F_diag = F(1:5,:)'*pinv(F(1:5,:)*F(1:5,:)');

R3dd = R3d(:,:,1:5);
rgb = zeros(1280,1024,3);
A = L_diag*Dinv*F_diag;

for row = 1:1280
    for col = 1:1024
        rgb(row,col,:) = A*squeeze(R3d(row,col,1:5)); %Inefficient. Takes longer time
    end
end

rgbp = rgb/max(max(max(rgb)));
for i =1:3
    rgb_ref(:,:,i) = rgbp(:,:,i)';
end

figure; imagesc(rgb_ref);

% Transmissive

R3d = cat(3,T{:})-repmat(Dtrans,1,1,7);  % Subtract Dark current

ep = 0.0001;
Dinv = pinv(diag(db1+ep))*pinv(diag(dl+ep))*pinv(diag(ds+ep));
L_diag = pinv(L'*L)*L';
F_diag2 = F(1:5,:)'*pinv(F(1:5,:)*F(1:5,:)');

R3dd2 = R3d(:,:,1:5);
rgb2 = zeros(1280,1024,3);
A2 = L_diag*Dinv*F_diag2;

for row = 1:1280
    for col = 1:1024
        rgb2(row,col,:) = A2*squeeze(R3d(row,col,1:5));
    end
end

rgbp2 = rgb2/max(max(max(rgb2)));
for i =1:3
    rgb_trans(:,:,i) = rgbp2(:,:,i)';
end

figure; imagesc(rgb_trans);
