function [patternphases,ordercrossmat] = estimate_patternphases(imcorrmat,patternphases_init,qpixelsize,method,debugmode)
% This function computes the phase matrix from the matrix of image
% cross-correlations using the algorithms described in Wicker2013a or
% Wicker2013b.
%
% copyright Sjoerd Stallinga TUD 2017-2020

% parameters, Mx,My = # Fourier pixels of zoom-in, maxorder = index highest order, numsteps = # phase steps
[Mx,My,maxorder,numsteps,~] = size(imcorrmat);
numorders = 2*maxorder-1; % number of image Fourier orders
% get value in center of zoom-in exactly at estimated pattern spatial frequency
centerx = floor(Mx/2)+1; % is integer anyway if Mx is odd
centery = floor(My/2)+1; % is integer anyway if My is odd
imcorrmat_dc = squeeze(imcorrmat(centerx,centery,:,:,:)); % is now maxorder x numsteps x numsteps array

% make an initial estimate for the phases by the argument of the image
% auto-correlation peaks.
for jstep = 1:numsteps
  patternphases_init(jstep) = mod(angle(imcorrmat_dc(2,jstep,jstep)),2*pi);
end

switch method
  case 'autocorr'
    patternphases = patternphases_init;
    patternphases = mod(patternphases,2*pi);
  case 'crosscorr'
    % define order weight matrix, to be used in the computation of the phase
    % optimization merit function, any combination of unequal orders m1 and m2
    % that do not satisfy the overlap condition m2-m1=+/-m get weight 1.
    orderweightmat = zeros(maxorder,numorders,numorders);
    for jorder1 = 1:numorders
      m1 = jorder1-(numorders+1)/2;
      for jorder2 = 1:numorders
        m2 = jorder2-(numorders+1)/2;
        for jorder = 1:maxorder
          m = jorder-1;
          if (abs(m2-m1)~=m)&&(m2~=m1)
            orderweightmat(jorder,jorder1,jorder2) = 1;
          end
        end
      end
    end

    % squeeze(orderweightmat(1,:,:))
    % squeeze(orderweightmat(2,:,:))
    % squeeze(orderweightmat(3,:,:))

    % make the estimate for the phases
    optimfunc = @(patternphases)phasemeritfunc(patternphases,imcorrmat_dc,orderweightmat);
    options = optimset('Display','off','TolX',1e-6);
    patternphases = fminsearch(optimfunc,patternphases_init,options);
    patternphases = mod(patternphases,2*pi);
end

% analysis of spread in phase steps compared to nominal value of
% 2*pi/numsteps
phasesteps = patternphases-circshift(patternphases,1);
phasesteps = mod(phasesteps+pi,2*pi)-pi;
phasesteps_init = patternphases_init-circshift(patternphases_init,1);
phasesteps_init = mod(phasesteps_init+pi,2*pi)-pi;
phasesteps_mean = mean(phasesteps);
phasesteps_std = std(phasesteps);
fprintf('standard deviation phase steps = %3.4f deg\n',phasesteps_std*180/pi)
  
% compute mixing and unmixing matrix
mixing_matrix = zeros(numsteps,numorders);
for m=-(maxorder-1):(maxorder-1)
  jorder = (numorders+1)/2+m;
  mixing_matrix(:,jorder) = exp(-1i*m*patternphases);
end
unmixing_matrix = pinv(mixing_matrix); % take pseudo-inverse

% compute final cross-correlation between the disentangled orders
ordercrossmat = zeros(Mx,My,maxorder,maxorder,maxorder);
for m = 0:(maxorder-1)
  jorder = m+1;
  for m1 = 0:(maxorder-1)
    jorder1 = (numorders+1)/2+m1;
    for m2 = 0:(maxorder-1)
      jorder2 = (numorders+1)/2+m2;
      tempmat = zeros(Mx,My);
      for jstep1 = 1:numsteps
        for jstep2 = 1:numsteps
          tempmat = tempmat+unmixing_matrix(jorder1,jstep1)*conj(unmixing_matrix(jorder2,jstep2))*squeeze(imcorrmat(:,:,jorder,jstep1,jstep2));
        end
      end
      ordercrossmat(:,:,m+1,m1+1,m2+1) = tempmat;
    end
  end
end

% diagnostic plots for troubleshooting purposes
if debugmode
  
  % make plots of order-order cross-correlation functions
  scrsz = [1,1,1366,768];
  qx = (1:Mx)*qpixelsize(1) - (Mx+1)*qpixelsize(1)/2;
  qy = (1:My)*qpixelsize(2) - (My+1)*qpixelsize(2)/2;
  for jorder1 = 1:maxorder
    for jorder2 = jorder1+1:maxorder
      figure
      set(gcf,'Position',[0.15*scrsz(3) 0.15*scrsz(4) 0.8*scrsz(3) 0.5*scrsz(4)])
      titlestring = strcat('cross-correlation order ',num2str(jorder1-1),' and order ',num2str(jorder2-1));
      sgtitle(titlestring)
      for jorder = 1:maxorder
        subplot(1,maxorder,jorder)
        tempim = squeeze(ordercrossmat(:,:,jorder,jorder1,jorder2));
        imagesc(1e3*qx,1e3*qy,abs(tempim))
        xlabel('q_{x} [1/{\mu}m]')
        ylabel('q_{y} [1/{\mu}m]')
        axis square
        colorbar
        titlestring = strcat('shift = ',num2str(jorder-1));
        title(titlestring)
      end
    end
  end
  
  % make plot of retrieved phase steps
  figure
  box on
  hold on
  plot((phasesteps-phasesteps_mean)*180/pi,'or')
  plot((phasesteps_init-phasesteps_mean)*180/pi,'sb')
  plot([0 numsteps+1],ones(2,1)*phasesteps_std*180/pi,'--k')
  plot([0 numsteps+1],-ones(2,1)*phasesteps_std*180/pi,'--k')
  xlabel('shift')
  ylabel('deviation phase step from ideal value [deg]')
  ylimval = 5*ceil(2*(phasesteps_std*180/pi)/5);
  xlim([0 numsteps+1])
  ylim([-ylimval ylimval])
  legend('final estimate','initial estimate','standard deviation')

end

end
