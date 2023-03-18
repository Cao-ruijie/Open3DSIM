function [LukoszBound,TrianglexFilter,MaskOTFsupport] = get_apodization(shiftOTFinc,triangleexponent,SIMpixelsize,patternpitch,patternangles,lambda,lambdaex,NA,refmed,debugmode)
% This function computes the SIM Lukosz bound (Righolt et al, Opt. 
% Express 21, 24431–24451 (2013)) and trianglex = triangle^x filter 
% (triangle = linear interpolation from 1 at the origin to 0 at the SIM 
% cutoff, trianglex = triangle^x) apodization functions, as well as a
% binary mask function that indicates the 3D SIM OTF support. 
% The 3D-SIM OTF-support is the union of the shifted order OTF supports,
% where the shift depends on the contributing order.
% The cutoff of the incoherent 3D-OTF is described by the circular arcs:
% (q_z \pm n*cosalpha/lambda)^2 + (q_par - n*sinalpha/lambda)^2 =
% (n/lambda)^2
% with NA = n*sinalpha and qpar = sqrt(q_x^2+q_y^2), with (q_x,q_y,q_z)
% the spatial frequency vector. The lateral cutoff is 2*n*sinalpha/lambda 
% (found for q_z=0), the axial cutoff is n*(1-cosalpha)/lambda (found
% for qpar =  n*sinalpha/lambda).
% The apodization functions are computed as:
% trianglex = (1-abs(q)/F(q))^x and 
% Lukosz = cos(pi*abs(q)/2/F(q))
% where abs(q)=sqrt(q_x^2+q_y^2+q_z^2) and F(q) a function such that
% F(q) only depends on the direction of q in such that it gives the
% SIM cutoff in that direction.
%
% Copyright: Sjoerd Stallinga, Delft University of Technology, 2017-2020

% parameters and spatial frequency sampling
[Nx,Ny,maxorder,Nz,numangles] = size(shiftOTFinc);
numorders = 2*maxorder-1; % # image Fourier orders per angle
centerorder = (numorders+1)/2;

epsy = 1e2*eps;

% compute 3D grid of spatial frequencies
DqxSupport = 1/Nx/SIMpixelsize(1); % lateral samping distance spatial frequency space
DqySupport = 1/Ny/SIMpixelsize(2); % lateral samping distance spatial frequency space
DqzSupport = 1/Nz/SIMpixelsize(3); % axial samping distance spatial frequency space
QXSupport = ((1:Nx)-floor(Nx/2)-1)*DqxSupport; % grid in x
QYSupport = ((1:Ny)-floor(Ny/2)-1)*DqySupport; % grid in y
QZSupport = ((1:Nz)-floor(Nz/2)-1)*DqzSupport; % grid in z
[qx,qy,qz] = meshgrid(QXSupport,QYSupport,QZSupport); % 3D-grids
qrad = sqrt(qx.^2+qy.^2+qz.^2); % magnitude of spatial frequency vector=
qcospol = qz./qrad; % cosine of polar angle of spatial frequency vector
qcospol(floor(Nx/2)+1,floor(Ny/2)+1,floor(Nz/2)+1) = 0; % solve NaN by division through zero
qphi = atan2(qy,qx); % azimuthal angle of spatial frequency vector

% optical parameters
q0 = refmed/lambda; 
q0ex = refmed/lambdaex;
NAl = NA/lambda; % number for parametrization 3D OTF cutoff
NBl = sqrt(q0^2-NAl^2); % number for parametrization 3D OTF cutoff

% compute a mask function that is 1 inside the SIM OTF support and 0 outside
MaskOTFsupport = zeros(Nx,Ny,Nz);
for jangle = 1:numangles
  qvector = [cos(patternangles(jangle)) sin(patternangles(jangle))]/patternpitch(jangle);
  axialshift = q0ex-sqrt(q0ex^2-1/patternpitch(jangle)^2); 
  for jorder = 1:numorders
    mm = jorder-centerorder;
    qpar = sqrt((qx-mm*qvector(1)).^2+(qy-mm*qvector(2)).^2);
    axialcutoff = sqrt(q0^2-(qpar-NAl).^2)-NBl;
    if mod(mm,2)==1
%       OTFmaskpl = double(axialcutoff+DqzSupport/2 >= abs(qz-axialshift));
%       OTFmaskmn = double(axialcutoff+DqzSupport/2 >= abs(qz+axialshift));
      OTFmaskpl = double(axialcutoff+epsy >= abs(qz-axialshift));
      OTFmaskmn = double(axialcutoff+epsy >= abs(qz+axialshift));
      OTFmask = double(OTFmaskpl|OTFmaskmn);
    else
%       OTFmask = double(axialcutoff+DqzSupport/2 >= abs(qz));
      OTFmask = double(axialcutoff+epsy >= abs(qz));
    end
    OTFmask = double(qpar<=2*NAl).*OTFmask;
    MaskOTFsupport = double(MaskOTFsupport|OTFmask);
  end
end

% compute the cutoff spatial frequency as a function of local direction
% for each direction a line is set up in that direction, for each angle and
% order a logical is computed whether a part of that line is within the
% support of that shifted order. The unity of all these logicals gives the
% part of the line within the extended SIM support and is hence a measure
% for the cutoff spatial frequency in that direction.

