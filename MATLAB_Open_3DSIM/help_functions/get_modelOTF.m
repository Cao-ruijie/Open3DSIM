function [OTF_orders,OTF_every_slide] = get_modelOTF(dataparams,SIMparams)
%% Basic parameters
Nx = SIMparams.numSIMpixelsx;
Ny = SIMparams.numSIMpixelsy;
Nz = SIMparams.numSIMpixelsz;

%% support size and sampling for OTF in frequency domain,
OTFparams.supportsizex = 1/2/SIMparams.SIMpixelsize(1);
OTFparams.supportsizey = 1/2/SIMparams.SIMpixelsize(2);
OTFparams.supportsizez = 1/2/SIMparams.SIMpixelsize(3);
OTFparams.Nsupportx = Nx;
OTFparams.Nsupporty = Ny;
OTFparams.Nsupportz = Nz;
OTFparams.shiftsupport = [floor(Nx/2)+1-(Nx+1)/2,floor(Ny/2)+1-(Ny+1)/2,floor(Nz/2)+1-(Nz+1)/2];

%% define struct OTFparams needed for the vectorial PSF model functions
OTFparams.refmed = dataparams.refmed;    % refractive index medium/specimen
OTFparams.refcov = dataparams.refcov;    % refractive index conver slip
OTFparams.refimm = dataparams.refimm;    % refractive index immersion medium
OTFparams.refimmnom = dataparams.refcov; % nominal value of refractive indexe immersion medium, for which the objective lens is designed
OTFparams.fwd = dataparams.fwd;          % free working distance from objective to cover slip
OTFparams.depth = dataparams.depth;      % depth of imaged slice from the cover slip
OTFparams.NA = dataparams.NA;            % NA of the objective lens
OTFparams.xemit = 0.0;                   % x-position focal point
OTFparams.yemit = 0.0;                   % y-position focal point
OTFparams.zemit = 0.0;                   % z-position focal point
OTFparams.ztype = 'medium';              % z-distances measured inside the medium

%% sampling real and spatial frequency space
SIMparams.rawpixelsize = dataparams.rawpixelsize;
OTFparams.Npupil = round(sqrt(SIMparams.numSIMpixelsx*SIMparams.numSIMpixelsy)); % sampling points in pupil plane
OTFparams.Mx = Nx;       % sampling points in image space in x
OTFparams.My = Ny;       % sampling points in image space in y
OTFparams.Mz = Nz;       % sampling points in image space in z (must be 1 for 2D)
OTFparams.xrange = Nx*SIMparams.rawpixelsize(1)/2/SIMparams.upsampling(1);           % 1/2-size of image space in x
OTFparams.yrange = Ny*SIMparams.rawpixelsize(2)/2/SIMparams.upsampling(1);           % 1/2-size of image space in x
OTFparams.zrange = [-Nz*SIMparams.rawpixelsize(3)/2,Nz*SIMparams.rawpixelsize(3)/2]; % [zmin,zmax] defines image space in z
OTFparams.pixelsize = SIMparams.SIMpixelsize(1);        % pixel size in image space
OTFparams.samplingdistance = SIMparams.SIMpixelsize(1); % sampling distance in image space
OTFparams.aberrations = [1,1,0.0; 1,-1,-0.0; 2,0,-0.0; 4,0,0.0; 2,-2,0.0; 2,2,0.0; 4,-2,0.0];
OTFparams.dipoletype = 'free'; % averaging over dipole orientations

%% loop over color channels
OTFparams.lambdaex = dataparams.exwavelength;                    % excitation wavelength
OTFparams.lambda = dataparams.emwavelength;                      % emmission wavelength
OTFparams.aberrations(:,3) =  OTFparams.aberrations(:,3)*OTFparams.lambda; % change to length units
[OTF_orders,OTF_every_slide] = get_vectormodelOTF(OTFparams);              % compute vector model based OTF, SIM image sampling


end