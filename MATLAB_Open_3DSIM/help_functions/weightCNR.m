function tempimageout1 = weightCNR(tempimage,CNR)
%% basic parameter
[Nx,Ny,numstep,Nz] = size(tempimage);
tempimageout1 = zeros(Nx,Ny,numstep);
CNR = CNR./sum(CNR);
%% calculate every slice
for jz = 1:Nz
    tempimageout1 = tempimageout1 + squeeze(CNR(jz)*tempimage(:,:,:,jz));
end
end