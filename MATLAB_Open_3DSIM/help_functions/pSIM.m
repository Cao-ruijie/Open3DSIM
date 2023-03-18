function [pSIM] = pSIM(raw_data,sim_data,theta0,calib1_file,calib2_file,Nz,Nx,Ny,output,calib_type)

raw_data = uint16(1500*double(raw_data)./double(max(max(max(max(max(max(max(raw_data)))))))));
sim_data = uint16(1500*double(sim_data)./double(max(max(max(sim_data)))));

%% Prepare Data
fov = Nx/2;
theta = [-theta0(1,1,1,1),-180-theta0(1,1,1,2),-180-theta0(1,1,1,3)]./180.*pi;
switch calib_type
    case 1
        calib1 = double(imread(calib1_file))/10000; calib2 = double(imread(calib2_file))/10000;
        size_cab = size(calib1,1)/2;
        calib{1} = calib1((size_cab+1-fov/2):(size_cab+fov/2),(size_cab+1-fov/2):(size_cab+fov/2));
        calib{2} = calib2((size_cab+1-fov/2):(size_cab+fov/2),(size_cab+1-fov/2):(size_cab+fov/2));
    otherwise
        calib{1} = ones(fov,fov); calib{2} = ones(fov,fov);
end

%% iter
pSIM = zeros(2*fov,2*fov,3,Nz);
for jNz = 1 : Nz
    raw_sim = zeros([fov,fov,15]);
    for mm = 1 : 5
        raw_sim(:,:,mm) = squeeze(raw_data(:,:,mm,jNz,1,1,1));
        raw_sim(:,:,mm+5) = squeeze(raw_data(:,:,mm,jNz,1,1,2));
        raw_sim(:,:,mm+10) = squeeze(raw_data(:,:,mm,jNz,1,1,3));
    end
    %
    sim_s = squeeze(sim_data(:,:,jNz));
    % recon_file
    [ld, psim] = psim_sim3d_recon(raw_sim*0.1, sim_s, theta, calib);
    %
    [wf, ld_om, cm, ouf, ~] = om_display(ld, 100, 400, false);
    [sim, psim_om, ~] = om_display(psim,0,max(psim(:)), false);
    %
    pSIM(:,:,:,jNz) = uint8(psim_om*255./max(max(psim_om)));
    % imwrite(uint8(psim_om*255./max(max(psim_om))), [output 'psim3D\psim_t_',  '_z_', num2str(jNz,'%.3d'), '.png'])
end

%% Save data
max_index = zeros(1,Nz);
for jNz = 1:Nz
    max_index(1,jNz) = max(max(sim_data(:,:,jNz)));
end
max_index = max_index./max(max_index);
for jNz = 1:Nz
    pSIM(:,:,:,jNz) = pSIM(:,:,:,jNz).*max_index(1,jNz);
end
stackfilename = [output ,'pSIM.tif'];
for k = 1:Nz
    imwrite(uint8(pSIM(:,:,:,k)), stackfilename, 'WriteMode','append') % 写入stack图像
end
imwrite(uint8(cm*255),[output 'cm.png'])

end