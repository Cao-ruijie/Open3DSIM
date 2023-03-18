function [normint_free] = get_normalization(PupilMatrix,parameters)
% This function computes the PSF normalization by evaluating the energy
% flow through the lens aperture
%
% copyright Sjoerd Stallinga, TU Delft, 2017

% parameters
Npupil = parameters.Npupil;
NA = parameters.NA;
lambda = parameters.lambda;
pixelsize = parameters.pixelsize;

% intensity matrix
IntensityMatrix = zeros(3,3);
for itel = 1:3
  for jtel = 1:3
    for ztel = 1:2
      pupmat1 = PupilMatrix{ztel,itel};
      pupmat2 = PupilMatrix{ztel,jtel};
      IntensityMatrix(itel,jtel) = IntensityMatrix(itel,jtel)+...
        sum(sum(real(pupmat1.*conj(pupmat2))));
    end
  end
end

% normalization to take into account discretization correctly
% DxyPupil = 2*NA/lambda/Npupil;
% normfac = DxyPupil^2/(pixelsize)^2;
DxyPupil = 2/Npupil;
normfac = DxyPupil^2/(pixelsize*NA/lambda)^2;
IntensityMatrix = normfac*IntensityMatrix;

% evaluation normalization factors
normint_free = sum(diag(IntensityMatrix))/3;


end