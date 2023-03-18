function Filter1 = get_filter1(params,lambdaregul)

%% Basic parameter
[Nx,Ny,numsteps,Nz,~,~,numangles] = size(params.originfft);
centerorder = (numsteps+1)/2;
SIMpixelsize = params.SIMpixelsize;
patternangles = squeeze(params.allpatternangle(1,1,1,:))./180*pi;

%% Physical parameter
patternpitch = 2*SIMpixelsize(1)*Nx./squeeze(sqrt(sum(params.allpatternpitch.^2)));
q0 = params.refmed/params.emwavelength;
q0ex = params.refmed/params.exwavelength;
NAl = params.NA/params.emwavelength; % number for parametrization 3D OTF cutoff
NBl = sqrt(q0^2-NAl^2);              % number for parametrization 3D OTF cutoff
Nrad = 4*round(sqrt(Nx*Ny));
delqr = 4*NAl/Nrad;
qr = (-Nrad:Nrad)*delqr;

%% Triangle distribution
DqxSupport = 1/Nx/SIMpixelsize(1); % lateral samping distance spatial frequency space
DqySupport = 1/Ny/SIMpixelsize(2); % lateral samping distance spatial frequency space
DqzSupport = 1/Nz/SIMpixelsize(3); % axial samping distance spatial frequency space
QXSupport = ((1:Nx)-floor(Nx/2)-1)*DqxSupport;    % grid in x
QYSupport = ((1:Ny)-floor(Ny/2)-1)*DqySupport;    % grid in y
QZSupport = ((1:Nz)-floor(Nz/2)-1)*DqzSupport;    % grid in z
[qx,qy,qz] = meshgrid(QXSupport,QYSupport,QZSupport);   % 3D-grids
qrad = sqrt(qx.^2+qy.^2+qz.^2);
qcospol = qz./qrad;                                     % cosine of polar angle of spatial frequency vector
qcospol(floor(Nx/2)+1,floor(Ny/2)+1,floor(Nz/2)+1) = 0; % solve NaN by division through zero
qphi = atan2(qy,qx);

Nazim = 32*numangles;
Npola = 4*Nz+1;                                         % guarantees an odd number which is needed for having one sample in qz = 0 plane, which is needed for consistency with 2D
allazim = (2*(1:Nazim)-1-Nazim)*pi/Nazim;
allcosazim = cos(allazim);
allsinazim = sin(allazim);
allcospola = (2*(1:Npola)-1-Npola)/Npola;
allsinpola = sqrt(1-allcospola.^2);

%% cutoff
cutoff = zeros(Npola,Nazim);
for jpol = 1:Npola
    for jazi = 1:Nazim
        dirx = allsinpola(jpol)*allcosazim(jazi);
        diry = allsinpola(jpol)*allsinazim(jazi);
        dirz = allcospola(jpol);
        B = zeros(size(qr));
        for jangle = 1:numangles
            qvector = [cos(patternangles(jangle)) sin(patternangles(jangle))]/patternpitch(jangle);
            axialshift = q0ex-sqrt(q0ex^2-1/patternpitch(jangle)^2);
            for jorder = 1:numsteps
                mm = jorder-centerorder;
                qpar = sqrt((qr*dirx-mm*qvector(1)).^2+(qr*diry-mm*qvector(2)).^2);
                qax = qr*dirz;
                if mod(mm,2)==0
                    maskmn = (qax-NBl).^2+(qpar-NAl).^2<=q0^2;
                    maskpl = (qax+NBl).^2+(qpar-NAl).^2<=q0^2;
                    Badd = maskpl&maskmn;
                end
                if mod(mm,2)==1
                    maskplmn = (qax+axialshift-NBl).^2+(qpar-NAl).^2<=q0^2;
                    maskplpl = (qax+axialshift+NBl).^2+(qpar-NAl).^2<=q0^2;
                    maskmnmn = (qax-axialshift-NBl).^2+(qpar-NAl).^2<=q0^2;
                    maskmnpl = (qax-axialshift+NBl).^2+(qpar-NAl).^2<=q0^2;
                    Badd = (maskplmn&maskplpl)|(maskmnmn&maskmnpl);
                end
                B = B|Badd;
            end
        end
        cutoff(jpol,jazi) = sum(double(B))*delqr/2;
    end
end

%% Cutoff map
alljazi = ceil((pi+qphi)*Nazim/2/pi);
alljpol = ceil((1+qcospol)*Npola/2);
alljpol(alljpol<1) = 1;         % round off qcospol=-1 cases to index=1
cutoffmap = zeros(Nx,Ny,Nz);
for jx = 1:Nx
    for jy = 1:Ny
        for jz = 1:Nz
            jpol = alljpol(jx,jy,jz);
            jazi = alljazi(jx,jy,jz);
            cutoffmap(jx,jy,jz) = cutoff(jpol,jazi);
        end
    end
end

%% Triangle Apo-filter
epsy = 1e2*eps;
Apo = 1-qrad./cutoffmap;
triangleexponent = 0.4;
Apo(Apo<epsy) = 0;
Apo = Apo.^triangleexponent;
centerposition = [floor(Nx/2)+1,floor(Ny/2)+1,floor(Nz/2)+1];
Apo = (Apo+complexparity(Apo,centerposition))/2;

%% Filter1
Filter1 = Apo./(params.OTFshiftfinal+lambdaregul); 
Filter1(isnan(Filter1)) = epsy;

end