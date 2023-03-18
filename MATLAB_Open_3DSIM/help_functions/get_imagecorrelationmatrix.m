function [imcorrmat,qpixelsize] = get_imagecorrelationmatrix(tempimage,lowpassfilter,qvector,pixelsize,zoomfac,numpixels_czt,maxorder,dolowpass,debugmode)
% This function computes the image correlation matrix of all possible
% combinations of raw images by application of the chirp z-transform zoomed
% in on the expected peaks at integer multiples of the pattern spatial 
% frequency vector.
%
% copyright Sjoerd Stallinga TUD 2017-2020

[Nx,Ny,numsteps] = size(tempimage);
xsize = Nx*pixelsize(1)/2; % 1/2 size image in image space
ysize = Ny*pixelsize(2)/2; % 1/2 size image in image space
% qpixelsize(1) = 1/2/xsize/zoomfac; % sampling distance Fourier space with zoomin taken into account
% qpixelsize(2) = 1/2/ysize/zoomfac; % sampling distance Fourier space with zoomin taken into account
% Mx = numpixels_czt; % number of pixels in Fourier space
% My = numpixels_czt; % number of pixels in Fourier space
% qxrange = Mx*qpixelsize(1)/2; % 1/2 size cross correlation in Fourier space
% qyrange = My*qpixelsize(2)/2; % 1/2 size cross correlation in Fourier space
qxrange = 1/pixelsize(1)/2/zoomfac; % 1/2 size cross correlation in Fourier space
qyrange = 1/pixelsize(2)/2/zoomfac; % 1/2 size cross correlation in Fourier space
Mx = numpixels_czt; % number of pixels in Fourier space
My = numpixels_czt; % number of pixels in Fourier space
qpixelsize(1) = 2*qxrange/Mx; % sampling distance Fourier space with zoomin taken into account
qpixelsize(2) = 2*qyrange/My; % sampling distance Fourier space with zoomin taken into account

% compute arrays needed for chirp z-transform
[Ax,Bx,Dx] = prechirpz(xsize,qxrange,Nx,Mx);
[Ay,By,Dy] = prechirpz(ysize,qyrange,Ny,My);

% compute inner product between pattern spatial frequency vector qvector
% and pixel position vector
xx = (1:Nx)*pixelsize(1) - (floor(Nx/2)+1)*pixelsize(1);
yy = (1:Ny)*pixelsize(2) - (floor(Ny/2)+1)*pixelsize(2);
[Xp,Yp] = meshgrid(yy,xx);
phasefield = 2*pi*(qvector(1)*Xp+qvector(2)*Yp);

% Make low-pass filter with conjugate of 2D-OTF,
% the low-pass filtered version of the images may improve the quantitative
% estimate of the pattern spatial frequencies, but not of the pattern
% phases, initial tests show no conclusive positive impact on reconstruction
% quality.
if dolowpass
 tempimage_lowpass = do_filtering(tempimage,lowpassfilter); 
 tempimage_doublelowpass = do_filtering(tempimage_lowpass,lowpassfilter); 
end

% loop over the bands/orders to get the cross-correlation
imcorrmat = zeros(Mx,My,maxorder,numsteps,numsteps);
for jorder = 1:maxorder
  patternmask = exp(1i*(jorder-1)*phasefield);
  for jstep1 = 1:numsteps
    for jstep2 = jstep1:numsteps
      if ~dolowpass
        image1 = squeeze(tempimage(:,:,jstep1));
        image2 = squeeze(tempimage(:,:,jstep2));
      else
        image1 = squeeze(tempimage_lowpass(:,:,jstep1));
        image2 = squeeze(tempimage_lowpass(:,:,jstep2));
      end
      image_in = image1.*image2;
      % shot noise correction
      if jstep2==jstep1
        if ~dolowpass
          image_in = image_in-image1;
        else
          image_in = image_in-squeeze(tempimage_doublelowpass(:,:,jstep1));
        end
      end
      % multiply with pattern mask exp(i*m*qvector.vec{r}) 
      % for FT peak shift to m*qvector, m = 0,1,maxorder-1
      image_in = patternmask.*image_in;
      % make the chirp z-transform
      image_temp = transpose(cztfunc(image_in,Ax,Bx,Dx));
      imcorrmat(:,:,jorder,jstep1,jstep2) = transpose(cztfunc(image_temp,Ay,By,Dy));
      % use symmetry to reduce computation time
      imcorrmat(:,:,jorder,jstep2,jstep1) = imcorrmat(:,:,jorder,jstep1,jstep2); 
    end
  end
end

% make plots of cross-correlation functions
if debugmode
  scrsz = [1,1,1366,768];
  qx = (1:Mx)*qpixelsize(1) - (Mx+1)*qpixelsize(1)/2;
  qy = (1:My)*qpixelsize(2) - (My+1)*qpixelsize(2)/2;
  for jorder = 1:maxorder
    figure
    set(gcf,'Position',[0.15*scrsz(3) 0.15*scrsz(4) 0.8*scrsz(4) 0.8*scrsz(4)])
    titlestring = strcat('cross-correlations for shift = ',num2str(jorder-1));
    sgtitle(titlestring)
    jim = 0;
    for jstep1 = 1:numsteps
      for jstep2 = 1:numsteps
        jim = jim+1;
        subplot(numsteps,numsteps,jim)
        tempim = squeeze(imcorrmat(:,:,jorder,jstep1,jstep2));
        hold on
        box on
        imagesc(1e3*qx,1e3*qy,abs(tempim))
        plot(1e3*qx,zeros(size(qy)),'r')
        plot(zeros(size(qx)),1e3*qy,'r')
        titlestring = strcat(num2str(jstep1),'-',num2str(jstep2));
        title(titlestring)
%         xlabel('q_{x} [1/{\mu}m]')
%         ylabel('q_{y} [1/{\mu}m]')
        axis square
        axis off
      end
    end
  end
end

end