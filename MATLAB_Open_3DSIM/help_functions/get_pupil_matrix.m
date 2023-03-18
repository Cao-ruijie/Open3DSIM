function [XPupil,YPupil,wavevector,wavevectorzmed,Waberration,PupilMatrix] = get_pupil_matrix(OTFparams)

%% Basic parameter
NA = OTFparams.NA;
refmed = OTFparams.refmed;
refcov = OTFparams.refcov;
refimm = OTFparams.refimm;
refimmnom = OTFparams.refimmnom;
lambda = OTFparams.lambda;
Npupil = OTFparams.Npupil;

%% Feniel parameter
PupilSize = 1.0;
DxyPupil = 2*PupilSize/Npupil;
XYPupil = -PupilSize+DxyPupil/2:DxyPupil:PupilSize;
[YPupil,XPupil] = meshgrid(XYPupil,XYPupil);
CosThetaMed = 1.0*sqrt(1-(XPupil.^2+YPupil.^2)*NA^2/refmed^2);
CosThetaCov = 1.0*sqrt(1-(XPupil.^2+YPupil.^2)*NA^2/refcov^2);
CosThetaImm = 1.0*sqrt(1-(XPupil.^2+YPupil.^2)*NA^2/refimm^2);
CosThetaImmnom = 1.0*sqrt(1-(XPupil.^2+YPupil.^2)*NA^2/refimmnom^2);
FresnelPmedcov = 2.0./(refmed*CosThetaCov+refcov*CosThetaMed);
FresnelSmedcov = 2.0./(refmed*CosThetaMed+refcov*CosThetaCov);
FresnelPcovimm = 2.0*refcov*CosThetaCov./(refcov*CosThetaImm+refimm*CosThetaCov);
FresnelScovimm = 2.0*refcov*CosThetaCov./(refcov*CosThetaCov+refimm*CosThetaImm);
FresnelP =  1.0*FresnelPmedcov.*FresnelPcovimm;
FresnelS =  1.0*FresnelSmedcov.*FresnelScovimm;

%% Entrance pupil function of plane
Phi = atan2(YPupil,XPupil);
CosPhi = cos(Phi);
SinPhi = sin(Phi);
CosTheta = 1.0*sqrt(1-(XPupil.^2+YPupil.^2)*NA^2/refmed^2);
SinTheta = 1.0*sqrt(1-CosTheta.^2);
pvec{1} = 1.0*FresnelP.*CosTheta.*CosPhi;
pvec{2} = 1.0*FresnelP.*CosTheta.*SinPhi;
pvec{3} = -1.0*FresnelP.*SinTheta;
svec{1} = -1.0*FresnelS.*SinPhi;
svec{2} = 1.0*FresnelS.*CosPhi;
svec{3} = 0;

%% XYZ direction component of P/S polarization
PolarizationVector = cell(2,3);
for jtel = 1:3
    PolarizationVector{1,jtel} = CosPhi.*pvec{jtel}-SinPhi.*svec{jtel};
    PolarizationVector{2,jtel} = SinPhi.*pvec{jtel}+CosPhi.*svec{jtel};
end

%% Aperture function
ApertureMask = double((XPupil.^2+YPupil.^2)<1.0);
Amplitude = ApertureMask.*sqrt(CosThetaImm);

%% Correct phase difference
Waberration = 1.0*zeros(size(XPupil));
[zvals] = get_rimismatchpars(OTFparams);
Waberration = Waberration+zvals(1)*refimm*CosThetaImm-zvals(2)*refimmnom*CosThetaImmnom-zvals(3)*refmed*CosThetaMed;
PhaseFactor = exp(2*pi*1i*Waberration/lambda);

%% Entrance pupil matrix
PupilMatrix = cell(2,3);
for itel = 1:2
    for jtel = 1:3
        PupilMatrix{itel,jtel} = Amplitude.*PhaseFactor.*PolarizationVector{itel,jtel};
    end
end

%% Normalize
[normint_free] = get_normalization(PupilMatrix,OTFparams);
for itel = 1:2
  for jtel = 1:3
      PupilMatrix{itel,jtel} = PupilMatrix{itel,jtel}/sqrt(normint_free);
  end
end

%% Wave vector
wavevector = cell(1,3);
wavevector{1} = (2*pi*NA/lambda)*XPupil;
wavevector{2} = (2*pi*NA/lambda)*YPupil;
wavevector{3} = (2*pi*refimm/lambda)*CosThetaImm;
wavevectorzmed = (2*pi*refmed/lambda)*CosThetaMed; 

end