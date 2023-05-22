function [OTFinc,OTFinc2d_throughfocus] = get_vectormodelOTF(OTFparams)
  
% copyright Sjoerd Stallinga TUD 2017-2020
  
%% Get pupil matrix
[~,~,wavevector,wavevectorzmed,~,PupilMatrix] = get_pupil_matrix(OTFparams);

%% Get field matrix
[XImage,YImage,ZImage,FieldMatrix] = get_field_matrix(PupilMatrix,wavevector,wavevectorzmed,OTFparams);

%% Get 3D PSF
PSF = get_psf(FieldMatrix,OTFparams);
  
%% Calculation of through-focus OTF for the focal stack by 2D-CZT in xy
[~,~,OTFinc2d_throughfocus] = get_throughfocusotf(PSF,XImage,YImage,OTFparams);

%% Calculation of 3D-OTF by 1D-CZT in z
[~,OTFinc] = get_otf3d(OTFinc2d_throughfocus,ZImage,OTFparams);

%% Masking out-of-band numerical noise to zero
OTFinc = do_OTFmasking3D(OTFinc,OTFparams);

%% Normalize the OTF
centerpos = floor(size(OTFinc)/2)+1;
if length(size(OTFinc))==3
  OTFnorm = OTFinc(centerpos(1),centerpos(2),centerpos(3));
end
if length(size(OTFinc))==2
  OTFnorm = OTFinc(centerpos(1),centerpos(2));
end
OTFinc = OTFinc/OTFnorm;

end
