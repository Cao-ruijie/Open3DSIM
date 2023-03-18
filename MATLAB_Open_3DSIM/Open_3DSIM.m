%% The main program of Open-3DSIM(MATLAB code)
%
% This program is finished by Caoruijie and professor Xipeng in Peking 
% University. 
%
% For some referrence:
% A. Smith, C.S., Slotman, J.A., Schermelleh, L. et al. Structured illumination
%    microscopy with noise-controlled image reconstructions. Nat Methods 18,
%    821–828 (2021). https://doi.org/10.1038/s41592-021-01167-7
% B. Wen, G., Li, S., Wang, L. et al. High-fidelity structured illumination
%    microscopy by point-spread-function engineering. Light Sci Appl 10, 70
%    (2021). https://doi.org/10.1038/s41377-021-00513-w
% C. Zhanghao, K., Chen, X., Liu, W. et al. Super-resolution imaging of
%    fluorescent dipoles via polarized structured illumination microscopy.
%    Nat Commun 10, 4694 (2019). https://doi.org/10.1038/s41467-019-12681-w
% D. Besson S., Leigh R. et al. Bringing Open Data to Whole Slide Imaging.
%    Digital Pathology ECDP 2019. Lecture Notes in Computer Science 11435(2019).
%    https://link.springer.com/chapter/10.1007/978-3-030-23937-4_1
% E. Cris Luengo (2022). DIPimage (https://github.com/DIPlib/diplib), GitHub.
%    Retrieved December 10, 2022.
%
% For any question, please contact: caoruijie@stu.pku.edu.cn or 
% xipeng@pku.edu.cn
%
% We claim a Apache liscence for Open-3DSIM.

close all;
clc;
clear all;

addpath('.\help_functions\');
addpath('.\lib\bfmatlab\');
addpath('.\lib\diplib\share\DIPimage');
setenv('PATH',['.\lib\diplib\bin',';',getenv('PATH')]);

%% Read data
datasets = '.\input\OMX_Actin_488_1518.tif'; % The input data file (dv/tiff/tif are supported)
output = '.\output\';                     % Output file folder for WF/SIM result
numchannels = 1;                          % Total channels
jchannel = 1;                             % Selected channel
numframes = 1;                            % Total frames
jframe = 1;                               % Selected frame
read_type = 1;                            % 1: OMX-SIM, 2:NSIM, 3:Home-built-SIM
disp('-----------Reading data-----------')
[dataparams,WF,Nx,Ny,Nz,raw_image] = read_data(datasets,output,numchannels,numframes,jchannel,jframe,read_type);

%% Process data
if read_type == 1 
    rawpixelsize = [80 80 125]; % pixel size and focal stack spacing (nm)
    NA = 1.4;                   % objective lens NA
    refmed = 1.47;              % refractive index medium
    refcov = 1.512;             % refractive index cover slip
    refimm = 1.518;             % refractive index immersion medium
    exwavelength = 488;         % excitation wavelengths
    emwavelength = 528;         % emission wavelengths
    fwd = 140e3;                % free working distance from objective to cover slip
    depth = 0;                  % depth of imaged slice from the cover slip
elseif read_type == 2
    rawpixelsize = [65 65 120]; % pixel size and focal stack spacing (nm)
    NA = 1.49;                  % objective lens NA
    refmed = 1.52;              % refractive index medium
    refcov = 1.512;             % refractive index cover slip
    refimm = 1.512;             % refractive index immersion medium
    exwavelength = 488;         % excitation wavelengths
    emwavelength = 525;         % emission wavelengths
    fwd = 120e3;                % free working distance from objective to cover slip (um)
    depth = 0;                  % depth of imaged slice from the cover slip (um)
else
    rawpixelsize = [65 65 125]; % pixel size and focal stack spacing (nm)
    NA = 1.49;                  % objective lens NA
    refmed = 1.47;              % refractive index medium
    refcov = 1.512;             % refractive index cover slip
    refimm = 1.515;             % refractive index immersion medium
    exwavelength = 561;         % excitation wavelengths
    emwavelength = 610;         % emission wavelengths
    fwd = 120e3;                % free working distance from objective to cover slip (um)
    depth = 0;                  % depth of imaged slice from the cover slip (um)
end
notchwidthxy1 = 0.4*Nx/1024;    % notch_width to design Filter
notchdips1 = 0.92;              % notch_depth to design Filter
notchwidthxy2 = 0.5*Ny/1024;    % notch_width to notch
notchdips2 = 0.98;              % notch_depth to notch
OTFflag = 1;                    % if OTFflag == 1,simulated OTF; if OTFfla == 0 ,experimental OTF
OTF_name = '.\input\OTF488.tif';
num_taper = 0;
attenuation = 0;
disp('-----------Processing data-----------')
[dataparams,freq,ang,pha,module,sum_fft] = process_data(dataparams,rawpixelsize,NA,refmed,refcov,refimm,exwavelength,emwavelength,fwd,depth,notchwidthxy1,notchdips1,notchwidthxy2,notchdips2,OTFflag,OTF_name,num_taper,attenuation);

%% Filter
lambdaregul1 = 0.5;           % parameter to constuct Filter1
lambdaregul2 = 0.1;           % parameter to constuct Filter2
disp('-----------Filtering and reconstrcuting-----------')
[final_image] = filter_3D(dataparams,sum_fft,Nx,Ny,Nz,lambdaregul1,lambdaregul2,output);

%% polarized-SIM
calib1_file = '.\input\calib488_1.tif';
calib2_file = '.\input\calib488_2.tif';
calib_type = 1;               % 1-do calibration
disp('-----------pSIMing-----------')
[psim_image] = pSIM(raw_image,final_image,ang,calib1_file,calib2_file,Nz,Nx,Ny,output,calib_type);