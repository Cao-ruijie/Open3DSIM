function PSFout = do_pixel_blurring(PSFin,OTFparams)
% copyright Sjoerd Stallinga, TU Delft, 2018

oversampling = OTFparams.pixelsize/OTFparams.samplingdistance;
PSFsize = size(PSFin);
Mx = PSFsize(1);
My = PSFsize(2);
if mod(Mx,2)==1
    centerx = (Mx+1)/2;
else
    centerx = Mx/2+1;
end
if mod(My,2)==1
    centery = (My+1)/2;
else
    centery = My/2+1;
end

qxnorm = oversampling*((1:Mx)-centerx)/Mx;
qynorm = oversampling*((1:My)-centery)/My;
[Qx,Qy] = meshgrid(qxnorm,qynorm);
pixelblurkernel = sinc(Qx).*sinc(Qy);

if length(PSFsize)==2
    OTF = fftshift(fft2(PSFin));
    OTF = pixelblurkernel.*OTF;
    PSFout = ifft2(ifftshift(OTF));
    PSFout = real(PSFout);
end

if length(PSFsize)==3
    Mz = PSFsize(3);
    PSFout = zeros(Mx,My,Mz);
    for jz = 1:Mz
        PSFslice = squeeze(PSFin(:,:,jz));
        OTF = fftshift(fft2(PSFslice));
        OTF = pixelblurkernel.*OTF;
        PSFout(:,:,jz) = ifft2(ifftshift(OTF));
        PSFout(:,:,jz) = real(PSFout(:,:,jz));
    end
end

end

