function newqvector = update_qvector(imcorrmat,qvector,qpixelsize,debugmode)
% This function computes the update on the spatial frequency of the pattern
% by finding peaks in the cross-correlation of all possible image pairs,
% the update is equal to minus the found peak position. This decouples the
% peak finding from the pattern phase estimation, which improves
% robustness.
%
% copyright Sjoerd Stallinga TUD 2017-2020

% size parameters
[Mx,My,maxorder,numsteps1,numsteps2] = size(imcorrmat);

% Fourier space sampling
qx = ((1:Mx)-(Mx+1)/2)*qpixelsize(1);
qy = ((1:My)-(My+1)/2)*qpixelsize(2);

% merit function with sought-for peak, take sum of absolute values squares
% of all possible auto and cross-correlation combinations of the images,
% after summing take the square root
meritmat = zeros(Mx,My);
for jorder = 2:maxorder
  for jstep1 = 1:numsteps1
    for jstep2 = jstep1:numsteps2
      meritmat = meritmat+abs(imcorrmat(:,:,jorder,jstep1,jstep2)).^2; 
    end
  end
end
meritmat = sqrt(meritmat);
meritmat = fliplr(flipud(meritmat)); % to resolve confusion x vs y

% find absolute maximum, first get maximum up to one Fourier pixel size,
% then refine with parabolic fit to region around that maximum
peakroisize = 1;
[maxx,maxy] = get_maxmerit(meritmat,peakroisize);
qxpeak = (maxx-(Mx+1)/2)*qpixelsize(1);
qypeak = (maxy-(My+1)/2)*qpixelsize(2);

if debugmode
  scrsz = [1,1,1366,768];
  figure
  set(gcf,'Position',[0.25*scrsz(3) 0.2*scrsz(4) 0.6*scrsz(4) 0.6*scrsz(4)])
  hold on
  box on
  imagesc(qx,qy,meritmat)
  plot(qx,zeros(size(qy)),'r')
  plot(zeros(size(qx)),qy,'r')
  compass([0 qxpeak],[0 qypeak],'r')
  title('coss-correlation merit function')
  xlabel('q_{x} (nm^{-1})')
  ylabel('q_{y} (nm^{-1})')
  xlim([min(qx),max(qx)])
  ylim([min(qy),max(qy)])
  axis square
end

% find location of peak, and move estimate pattern spatial frequency vector
deltaqvector = -[qxpeak, qypeak];
newqvector = qvector+deltaqvector;

end

