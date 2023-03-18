function [dataparams,freq,ang,pha,module0,sum_fft] = process_data(dataparams,rawpixelsize,NA,refmed,refcov,refimm,exwavelength,emwavelength,fwd,depth,notchwidthxy1,notchdips1,notchwidthxy2,notchdips2,OTFflag,OTF_name,num_taper,attenuation)

%% Get some parameter
dataparams.rawpixelsize = rawpixelsize;
dataparams.NA = NA;
dataparams.refmed = refmed;
dataparams.refcov = refcov;
dataparams.refimm = refimm;
dataparams.exwavelength = exwavelength;
dataparams.emwavelength = emwavelength;
dataparams.fwd = fwd;
dataparams.depth = depth;
dataparams.xemit = 0;        % x-position focal point
dataparams.yemit = 0;        % y-position focal point
dataparams.zemit = 0;        % z-position focal point
dataparams.attStrength = 0;
dataparams.nrBands = 3;
dataparams.maxorder = 3;
[numpixelsx,numpixelsy,numsteps,numfocus,numchannels,numframes,numangles] = size(dataparams.allimages_in);
% Below are the parameter to design the notchfilter, we have selected a
% proper value which fits most samples. But for better reconstruction,
% you can change them.
dataparams.notchwidthxy1 = notchwidthxy1;
dataparams.notchdips1 = notchdips1;
dataparams.notchwidthxy2 = notchwidthxy2;
dataparams.notchdips2 = notchdips2;

%% Compute MCNR for every z-slice
[MCNR_ims,~] = do_modulationcheck(dataparams.allimages_in);
mcnrprct = 7.5;
averageMCNR_foreground_top = zeros(numfocus,numchannels,numframes);
for jfocus = 1:numfocus
    MCNRslice = squeeze(MCNR_ims(:,:,jfocus,1,1));
    MCNRhivals = prctile(MCNRslice(:),[100-mcnrprct 100]);
    averageMCNR_foreground_top(jfocus,1,1) = mean(MCNRhivals);
end
clear MCNRhivals MCNRhivals MCNR_ims

%% Average every slice based on MCNR
MCNR = averageMCNR_foreground_top(:,1,1);
MCNR = MCNR./max(MCNR);
for jMCNR = 1:size(MCNR)
    if MCNR(jMCNR)<0.90
        MCNR(jMCNR)=0;
    end
end
for jangle = 1:numangles
    tempimage = squeeze(dataparams.allimages_in(:,:,:,:,1,1,jangle));
    tempimage = weightCNR(tempimage,MCNR);
    Snoisy(:,:,(jangle-1)*5+1:(jangle-1)*5+5) = tempimage;
end

%%%%%%%%%%%%%%%%%%%%%
% maxnum = max(max(max(Snoisy)));
% Snoisy = Snoisy./maxnum;
% stackfilename = ['Snoisy.tif'];
% for k = 1:15
%     imwrite(Snoisy(:,:,k), stackfilename, 'WriteMode','append') % Ð´ÈëstackÍ¼Ïñ
% end
%%%%%%%%%%%%%%%%%%%%%
%% Get the frequency, phase and modulation depth
[dataparams,~] = find_illumination_pattern(Snoisy,dataparams);
freq = dataparams.allpatternpitch;
ang = dataparams.allpatternangle;
pha = dataparams.allpatternphases;
evaluate_freq1 = [sqrt(freq(1,1,1,1)^2+freq(2,1,1,1)^2),sqrt(freq(1,1,1,2)^2+freq(2,1,1,2)^2),sqrt(freq(1,1,1,3)^2+freq(2,1,1,3)^2)];
evaluate_freq_std1 = std(evaluate_freq1,1);
evaluate_ang1 = [mod(ang(1,1,1,1)-ang(1,1,1,2),180),mod(ang(1,1,1,2)-ang(1,1,1,3),180),mod(ang(1,1,1,3)-ang(1,1,1,1),180)];
evaluate_ang_std1 = std(evaluate_ang1,1);
if evaluate_freq_std1>0.5||evaluate_ang_std1>5
    [dataparams,~] = find_illumination_pattern2(Snoisy,dataparams);
    freq = dataparams.allpatternpitch;
    ang = dataparams.allpatternangle;
    pha = dataparams.allpatternphases;
