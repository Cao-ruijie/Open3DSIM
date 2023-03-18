function [ZSupport,OTF3D] = get_otf3d(OTFstack,ZImage,parameters)
% This function computes the 3D-OTF from a through-focus stack of the
% 2D-OTF by making an FT along the axial direction by applying a 1D-CZT
% along that direction.

%% Basic parameter
SupportSizez = parameters.supportsizez;
Nsupportz = parameters.Nsupportz;
zmin = parameters.zrange(1);
zmax = parameters.zrange(2);
ImageSizez = (zmax-zmin)/2;
[Nx,Ny,Mz] = size(OTFstack);

%% OTF support and sampling (in physical units)
DzSupport = 2*SupportSizez/Nsupportz;
delqz = parameters.shiftsupport(3)*DzSupport;
ZSupport = -SupportSizez+DzSupport/2:DzSupport:SupportSizez;
ZSupport = ZSupport-delqz;

%% calculate auxiliary vectors for chirpz
[A,B,D] = prechirpz(ImageSizez,SupportSizez,Mz,Nsupportz);

%% 1-D CZT 
OTF3D = zeros(Nx,Ny,Nsupportz);
for ii = 1:Nx
  for jj = 1:Ny
    axialcut = squeeze(OTFstack(ii,jj,:))';
    axialcut = exp(-2*pi*1i*delqz*ZImage).*axialcut;
    OTF3D(ii,jj,:) = cztfunc(axialcut,A,B,D);
  end
end
OTF3D(:,:,Nsupportz) = OTF3D(:,:,1);

%% Normalize
norm = max(abs(OTF3D(:)));
OTF3D = OTF3D/norm;

end

