function CNR = calculatecnr(image,Mask)
[Nx,Ny,numsteps,Nz] = size(image);
CNR = zeros(Nz,1);
tempimage = uint16(zeros(Nx,Ny,Nz));

b=(Mask==0);
num_noise=sum(b(:));
num_power = Nx*Ny-num_noise;

for jstep = 1:numsteps
    tempimage = tempimage + squeeze(image(:,:,jstep,:))/numsteps;
end

for jNz = 1:Nz
    noise = sum(sum(sum((1-Mask).*squeeze(tempimage(:,:,jNz)))))/num_noise;
    power = sum(sum(sum(Mask.*squeeze(tempimage(:,:,jNz)))))/num_power;
    CNR(jNz,1) = (power-noise)/(noise);
end
    
end