end

module0 = [dataparams.allmodule(2,1,1,1),dataparams.allmodule(4,1,1,1),...
    dataparams.allmodule(2,1,1,2),dataparams.allmodule(4,1,1,2),...
    dataparams.allmodule(2,1,1,3),dataparams.allmodule(4,1,1,3),];
clear Snoisy tempimage
allmodule = [0 0 0 0 0];
for jangle = 1:numangles
    allmodule = allmodule + dataparams.allmodule(:,1,1,jangle)'/numangles;
end

disp(['    parameter of dir1 is: freq=',num2str(sqrt(freq(1,1,1,1)^2+freq(2,1,1,1)^2)),', ang=',num2str(ang(1,1,1,1)),', pha=',num2str(pha(1,1,1,1)),', module1=',num2str(dataparams.allmodule(2,1,1,1)),', module2=',num2str(dataparams.allmodule(4,1,1,1))]);
disp(['    parameter of dir2 is: freq=',num2str(sqrt(freq(1,1,1,2)^2+freq(2,1,1,2)^2)),', ang=',num2str(ang(1,1,1,2)),', pha=',num2str(pha(1,1,1,2)),', module1=',num2str(dataparams.allmodule(2,1,1,2)),', module2=',num2str(dataparams.allmodule(4,1,1,2))]);
disp(['    parameter of dir3 is: freq=',num2str(sqrt(freq(1,1,1,3)^2+freq(2,1,1,3)^2)),', ang=',num2str(ang(1,1,1,3)),', pha=',num2str(pha(1,1,1,3)),', module1=',num2str(dataparams.allmodule(2,1,1,3)),', module2=',num2str(dataparams.allmodule(4,1,1,3))]);

if allmodule(2)<0.2
    allmodule(2) = 0.2;
    allmodule(3) = 0.2;
end
if allmodule(4)<0.3
    allmodule(4) = 0.3;
    allmodule(5) = 0.3;
end
dataparams.allmoduleave = allmodule;
clear allmodule

%% Get OTFem
SIMparams.upsampling = [2 2 1];                     % interperation
numSIMpixelsx = SIMparams.upsampling(1)*numpixelsx; % X pixels of final SIM image
numSIMpixelsy = SIMparams.upsampling(2)*numpixelsy; % y pixels of final SIM image
numSIMpixelsz = SIMparams.upsampling(3)*numfocus; % #focus layers final SIM image
SIMpixelsize = dataparams.rawpixelsize./SIMparams.upsampling; % pixel size and axial spacing final SIM image
dataparams.SIMpixelsize = SIMpixelsize;
SIMparams.SIMpixelsize = SIMpixelsize;
SIMparams.numSIMpixelsx = numSIMpixelsx;
SIMparams.numSIMpixelsy = numSIMpixelsy;
SIMparams.numSIMpixelsz = numSIMpixelsz;
if OTFflag == 1
    [OTFem,~] = get_modelOTF(dataparams,SIMparams);
elseif OTFflag == 0
    [~,OTFem]= get_calibrationOTF(OTF_name,SIMparams,numpixelsx,numpixelsy,dataparams.rawpixelsize);
end
dataparams.OTFem = OTFem;

%% edge taper
if num_taper~=0
    psf = estimatepsf(dataparams);
    dataparams = preprocess(dataparams,psf,num_taper);
end

