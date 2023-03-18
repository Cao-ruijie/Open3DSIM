function PSF = get_psf(FieldMatrix,OTFparams)

%% Average the field matrix to compute PSF
dims = size(FieldMatrix);
Mz = dims(3);
imdims = size(FieldMatrix{1,1,1});
Mx = imdims(1);
My = imdims(2);
PSF = zeros(Mx,My,Mz);
for jz = 1:Mz
    for jtel = 1:3
        for itel = 1:2
          PSF(:,:,jz) = PSF(:,:,jz) + (1/3)*abs(FieldMatrix{itel,jtel,jz}).^2;
        end
    end
end

%% Pixel blurring
PSF = do_pixel_blurring(PSF,OTFparams);

end