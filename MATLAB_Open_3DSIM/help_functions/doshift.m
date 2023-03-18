function [originfftshift,OTFshift1] = doshift(OTFtemp,tempimage,patternpitch,dataparams,average_pitch)

%% Basic parameters
[Nx,Ny,maxorder,Nz] = size(tempimage);
ftshiftorderims = zeros(Nx,Ny,maxorder,Nz);
qvector = patternpitch/2;          % pattern spatial frequency vector
qvector_xy = sqrt(sum(qvector.^2))/2;
kxy = Nx*dataparams.SIMpixelsize(1)./average_pitch;
q0ex = dataparams.refmed/dataparams.exwavelength;
kz = q0ex-sqrt(q0ex^2-1/kxy.^2);
qvector(3) = kz*Nz*dataparams.SIMpixelsize(3);
qvector_z = qvector(3);
qvector(1:2) = patternpitch;

%% Compute notch-filter
XSupport = ((1:Nx)-floor(Nx/2)-1); % qx grid
YSupport = ((1:Ny)-floor(Ny/2)-1); % qy grid
ZSupport = ((1:Nz)-floor(Nz/2)-1); % qz grid
[qx,qy,qz] = meshgrid(XSupport,YSupport,ZSupport); 
notchwidthxy = dataparams.notchwidthxy1; % notch width
notchdips = dataparams.notchdips1;       % notch depth
qradsq = ( qx/qvector_xy ).^2+( qy/qvector_xy ).^2+( qz/qvector_z ).^2;
notch = 1 - notchdips*exp(-qradsq/2/notchwidthxy^2);
Mask = ones(Nx,Ny,Nz);
Mask(abs(dataparams.OTFem)<0.001)=0;     % notch mask
notch = notch.*Mask;
notch = notch./max(max(max(notch)));     % normalize
OTFtemp1 = OTFtemp.*notch;
clear dataparams qx qy qz XSupport YSupport ZSupport notch qradsq

%% Shift to the proper position
m = 1;
for jorder = 1:maxorder
    if jorder == 1     % 0th frequency
        ftshiftorderims(:,:,1,:) = tempimage(:,:,1,:);
        OTFshift0(:,:,1,:) = OTFtemp1(:,:,:);   
    elseif jorder == 2
        for jNz = 1:Nz % 1th frequency
            ftshiftorderims(:,:,2,jNz) = double(shift(squeeze(tempimage(:,:,2,jNz)),[m*qvector(1)/2,m*qvector(2)/2]));
            OTFshift0(:,:,2,jNz) = 0.5*double(shift(squeeze(OTFtemp1(:,:,jNz)),[m*qvector(1)/2,m*qvector(2)/2]));
        end
        OTFshift0(:,:,2,:) = double(shift(squeeze(OTFshift0(:,:,2,:)),[0,0,qvector(3)])) + double(shift(squeeze(OTFshift0(:,:,2,:)),[0,0,-qvector(3)]));  
    elseif jorder == 3 % -1th frequency
        for jNz = 1:Nz
            ftshiftorderims(:,:,3,jNz) = double(shift(squeeze(tempimage(:,:,3,jNz)),[-m*qvector(1)/2,-m*qvector(2)/2])); 
            OTFshift0(:,:,3,jNz) = 0.5*double(shift(squeeze(OTFtemp1(:,:,jNz)),[-m*qvector(1)/2,-m*qvector(2)/2]));
        end
        OTFshift0(:,:,3,:) = double(shift(squeeze(OTFshift0(:,:,3,:)),[0,0,qvector(3)])) + double(shift(squeeze(OTFshift0(:,:,3,:)),[0,0,-qvector(3)]));
    elseif jorder == 4 % 2th frequency
        for jNz = 1:Nz
            ftshiftorderims(:,:,4,jNz) = double(shift(squeeze(tempimage(:,:,4,jNz)),[m*qvector(1),m*qvector(2)]));
            OTFshift0(:,:,4,jNz) = double(shift(squeeze(OTFtemp1(:,:,jNz)),[m*qvector(1),m*qvector(2)]));
        end
    elseif jorder == 5 % -2th frequency
        for jNz = 1:Nz
            ftshiftorderims(:,:,5,jNz) = double(shift(squeeze(tempimage(:,:,5,jNz)),[-m*qvector(1),-m*qvector(2)]));
            OTFshift0(:,:,5,jNz) = double(shift(squeeze(OTFtemp1(:,:,jNz)),[-m*qvector(1),-m*qvector(2)]));
        end
    end
end

ftshiftorderims1 = zeros(Nx,Ny,maxorder,Nz);
for jorder = 1:maxorder
    ftshiftorderims1(:,:,jorder,:) = squeeze(ftshiftorderims(:,:,jorder,:)).*squeeze(OTFshift0(:,:,jorder,:));
end

%% Phase correction
center = squeeze(ftshiftorderims1(:,:,1,:));
off1 = squeeze(ftshiftorderims1(:,:,2,:));
off_1 = squeeze(ftshiftorderims1(:,:,3,:));
off2 = squeeze(ftshiftorderims1(:,:,4,:));
off_2 = squeeze(ftshiftorderims1(:,:,5,:));
arg1 = angle(sum(sum(sum(center.*conj(off1)))));
arg_1 = angle(sum(sum(sum(center.*conj(off_1)))));
arg2 = angle(sum(sum(sum(center.*conj(off2)))));
arg_2 = angle(sum(sum(sum(center.*conj(off_2)))));
clear center off1 off_1 off2 off_2
originfftshift(:,:,1,:) = ftshiftorderims(:,:,1,:);
originfftshift(:,:,2,:) = ftshiftorderims(:,:,2,:).*exp(1j*arg1);
originfftshift(:,:,3,:) = ftshiftorderims(:,:,3,:).*exp(1j*arg_1);
originfftshift(:,:,4,:) = ftshiftorderims(:,:,4,:).*exp(1j*arg2);
originfftshift(:,:,5,:) = ftshiftorderims(:,:,5,:).*exp(1j*arg_2);
clear ftshiftorderims1 ftshiftorderims

%% Compute sum of OTF*notch
OTFshift1 = zeros(Nx,Ny,Nz);
for jorder = 1:maxorder
    if jorder == 1
        OTFshift1 = OTFshift1 + abs(squeeze(OTFshift0(:,:,jorder,:)))/2;
    else
        OTFshift1 = OTFshift1 + abs(squeeze(OTFshift0(:,:,jorder,:)));
    end
end

end