function [ftshiftotf] = do_OTFshift(fttempotf,patternpitch,dataparams)
[Nx,Ny,Nz] = size(fttempotf);

% 计算像素级别的平移
ftshiftotf = zeros(Nx,Ny,dataparams.numsteps,Nz);
qvector = patternpitch; % pattern spatial frequency vector
kxy = sqrt(sum(patternpitch.^2));
kotf_lateral = 2*dataparams.NA*dataparams.refmed*dataparams.SIMpixelsize(1)*Nx/dataparams.exwavelength;
kotf_axial = 2*dataparams.NA*dataparams.refmed*dataparams.SIMpixelsize(3)*Nz/dataparams.exwavelength;
sin_fsai = kxy/kotf_lateral;
cos_fsai = sqrt(1-sin_fsai^2);
kz = (1-cos_fsai)*kotf_axial;
qvector(3) = kz;

for jorder = 1:dataparams.numsteps
    if jorder == 1
        ftshiftotf(:,:,1,:) = fttempotf(:,:,:);
    
    elseif jorder == 2
        for jNz = 1:Nz
            ftshiftotf(:,:,2,jNz) = double(shift(squeeze(fttempotf(:,:,jNz)),[qvector(1)/2,qvector(2)/2]));
        end
        ftshiftotf(:,:,2,:) = double(shift(squeeze(fttempotf(:,:,:)),[0,0,qvector(3)])) + double(shift(squeeze(fttempotf(:,:,:)),[0,0,-qvector(3)]));
    
    elseif jorder == 3
        for jNz = 1:Nz
            ftshiftotf(:,:,3,jNz) = double(shift(squeeze(fttempotf(:,:,jNz)),[-qvector(1)/2,-qvector(2)/2]));
        end
        ftshiftotf(:,:,3,:) = double(shift(squeeze(fttempotf(:,:,:)),[0,0,qvector(3)])) + double(shift(squeeze(fttempotf(:,:,:)),[0,0,-qvector(3)]));
    
    elseif jorder == 4
        for jNz = 1:Nz
            ftshiftotf(:,:,4,jNz) = double(shift(squeeze(fttempotf(:,:,jNz)),[qvector(1),qvector(2)]));
        end
    elseif jorder == 5
        for jNz = 1:Nz
            ftshiftotf(:,:,5,jNz) = double(shift(squeeze(fttempotf(:,:,jNz)),[-qvector(1),-qvector(2)]));
        end
    end
end

end