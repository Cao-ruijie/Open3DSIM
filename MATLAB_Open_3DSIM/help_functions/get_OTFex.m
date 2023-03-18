function OTFinc_model = get_OTFex(dataparams)
% 假设每个时间jframe的OTF都相同

%% OTF参数的设置
OTFparams.numchannels = dataparams.numchannels;
OTFparams.refmed = dataparams.refmed;    % refractive index medium/specimen
OTFparams.refcov = dataparams.refcov;    % 载玻片折射率
OTFparams.refimm = dataparams.refimm;    % refractive index immersion medium
OTFparams.refimmnom = dataparams.refcov; % nominal value of refractive indexe immersion medium, for which the objective lens is designed
OTFparams.NA = dataparams.NA;

OTFparams.xemit = dataparams.xemit;  % x-position focal point
OTFparams.yemit = dataparams.yemit;  % y-position focal point 
OTFparams.zemit = dataparams.zemit;  % z-position focal point 
OTFparams.Mx = dataparams.numpixelsx; % #sampling points in image space in x
OTFparams.My = dataparams.numpixelsy; % #sampling points in image space in y
OTFparams.Mz = dataparams.numfocus;   % #sampling points in image space in z
OTFparams.Npupil = round(sqrt(OTFparams.Mx*OTFparams.My));   % 采样数量
OTFparams.xrange = OTFparams.Mx*dataparams.rawpixelsize(1)/2;        % 1/2-size of image space in x
OTFparams.yrange = OTFparams.My*dataparams.rawpixelsize(2)/2;        % 1/2-size of image space in y
OTFparams.zrange = [-1,1]*OTFparams.Mz*dataparams.rawpixelsize(3)/2; %[zmin,zmax] defines image space in z 
OTFparams.pixelsize = dataparams.rawpixelsize(1);        % pixel size in image space
OTFparams.samplingdistance = dataparams.rawpixelsize(1); % pixel size in image space
OTFparams.fwd = dataparams.fwd;  % free working distance from objective to cover slip
OTFparams.depth = dataparams.depth;    % depth of imaged slice from the cover slip 
OTFparams.supportsizex = 1/2/dataparams.rawpixelsize(1);
OTFparams.supportsizey = 1/2/dataparams.rawpixelsize(2);
OTFparams.supportsizez = 1/2/dataparams.rawpixelsize(3);
OTFparams.Nsupportx = dataparams.numpixelsx;
OTFparams.Nsupporty = dataparams.numpixelsy;
OTFparams.Nsupportz = dataparams.numfocus;
Nx = OTFparams.Nsupportx;
Ny = OTFparams.Nsupporty;
Nz = OTFparams.Nsupportz;
OTFparams.shiftsupport = [floor(Nx/2)+1-(Nx+1)/2,floor(Ny/2)+1-(Ny+1)/2,floor(Nz/2)+1-(Nz+1)/2]; 
%% 对每一个颜色获取OTF
OTFinc_model = zeros(OTFparams.Mx,OTFparams.My,OTFparams.Mz,OTFparams.numchannels);
for jchannel = 1:OTFparams.numchannels
  OTFparams.lambda = dataparams.emwavelength(jchannel); % emission wavelength
  OTFparams.lambdaex = dataparams.exwavelength(jchannel); % excitation wavelength  
  OTFinc_model(:,:,:,jchannel) = get_vectormodelOTF(OTFparams);% compute vector model based OTF, original acquisition sampling  
end

end