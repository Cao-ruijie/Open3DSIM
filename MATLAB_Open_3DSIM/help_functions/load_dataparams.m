function [dataparams] = load_dataparams()

%% 文件路径
dataparams.datasets = {'Argolight_E1_488_001.dv'};
dataparams.rootdir = 'E:\MATLAB_2\3D_SIM_2\Data\';
dataparams.outputdatadir = strcat(dataparams.rootdir,dataparams.datasets);

%% 采集参数
dataparams.numangles = 3;   % 角度
dataparams.numsteps = 5;    % 相位
dataparams.numchannels = 1; % 颜色
dataparams.numframes = 1;   % 帧
dataparams.nrBands = 3;

dataparams.xemit = 0;  % x-position focal point
dataparams.yemit = 0;  % y-position focal point 
dataparams.zemit = 0;  % z-position focal point 

%% 物理参数(针对OMX系统)
dataparams.rawpixelsize = [82 82 125]; % pixel size and focal stack spacing (nm)
dataparams.NA = 1.4;                   % objective lens NA
dataparams.refmed = 1.47;              % refractive index medium
dataparams.refcov = 1.512;             % refractive index cover slip
dataparams.refimm = 1.512;             % refractive index immersion medium
dataparams.exwavelength = 488;         % excitation wavelengths 
dataparams.emwavelength = 525;         % emission wavelengths
dataparams.fwd = 140e3;                % free working distance from objective to cover slip
dataparams.depth = 0;                  % depth of imaged slice from the cover slip 

%% 滤波器参数
dataparams.attStrength = 0;
dataparams.patternphases_init = 2*pi*(1-(0:(5-1))/5); % initial value pattern phases in phase estimation % initial value pattern phases in phase estimation
dataparams.maxorder = 3;
end