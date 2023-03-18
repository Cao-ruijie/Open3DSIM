function window = get_window2D(Nx,Ny,windowsize)
% This function computes a Hamming/Tukey window for making the edges soft
% so as to prevent streaking in the Fourier images. 
%
% copyright Sjoerd Stallinga, TU Delft, 2017-2020

epsy = 100*eps;
windowsize = max([windowsize,epsy]); % guarantees positive value above machine precision 
xx = linspace(-(1-1/Nx)/2,(1-1/Nx)/2,Nx);
yy = linspace(-(1-1/Ny)/2,(1-1/Ny)/2,Ny);
[X,Y] = meshgrid(xx,yy);
window = (ones(Nx,Ny)-(1/2-abs(X)<windowsize).*cos(pi*(1/2-abs(X))/windowsize/2).^2)...
      .*(ones(Nx,Ny)-(1/2-abs(Y)<windowsize).*cos(pi*(1/2-abs(Y))/windowsize/2).^2);
end

