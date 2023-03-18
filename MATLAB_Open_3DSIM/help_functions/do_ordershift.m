function [OTFshift,ftshiftorderims,Mask_totol,anneuation,dataparams,anneuation_temp_nonzero] = do_ordershift(fttempimage,patternpitch,dataparams,anneuation_temp_zero,anneuation_temp_nonzero)

[Nx,Ny,maxorder,Nz] = size(fttempimage);
Mask_totol = zeros(Nx,Ny,Nz);

% 计算横向亚像素级别的平移
ftshiftorderims = zeros(Nx,Ny,maxorder,Nz);
qvector = patternpitch/2; % pattern spatial frequency vector
kxy = Nx*dataparams.SIMpixelsize(1)./sqrt(sum(qvector.^2));
q0ex = dataparams.refmed/dataparams.exwavelength;
kz = q0ex-sqrt(q0ex^2-1/kxy.^2);
qvector(3) = kz*Nz*dataparams.SIMpixelsize(3);
qvector(1:2) = qvector(1:2)*2;

ftimage = fttempimage;
OTFshift = zeros(Nx,Ny,maxorder,Nz);
OTFtemp = dataparams.OTFem;

% 频谱搬移过程
for jorder = 1:maxorder
    if jorder == 1

        ftshiftorderims(:,:,1,:) = ftimage(:,:,1,:);
        OTFshift(:,:,1,:) = OTFtemp(:,:,:);
        anneuation(:,:,1,:) = anneuation_temp_zero;
        
    elseif jorder == 2

        for jNz = 1:Nz
            ftshiftorderims(:,:,2,jNz) = double(shift(squeeze(ftimage(:,:,2,jNz)),[-qvector(1)/2,-qvector(2)/2]));
            OTFshift(:,:,2,jNz) = double(shift(squeeze(OTFtemp(:,:,jNz)),[-qvector(1)/2,-qvector(2)/2]));
            anneuation(:,:,2,jNz) = double(shift(squeeze(anneuation_temp_nonzero(:,:,jNz)),[-qvector(1)/2,-qvector(2)/2]));
        end
        ftshiftorderims(:,:,2,:) = double(shift(squeeze(ftshiftorderims(:,:,2,:)),[0,0,qvector(3)])) + double(shift(squeeze(ftshiftorderims(:,:,2,:)),[0,0,-qvector(3)]));
        OTFshift(:,:,2,:) = double(shift(squeeze(OTFshift(:,:,2,:)),[0,0,qvector(3)])) + double(shift(squeeze(OTFshift(:,:,2,:)),[0,0,-qvector(3)]));
        anneuation(:,:,2,:) = double(shift(squeeze(anneuation(:,:,2,:)),[0,0,qvector(3)])) + double(shift(squeeze(anneuation(:,:,2,:)),[0,0,-qvector(3)]));

    elseif jorder == 3

        for jNz = 1:Nz
            ftshiftorderims(:,:,3,jNz) = double(shift(squeeze(ftimage(:,:,3,jNz)),[qvector(1)/2,qvector(2)/2]));
            OTFshift(:,:,3,jNz) = double(shift(squeeze(OTFtemp(:,:,jNz)),[qvector(1)/2,qvector(2)/2]));
            anneuation(:,:,3,jNz) = double(shift(squeeze(anneuation_temp_nonzero(:,:,jNz)),[qvector(1)/2,qvector(2)/2]));

        end
        ftshiftorderims(:,:,3,:) = double(shift(squeeze(ftshiftorderims(:,:,3,:)),[0,0,qvector(3)])) + double(shift(squeeze(ftshiftorderims(:,:,3,:)),[0,0,-qvector(3)]));
        OTFshift(:,:,3,:) = double(shift(squeeze(OTFshift(:,:,3,:)),[0,0,qvector(3)])) + double(shift(squeeze(OTFshift(:,:,3,:)),[0,0,-qvector(3)]));
        anneuation(:,:,3,:) = double(shift(squeeze(anneuation(:,:,3,:)),[0,0,qvector(3)])) + double(shift(squeeze(anneuation(:,:,3,:)),[0,0,-qvector(3)]));
        

    elseif jorder == 4

        for jNz = 1:Nz
            ftshiftorderims(:,:,4,jNz) = double(shift(squeeze(ftimage(:,:,4,jNz)),[-qvector(1),-qvector(2)]));
            OTFshift(:,:,4,jNz) = double(shift(squeeze(OTFtemp(:,:,jNz)),[-qvector(1),-qvector(2)]));
            anneuation(:,:,4,jNz) = double(shift(squeeze(anneuation_temp_nonzero(:,:,jNz)),[-qvector(1),-qvector(2)]));     
        end

    elseif jorder == 5

        for jNz = 1:Nz
            ftshiftorderims(:,:,5,jNz) = double(shift(squeeze(ftimage(:,:,5,jNz)),[qvector(1),qvector(2)]));
            OTFshift(:,:,5,jNz) = double(shift(squeeze(OTFtemp(:,:,jNz)),[qvector(1),qvector(2)]));
            anneuation(:,:,5,jNz) = double(shift(squeeze(anneuation_temp_nonzero(:,:,jNz)),[qvector(1),qvector(2)]));
        end

    end
end

%% 求不同相位陷波后的频谱
ftshiftorderims1 = zeros(Nx,Ny,maxorder,Nz);
for jorder = 1:maxorder
    ftshiftorderims1(:,:,jorder,:) = squeeze(ftshiftorderims(:,:,jorder,:).*anneuation(:,:,jorder,:));
end

%% 相位再补偿
center = squeeze(ftshiftorderims1(:,:,1,:));
off1 = squeeze(ftshiftorderims1(:,:,2,:));
off_1 = squeeze(ftshiftorderims1(:,:,3,:));
off2 = squeeze(ftshiftorderims1(:,:,4,:));
off_2 = squeeze(ftshiftorderims1(:,:,5,:));
arg1 = angle(sum(sum(sum(center.*conj(off1)))))
arg_1 = angle(sum(sum(sum(center.*conj(off_1)))))
arg2 = angle(sum(sum(sum(center.*conj(off2)))))
arg_2 = angle(sum(sum(sum(center.*conj(off_2)))))
ftshiftorderims1(:,:,2,:)=ftshiftorderims1(:,:,2,:).*exp(1j*arg1);
ftshiftorderims1(:,:,3,:)=ftshiftorderims1(:,:,3,:).*exp(1j*arg_1);
ftshiftorderims1(:,:,4,:)=ftshiftorderims1(:,:,4,:).*exp(1j*arg2);
ftshiftorderims1(:,:,5,:)=ftshiftorderims1(:,:,5,:).*exp(1j*arg_2);
end