function [ld, psim] = psim_sim3d_recon(raw_sim3d, sim_s, theta, calib)
%% calib
% if size(calib{1},1) == 1024
%     fov = size(raw_sim3d,1);
%     calib1 = calib{1}; calib2 = calib{2};
%     calib{1} = calib1((513-fov/2):(512+fov/2),(513-fov/2):(512+fov/2)); 
%     calib{2} = calib2((513-fov/2):(512+fov/2),(513-fov/2):(512+fov/2));
% end
%% Calculate frequency components on orientational dimension
% obtain polarized wide field images
d1_s = mean(raw_sim3d(:,:,1:5),3); 
d2_s = mean(raw_sim3d(:,:,6:10),3)./calib{1}; 
d3_s = mean(raw_sim3d(:,:,11:15),3)./calib{2};
% cal fft
d1_f = fft2(d1_s); 
d2_f = fft2(d2_s); 
d3_f = fft2(d3_s);
% calulate matrixes
pol = mod(theta + pi/2,pi);
mat_ld = 0.5*[1 0.5*exp(2i*pol(1)) 0.5*exp(-2i*pol(1));
    1 0.5*exp(2i*pol(2)) 0.5*exp(-2i*pol(2));
    1 0.5*exp(2i*pol(3)) 0.5*exp(-2i*pol(3))];
mat_ld_inv = inv(mat_ld);
% cal frequency components
ld_fo = mat_ld_inv(1,1)*d1_f + mat_ld_inv(1,2)*d2_f + mat_ld_inv(1,3)*d3_f;
ld_fp = mat_ld_inv(2,1)*d1_f + mat_ld_inv(2,2)*d2_f + mat_ld_inv(2,3)*d3_f;
ld_fm = mat_ld_inv(3,1)*d1_f + mat_ld_inv(3,2)*d2_f + mat_ld_inv(3,3)*d3_f;
% cal ld image
ld_f = ld_fo; ld_f(:,:,2) = ld_fp; ld_f(:,:,4) = ld_fm;
ld = abs(ifft(ifft(ifft(ld_f,[],1),[],2),[],3));
%% Calculate psim image
nx = size(ld,1);
sim_f = fftshift(fft2(sim_s)); 
%
psim_f(:,:,1) = zeros(size(sim_f)); psim_f(:,:,3) = sim_f;
psim_f(nx/2+1:3/2*nx,nx/2+1:3/2*nx,2) = fftshift(ld_f(:,:,4)); psim_f(nx/2+1:3/2*nx,nx/2+1:3/2*nx,4) = fftshift(ld_f(:,:,2));
psim = abs(ifft(ifft(ifft(psim_f,[],1),[],2),[],3));