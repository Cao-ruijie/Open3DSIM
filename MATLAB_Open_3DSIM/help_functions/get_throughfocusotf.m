function [XSupport,YSupport,OTF] = get_throughfocusotf(PSF,XImage,YImage,OTFparams)

ImageSizex = OTFparams.xrange;
ImageSizey = OTFparams.yrange;
SupportSizex = OTFparams.supportsizex;
SupportSizey = OTFparams.supportsizey;
Nsupportx = OTFparams.Nsupportx;
Nsupporty = OTFparams.Nsupporty;
Mx = size(PSF,1);
My = size(PSF,2);
Mz = size(PSF,3);

%% OTF support and sampling (in physical units)
DxSupport = 2*SupportSizex/Nsupportx;
DySupport = 2*SupportSizey/Nsupporty;
delqx = OTFparams.shiftsupport(1)*DxSupport;
delqy = OTFparams.shiftsupport(2)*DySupport;
xsupportlin = -SupportSizex+DxSupport/2:DxSupport:SupportSizex;
ysupportlin = -SupportSizey+DySupport/2:DySupport:SupportSizey;
[XSupport,YSupport] = meshgrid(xsupportlin-delqx,ysupportlin-delqy);

%% calculate auxiliary vectors for chirpz
[Ax,Bx,Dx] = prechirpz(ImageSizex,SupportSizex,Mx,Nsupportx);
[Ay,By,Dy] = prechirpz(ImageSizey,SupportSizex,My,Nsupporty);

%% calculation of through-focus OTF, and for each focus level the OTF peak is normalized to one
OTF = zeros(Nsupportx,Nsupporty,Mz);
for jz = 1:Mz
    PSFslice = squeeze(PSF(:,:,jz));
    PSFslice = exp(-2*pi*1i*(delqx*XImage+delqy*YImage)).*PSFslice;
    IntermediateImage = transpose(cztfunc(PSFslice,Ay,By,Dy));
    tempim = transpose(cztfunc(IntermediateImage,Ax,Bx,Dx));
    OTF(:,:,jz) = tempim/max(max(abs(tempim)));
end

end