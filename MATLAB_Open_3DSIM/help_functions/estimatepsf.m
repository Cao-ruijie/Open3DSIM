function psf = estimatepsf(dataparams)
numangles = dataparams.numangles;
numchannels = dataparams.numchannels;
numframes = dataparams.numframes;
numsteps = dataparams.numsteps;
numpixelsx = dataparams.numpixelsx;
numpixelsy = dataparams.numpixelsy;
emwavelength = dataparams.exwavelength;
NA = dataparams.NA;
lambda = dataparams.emwavelength;
nrBands = dataparams.nrBands;
cyclesPerMicron = 1/(dataparams.numpixelsx*dataparams.rawpixelsize(1)*1e-3);

%% 大致的OTF
OtfProvider = SimOtfProvider(dataparams,NA,lambda,cyclesPerMicron,1);
psf=abs(otf2psf((OtfProvider.otf)));
end