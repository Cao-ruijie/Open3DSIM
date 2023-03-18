function ftshiftorderims = notchfilter(tempimage,patternpitch,dataparams,attenuation,average_pitch)

%% Basic parameter
[Nx,Ny,maxorder,Nz] = size(tempimage);
qvector = 1.0*patternpitch/2;                               % shift on xoy plane(pixel)
qvector_xy = sqrt(sum(qvector.^2))/2;
kxy = Nx*dataparams.SIMpixelsize(1)./average_pitch;
q0ex = dataparams.refmed/dataparams.exwavelength;
kz = q0ex-sqrt(q0ex^2-1/kxy.^2);                            % shift on yoz plane(pixel)
qvector(3) = 1.0*double(1.0*kz*Nz*dataparams.SIMpixelsize(3));
qvector_z = qvector(3);
qvector(1:2) = double(1.0*patternpitch);

%% Calculate notch-filter
XSupport = ((1:Nx)-floor(Nx/2)-1);         % qx grid
YSupport = ((1:Ny)-floor(Ny/2)-1);         % qy grid
ZSupport = ((1:Nz)-floor(Nz/2)-1);         % qz grid
[qx,qy,qz] = meshgrid(XSupport,YSupport,ZSupport); 
notchwidthxy = dataparams.notchwidthxy2;   % notch width
notchdips = dataparams.notchdips2;         % notch depth
qradsq = ( qx/qvector_xy ).^2+( qy/qvector_xy ).^2+( qz/qvector_z ).^2;
notch = 1 - notchdips*exp(-qradsq/2/notchwidthxy^2);
Mask = ones(Nx,Ny,Nz);
Mask(abs(dataparams.OTFem)<0.01)=0;
notch = notch.*Mask.*abs(dataparams.OTFem).^(attenuation)./max(max(max(abs(dataparams.OTFem))));
notch = notch./max(max(max(notch)));

%% shift the separated frequency of 0,¡À1,¡À2 and do the notch operation
m = 1.0;
ftshiftorderims = zeros(Nx,Ny,maxorder,Nz);
anneuation = zeros(Nx,Ny,Nz);
for jorder = 1:maxorder
   if jorder ==1        % 0th frequency
          ftshiftorderims(:,:,1,:) = double(squeeze(tempimage(:,:,1,:)).*notch);
   elseif jorder == 2   % 1th frequency
        for jNz = 1:Nz
            anneuation(:,:,jNz) = double(shift(squeeze(notch(:,:,jNz)),[m*qvector(1)/2,m*qvector(2)/2]));
        end
        anneuation(:,:,:) =double(shift(squeeze(anneuation(:,:,:)),[0,0,qvector(3)])) + double(shift(squeeze(anneuation(:,:,:)),[0,0,-qvector(3)]));
        anneuation(anneuation<0) = 0;
        ftshiftorderims(:,:,2,:) = squeeze(tempimage(:,:,2,:)).*anneuation(:,:,:)/2;
    elseif jorder == 3  % -1th frequency
        for jNz = 1:Nz
            anneuation(:,:,jNz) = double(shift(squeeze(notch(:,:,jNz)),[-m*qvector(1)/2,-m*qvector(2)/2]));
        end
        anneuation(:,:,:) = double(shift(squeeze(anneuation(:,:,:)),[0,0,qvector(3)])) + double(shift(squeeze(anneuation(:,:,:)),[0,0,-qvector(3)]));
        anneuation(anneuation<0) = 0;
        ftshiftorderims(:,:,3,:) = squeeze(tempimage(:,:,3,:)).*anneuation(:,:,:)/2;
    elseif jorder == 4  % 2th frequency
        for jNz = 1:Nz
            anneuation(:,:,jNz) = double(shift(squeeze(notch(:,:,jNz)),[m*qvector(1),m*qvector(2)]));
        end
        anneuation(anneuation<0) = 0;
        ftshiftorderims(:,:,4,:) = squeeze(tempimage(:,:,4,:)).*anneuation(:,:,:);
    elseif jorder == 5  % -2th frequency
        for jNz = 1:Nz
            anneuation(:,:,jNz) = double(shift(squeeze(notch(:,:,jNz)),[-m*qvector(1),-m*qvector(2)]));
        end
        anneuation(anneuation<0) = 0;
        ftshiftorderims(:,:,5,:) = squeeze(tempimage(:,:,5,:)).*anneuation(:,:,:);
    end
end

end