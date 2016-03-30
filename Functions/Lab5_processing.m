% Processing for Refelctive data
% load transfer_functions.mat
% load Lab5_Reflective.mat
% load Lab5_Transmissive.mat
% load D  % Dark current data. Dref (when exp = 100ms) came from D(:,:,57) of Lab4_D. Dtrans (exp =25ms) from D(:,:,89).

% Reflective
R3d = cat(3,R{:})-repmat(Dall,1,1,6);  %Subtract Dark Current

ep = 0.0001;
Dinv = pinv(diag(db1+ep))*pinv(diag(dl+ep))*pinv(diag(ds+ep));
L_diag = pinv(L'*L)*L';
F_diag = F(1:5,:)'*pinv(F(1:5,:)*F(1:5,:)');

rgb = zeros(1280,1024,3);
A = L_diag*Dinv*F_diag;
rgb = repmat(reshape(A,1,1,3,5), 1280, 1024) * reshape(R3d(:,:,1:5), 1280,1024,5,1);

rgb_ref = permute(rgb/max(rgb(:)), [2 1 3]);
figure; imagesc(rgb_ref);

% Transmissive

R3d = cat(3,T{:})-repmat(Dall,1,1,7);  % Subtract Dark current

ep = 0.0001;
Dinv = pinv(diag(db1+ep))*pinv(diag(dl+ep))*pinv(diag(ds+ep));
L_diag = pinv(L'*L)*L';
F_diag2 = F(1:5,:)'*pinv(F(1:5,:)*F(1:5,:)');

rgb2 = zeros(1280,1024,3);
A2 = L_diag*Dinv*F_diag2;

for row = 1:1280
    for col = 1:1024
        rgb2(row,col,:) = A2*squeeze(R3d(row,col,1:5));
    end
end


rgb_trans = permute(rgb2/max(rgb2(:)), [2 1 3]);
figure; imagesc(rgb_trans);
%%
color_energy = 1 ./ sum(L,1);
%color_energy = 1 ./ max(L,[],1);
%color_energy = [1 1 1];
bd_ref = cat(3, R{[2,4,5]}) .* repmat(reshape(color_energy,1,1,3), 1280, 1024);%size(R(2),2), size(R(2),1));

figure; imagesc(permute(bd_ref/max(bd_ref(:)), [2 1 3]));
