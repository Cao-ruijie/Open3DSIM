function [Notchfilter] = getnotchfilter(Nx,Ny,Nz,pixelsize,dataparams)

cntxy = Nx/2+1;
cntz = floor(Nz/2)+1;
[X,Y]=meshgrid(1:Nx,1:Ny);
rad = hypot(X-cntxy,Y-cntxy);
cycl=rad.*1/Nx/(pixelsize/1000);

Notchfilter = ones(Nx,Ny,Nz);
kxy = sqrt(sum(dataparams.allpatternpitch(:,:,1,1).^2));
kotf_lateral = 2*dataparams.NA*dataparams.refmed*dataparams.SIMpixelsize(1)*Nx/dataparams.exwavelength;
kotf_axial = 2*dataparams.NA*dataparams.refmed*dataparams.SIMpixelsize(3)*Nz/dataparams.exwavelength;
sin_fsai = kxy/kotf_lateral;
cos_fsai = sqrt(1-sin_fsai^2);
kz = (1-cos_fsai)*kotf_axial;


for jNz = cntz-floor(kz)-1:cntz % attfwhm = 0.2-0.7;
    attfwhm = (jNz-(cntz-floor(kz)-1))*0.25+0.2;
    Notchfiltertemp=(1-exp(-power(cycl,2)/(2*power(attfwhm,4))));
    Notchfilter(:,:,jNz) = Notchfiltertemp;
end
for jNz = cntz:cntz+floor(kz)+1
    attfwhm = -(jNz-cntz)*0.25+0.7;
    Notchfiltertemp=(1-exp(-power(cycl,2)/(2*power(attfwhm,4))));
    Notchfilter(:,:,jNz) = Notchfiltertemp;
end

end