%% Unsample the frequency domain
disp("    Unsampling.........")
allftorderims_up = zeros(numSIMpixelsx,numSIMpixelsy,numsteps,numSIMpixelsz,numchannels,numframes,numangles);
for jangle = 1:numangles
    dataparams.allpatternpitch(:,1,1,jangle) = dataparams.allpatternpitch(:,1,1,jangle).*SIMparams.upsampling(1);
    for jstep = 1:numsteps
        allftorderims = reshape(dataparams.allimages_in(:,:,jstep,:,1,1,jangle),[numpixelsx numpixelsy numfocus]);
        fttempimage_ups = do_upsample(allftorderims,SIMparams.upsampling);
        allftorderims_up(:,:,jstep,:,1,1,jangle) = fttempimage_ups;
    end
end

clear fttempimage_ups_add fttempimage_ups tempimage_ups tempimage
dataparams.allimages_in = [];

%% Calculate average shift pixel
average_pitch = 0;
for jangle = 1:numangles
    patternpitch = dataparams.allpatternpitch(:,1,1,jangle);
    average_pitch = average_pitch + sqrt(sum((patternpitch/2).^2))/3;
end

%% Frequency domain seperation
disp("    Seperation.........")
fttempimage = zeros(2*numpixelsx,2*numpixelsy,numsteps,numSIMpixelsz);
allftorderims = zeros(2*numpixelsx,2*numpixelsy,numsteps,numSIMpixelsz,numchannels,numframes,numangles);
for jangle = 1:numangles
    for jstep = 1:numsteps
        fttempimage(:,:,jstep,:) = allftorderims_up(:,:,jstep,:,1,1,jangle);
    end
    patternphases = dataparams.allpatternphases(:,1,1,jangle);
    patternpitch = dataparams.allpatternpitch(:,1,1,jangle)/2;
    module = dataparams.allmoduleave;
    ftorderims = get_orders(fttempimage,patternphases,module,numsteps,patternpitch,jangle);
    allftorderims(:,:,:,:,1,1,jangle) = ftorderims;
end

dataparams.allftorderims = allftorderims;
clear  allftorderims fttempimage allftorderims_up

%% Frequency domain and OTF shifting
disp("    Shifting.........")
OTFshiftfinal1 = zeros(2*numpixelsx,2*numpixelsy,numfocus);
OTFshift1 = zeros(2*numpixelsx,2*numpixelsy,numfocus);
for jangle = 1:numangles
    tempimage = dataparams.allftorderims(:,:,:,:,1,1,jangle);
    patternpitch = dataparams.allpatternpitch(:,1,1,jangle);
    [originfft,OTFshift1(:,:,:,jangle)] = doshift(OTFem,tempimage,patternpitch,dataparams,average_pitch);
    dataparams.originfft(:,:,:,:,1,1,jangle) = originfft;
end
clear  tempimage
dataparams.allftorderims = [];

%% Get sum of OTF*notch
for jangle = 1:numangles
    OTFshiftfinal1 = OTFshiftfinal1 + OTFshift1(:,:,:,jangle);
end
dataparams.OTFshiftfinal = OTFshiftfinal1;

%% Notch filter of frequency domain
disp("    Notching.........")
[Nx,Ny,numsteps,numfocus,numchannels,numframes,numangles] = size(dataparams.originfft);
fftimagefirst = zeros(Nx,Ny,numsteps,numfocus,numchannels,numframes,numangles);
for jangle = 1:numangles
    patternpitch = 1.0*dataparams.allpatternpitch(:,1,1,jangle);
    fftimagefirst(:,:,:,:,1,1,jangle) = notchfilter(dataparams.originfft(:,:,:,:,1,1,jangle),patternpitch,dataparams,attenuation,average_pitch);
end

%% Sum of 0,¡À1,¡À2 frequency domain
sum_fft = zeros(Nx,Ny,numfocus);
for jangle = 1:numangles
    for jstep = 1:numsteps
        sum_fft = sum_fft + squeeze(fftimagefirst(:,:,jstep,:,1,1,jangle));
    end
end

end