function OTFexp_orders = resample_calibrationOTF(ringOTForder,deltaq_exp,allsampling,SIMpixelsize)
% copyright Sjoerd Stallinga, TUD 2017-2020

% parameters and spatial frequency vectors of 3D-Fourier grid
Nx = allsampling(1);
Ny = allsampling(2);
Nz = allsampling(3);
Dqx = 1/Nx/SIMpixelsize(1);
Dqy = 1/Ny/SIMpixelsize(2);
Dqz = 1/Nz/SIMpixelsize(3);
qx = ((1:Nx)-floor(Nx/2)-1)*Dqx;
qy = ((1:Ny)-floor(Ny/2)-1)*Dqy;
qz = ((1:Nz)-floor(Nz/2)-1)*Dqz;
[Qxx,Qyy] = meshgrid(qx,qy);
Qrad = sqrt(Qxx.^2+Qyy.^2);

% spatial frequency vectors corresponding to ring averaged OTF
[Nxyexp,Nzexp] = size(ringOTForder);
qxyexp = (0:(Nxyexp-1))*deltaq_exp(1);
qzexp = ((1:Nzexp)-floor(Nzexp/2)-1)*deltaq_exp(3);

% extrapolate from ring to square matrix
OTFtemp = zeros(Nx,Ny,Nzexp);
for jz = 1:Nzexp
    ringvector = squeeze(ringOTForder(:,jz));
    ringmatrix = zeros(Nx,Ny);
    for jrad = 2:Nxyexp
        Qbin = (Qrad>=qxyexp(jrad-1))&(Qrad<qxyexp(jrad));
        ringmatrix(Qbin) = ringvector(jrad);
    end
    OTFtemp(:,:,jz) = ringmatrix;
    OTFtemp(floor(Nx/2)+1,floor(Ny/2)+1,jz) = ringvector(1); % extra measure to get right on-axis value
end

% resample in axial direction from Nzexp to Nz
if Nz==Nzexp
    temp_interpolate = OTFtemp; % do nothing just in case Nz=Nzexp
else
    % low pass filter if Nz<Nzexp
    if Nz<Nzexp
        OTFtemp = permute(OTFtemp,[3 1 2]); % permute to get z-dependence on 1st index
        ftOTFtemp = fftshift(fft(OTFtemp)); % take FT
        lowpassfilter = zeros(Nzexp,Nx,Ny);
        lowpassrange = (1:Nz)-floor(Nz/2)+floor(Nzexp/2);
        lowpassfilter(lowpassrange,:,:) = 1; % low pass filter
        ftOTFtemp = lowpassfilter.*ftOTFtemp;
        OTFtemp = ifft(ifftshift(ftOTFtemp)); % take inverse FT
        OTFtemp = permute(OTFtemp,[2 3 1]); % permute order indices back
    end
    % interpolate/resample using interp1
    OTFtemp = permute(OTFtemp,[3 1 2]);
    temp_interpolate = interp1(qzexp,OTFtemp,qz);
    % set values outside original qz-range equal to zero
    temp_interpolate(abs(qz)>max(qzexp),:,:) = 0;
    temp_interpolate = permute(temp_interpolate,[2 3 1]);
end

% proper normalization of OTF
normfac = max(abs(squeeze(temp_interpolate(floor(Nx/2)+1,floor(Ny/2)+1,:))));
OTFexp_orders = temp_interpolate/normfac;

end