% uniform sampling of the polar and azimuthal angles on the unit sphere
Nazim = 32*numangles;
Npola = 4*Nz+1; % guarantees an odd number which is needed for having one sample in qz=0 plane, which is needed for consistency with 2D
allazim = (2*(1:Nazim)-1-Nazim)*pi/Nazim;
allcosazim = cos(allazim);
allsinazim = sin(allazim);
allcospola = (2*(1:Npola)-1-Npola)/Npola;
allsinpola = sqrt(1-allcospola.^2);

% sampling of the lines for which we determine the length from the origin
% to the spatial frequency cutoff surface
Nrad = 4*round(sqrt(Nx*Ny));
delqr = 4*NAl/Nrad;
qr = (-Nrad:Nrad)*delqr;

% compute cutoff spatial frequency for all polar and azimuthal angles
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
      for jorder = 1:numorders
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

% compute the polar and azimuthal indices for each 3D-spatial frequency by
% nearest-neighbour interpolation
alljazi = ceil((pi+qphi)*Nazim/2/pi);
alljpol = ceil((1+qcospol)*Npola/2); 
alljpol(alljpol<1) = 1; % round off qcospol=-1 cases to index=1

% % additional weight and sign variables for linear interpolation scheme
% delqphi = qphi-(2*alljazi-1-Nazim)*pi/Nazim; 
% signqphi = double(qphi>0);
% wqphi = 1-(Nazim/pi)*abs(delqphi);
% delqcospol = qcospol-(2*alljpol-1-Npola)/Npola;
% signqcospol = double(qcospol>0);
% wqcospol = 1-Npola*abs(delqcospol);

% compute the spatial frequency cutoff map
cutoffmap = zeros(Nx,Ny,Nz);
for jx = 1:Nx
  for jy = 1:Ny
    for jz = 1:Nz
      jpol = alljpol(jx,jy,jz);
      jazi = alljazi(jx,jy,jz);
%       % linear interpolation
%       signpol = signqcospol(jx,jy,jz);
%       signazi = signqphi(jx,jy,jz);
%       jazi_interp = 1+mod(jazi-1+signazi,Nazim);
%       jpol_interp = max(min(jpol+signpol,Npola),1);
%       wpol = wqcospol(jx,jy,jz);
%       wazi = wqphi(jx,jy,jz);
%       cutoffmap(jx,jy,jz) = wpol*wazi*cutoff(jpol,jazi)+...
%         wpol*(1-wazi)*cutoff(jpol,jazi_interp)+...
%         (1-wpol)*wazi*cutoff(jpol_interp,jazi)+...
%         (1-wpol)*(1-wazi)*cutoff(jpol_interp,jazi_interp);
      % nearest neighbour interpolation
      cutoffmap(jx,jy,jz) = cutoff(jpol,jazi);
    end
  end
end

% % compute a mask function that is 1 inside the SIM OTF support and 0 outside
% ... simple recipe but gives a bit jagged edges...
% MaskOTFsupport = double(qrad<=cutoffmap);

% compute the triangle filter and the Lukosz bound filter 
TrianglexFilter = 1-qrad./cutoffmap;
LukoszBound = cos(pi*qrad./(qrad+cutoffmap));
LukoszBound(LukoszBound<epsy) = 0;
TrianglexFilter(TrianglexFilter<epsy) = 0;
TrianglexFilter = TrianglexFilter.^triangleexponent;

% symmetrize to correct for residual errors due to polar/azimuthal 
% parametrization and conversion to 3D spatial frequency grid
centerposition = [floor(Nx/2)+1,floor(Ny/2)+1,floor(Nz/2)+1];
LukoszBound = (LukoszBound+complexparity(LukoszBound,centerposition))/2;
TrianglexFilter = (TrianglexFilter+complexparity(TrianglexFilter,centerposition))/2;

if debugmode
  scrsz = [1,1,1366,768];
  for jz = 1:Nz
    qqz = 1e3*QZSupport(jz);
    figure
    set(gcf,'Position',[0.1*scrsz(3) 0.2*scrsz(4) 0.8*scrsz(3) 0.6*scrsz(4)])
    subplot(1,3,1)
    imagesc(1e3*QXSupport,1e3*QYSupport,squeeze(TrianglexFilter(:,:,jz)))
    axis square
    colorbar
    xlabel('q_{x} [1/{\mu}m]')
    ylabel('q_{y} [1/{\mu}m]')
    title(strcat('Triangle Filter^{exponent}, q_{z}=',num2str(qqz,'% 3.1f'),'/{\mu}m'))
    subplot(1,3,2)
    imagesc(1e3*QXSupport,1e3*QYSupport,squeeze(LukoszBound(:,:,jz)))
    axis square
    colorbar
    xlabel('q_{x} [1/{\mu}m]')
    ylabel('q_{y} [1/{\mu}m]')
    title(strcat('Lukosz Bound, q_{z}=',num2str(qqz,'% 3.1f'),'/{\mu}m'))
    subplot(1,3,3)
    imagesc(1e3*QXSupport,1e3*QYSupport,squeeze(MaskOTFsupport(:,:,jz)))
    axis square
    colorbar
    xlabel('q_{x} [1/{\mu}m]')
    ylabel('q_{y} [1/{\mu}m]')
    title(strcat('Mask OTF support, q_{z}=',num2str(qqz,'% 3.1f'),'/{\mu}m'))
  end
end

end

