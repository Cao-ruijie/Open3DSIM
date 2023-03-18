function tempshiftfft_filter = phase_ordershift(tempfft,patternpitch,OTFem,dataparams)

[Nx,Ny,maxorder,Nz] = size(tempfft);

max_OTF = max(max(max(OTFem)));
Mask = zeros(Nx,Ny,Nz);
for jNx = 1:Nx
    for jNy = 1:Ny
        for jNz = 1:Nz
            if OTFem(jNx,jNy,jNz)>max_OTF*0.02
               Mask(jNx,jNy,jNz)=1;
            end
        end
    end
end

% 计算横向亚像素级别的平移
ftshiftorderims = zeros(Nx,Ny,maxorder,Nz);
qvector = patternpitch/2; % pattern spatial frequency vector
kxy = Nx*dataparams.SIMpixelsize(1)./sqrt(sum(qvector.^2));
q0ex = dataparams.refmed/dataparams.emwavelength;
kz = q0ex-sqrt(q0ex^2-1/kxy.^2);
qvector(3) = kz*Nz*dataparams.SIMpixelsize(3);
qvector(1:2) = qvector(1:2)*2;

% 频谱以及OTF的搬移
for jorder = 1:maxorder
    if jorder == 1

        ftshiftorderims(:,:,1,:) = tempfft(:,:,1,:);
        OTFshift(:,:,1,:) = OTFem(:,:,:);
        Maskshift(:,:,1,:) = Mask(:,:,:);
        
    elseif jorder == 2

        for jNz = 1:Nz
            ftshiftorderims(:,:,2,jNz) = double(shift(squeeze(tempfft(:,:,2,jNz)),[-qvector(1)/2,-qvector(2)/2]));
            OTFshift(:,:,2,jNz) = double(shift(squeeze(OTFem(:,:,jNz)),[-qvector(1)/2,-qvector(2)/2]));
            Maskshift(:,:,2,jNz) = double(shift(squeeze(Mask(:,:,jNz)),[-qvector(1)/2,-qvector(2)/2]));
        end
        ftshiftorderims(:,:,2,:) = double(shift(squeeze(ftshiftorderims(:,:,2,:)),[0,0,qvector(3)])) + double(shift(squeeze(ftshiftorderims(:,:,2,:)),[0,0,-qvector(3)]));
        OTFshift(:,:,2,:) = double(shift(squeeze(OTFshift(:,:,2,:)),[0,0,qvector(3)])) + double(shift(squeeze(OTFshift(:,:,2,:)),[0,0,-qvector(3)]));
        Maskshift(:,:,2,:) = double(shift(squeeze(Maskshift(:,:,2,:)),[0,0,qvector(3)])) + double(shift(squeeze(Maskshift(:,:,2,:)),[0,0,-qvector(3)]));

    elseif jorder == 3

        for jNz = 1:Nz
            ftshiftorderims(:,:,3,jNz) = double(shift(squeeze(tempfft(:,:,3,jNz)),[qvector(1)/2,qvector(2)/2]));
            OTFshift(:,:,3,jNz) = double(shift(squeeze(OTFem(:,:,jNz)),[qvector(1)/2,qvector(2)/2]));    
            Maskshift(:,:,3,jNz) = double(shift(squeeze(Mask(:,:,jNz)),[qvector(1)/2,qvector(2)/2]));
        end
        ftshiftorderims(:,:,3,:) = double(shift(squeeze(ftshiftorderims(:,:,3,:)),[0,0,qvector(3)])) + double(shift(squeeze(ftshiftorderims(:,:,3,:)),[0,0,-qvector(3)]));
        OTFshift(:,:,3,:) = double(shift(squeeze(OTFshift(:,:,3,:)),[0,0,qvector(3)])) + double(shift(squeeze(OTFshift(:,:,3,:)),[0,0,-qvector(3)]));
        Maskshift(:,:,3,:) = double(shift(squeeze(Maskshift(:,:,3,:)),[0,0,qvector(3)])) + double(shift(squeeze(Maskshift(:,:,3,:)),[0,0,-qvector(3)]));
        

    elseif jorder == 4

        for jNz = 1:Nz
            ftshiftorderims(:,:,4,jNz) = double(shift(squeeze(tempfft(:,:,4,jNz)),[-qvector(1),-qvector(2)]));
            OTFshift(:,:,4,jNz) = double(shift(squeeze(OTFem(:,:,jNz)),[-qvector(1),-qvector(2)])); 
            Maskshift(:,:,4,jNz) = double(shift(squeeze(Mask(:,:,jNz)),[-qvector(1),-qvector(2)]));
        end

    elseif jorder == 5

        for jNz = 1:Nz
            ftshiftorderims(:,:,5,jNz) = double(shift(squeeze(tempfft(:,:,5,jNz)),[qvector(1),qvector(2)]));
            OTFshift(:,:,5,jNz) = double(shift(squeeze(OTFem(:,:,jNz)),[qvector(1),qvector(2)]));  
            Maskshift(:,:,5,jNz) = double(shift(squeeze(Mask(:,:,jNz)),[qvector(1),qvector(2)]));
        end

    end
end

% 画图
% zzz = 6;order = 2;figure;imshow(squeeze(OTFshift(:,:,order,zzz).*Maskshift(:,:,order,zzz)),[])

% 滤波并计算角度
center =  squeeze(ftshiftorderims(:,:,1,:).*OTFshift(:,:,1,:).*Maskshift(:,:,1,:));
off1   =  squeeze(ftshiftorderims(:,:,2,:).*OTFshift(:,:,2,:).*Maskshift(:,:,2,:));
off_1  =  squeeze(ftshiftorderims(:,:,3,:).*OTFshift(:,:,3,:).*Maskshift(:,:,3,:));
off2   =  squeeze(ftshiftorderims(:,:,4,:).*OTFshift(:,:,4,:).*Maskshift(:,:,4,:));
off_2  =  squeeze(ftshiftorderims(:,:,5,:).*OTFshift(:,:,5,:).*Maskshift(:,:,5,:));
% center =  squeeze(ftshiftorderims(:,:,1,:)).*Maskshift(:,:,1,:);
% off1   =  squeeze(ftshiftorderims(:,:,2,:)).*Maskshift(:,:,2,:);
% off_1  =  squeeze(ftshiftorderims(:,:,3,:)).*Maskshift(:,:,3,:);
% off2   =  squeeze(ftshiftorderims(:,:,4,:)).*Maskshift(:,:,4,:);
% off_2  =  squeeze(ftshiftorderims(:,:,5,:)).*Maskshift(:,:,5,:);
arg1   =  angle(sum(sum(sum(center.*conj(off1)))))
arg_1  =  angle(sum(sum(sum(center.*conj(off_1)))))
arg2   =  angle(sum(sum(sum(center.*conj(off2)))))
arg_2  =  angle(sum(sum(sum(center.*conj(off_2)))))
% tempshiftfft_filter(:,:,1,:) = tempfft(:,:,1,:);
% tempshiftfft_filter(:,:,2,:) = tempfft(:,:,2,:).*exp(1j*arg1);
% tempshiftfft_filter(:,:,3,:) = tempfft(:,:,3,:).*exp(1j*arg_1);
% tempshiftfft_filter(:,:,4,:) = tempfft(:,:,4,:).*exp(1j*arg2);
% tempshiftfft_filter(:,:,5,:) = tempfft(:,:,5,:).*exp(1j*arg_2);

end