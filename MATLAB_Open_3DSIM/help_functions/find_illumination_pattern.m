function [dataparams,psf] = find_illumination_pattern(Snoisy,dataparams)

%% Basic parameter
numangles = dataparams.numangles;
numsteps = dataparams.numsteps;
numpixelsx = dataparams.numpixelsx;
numpixelsy = dataparams.numpixelsy;
NA = dataparams.NA;
lambda = dataparams.emwavelength;
nrBands = dataparams.nrBands;
cyclesPerMicron = double(1./(dataparams.numpixelsx*dataparams.rawpixelsize(1)*0.001));

%% Calculate OTF
OtfProvider = SimOtfProvider(dataparams,NA,lambda,cyclesPerMicron,1);
psf=abs(otf2psf((OtfProvider.otf)));

%% Deconvlucy and FFT of raw images
Temp=importImages(Snoisy);
IIraw=deconvlucy(Temp,psf,5);
IIrawFFT = zeros(numpixelsx,numpixelsy,numsteps*numangles);
for I=1:numangles*numsteps
    IIrawFFT(:,:,I)=FFT2D(IIraw(:,:,I),false);
end

%% Cutoff and notchfilter
cnt=[numpixelsx/2+1,numpixelsx/2+1];
cutoff=1000/(0.5*lambda/NA);
[x,y]=meshgrid(1:numpixelsx,1:numpixelsy);
rad=sqrt((y-cnt(1)).^2+(x-cnt(2)).^2);
Mask1=double(rad<=1.0*(cutoff/cyclesPerMicron+1));
NotchFilter0=getotfAtt(numpixelsx,cyclesPerMicron,0.5*cutoff,0,0);
NotchFilter1=NotchFilter0.*Mask1;
Mask2=double(rad<=1.10*(cutoff/cyclesPerMicron+1));
NotchFilter2=NotchFilter0.*Mask2;

%% Cross-correlation to solve illumination pattern
CrossCorrelation=zeros(size(Mask2,1),size(Mask2,2),numangles);
k0=zeros(1,numangles);
for I=1:numangles
    lb = 2;
    hb = 4;
    fb = hb;
    phaOff=0;
    fac = ones(1,nrBands);
    separateII = separateBandshifi(IIrawFFT(:,:,(I-1)*numsteps+1:I*numsteps),phaOff,nrBands,fac);
    SeparateII{1,I} = separateII;
    
    c0 = separateII(:,:,1);
    c3 = separateII(:,:,hb);
    c0 = c0./(max(max(abs(separateII(:,:,1))))).*NotchFilter1;
    c3 = c3./(max(max(abs(separateII(:,:,hb))))).*NotchFilter1;
    c0 = FFT2D(c0,false);
    c3 = FFT2D(c3,false);
    c3 = c3.*conj(c0);
    c3 = c3./max(max(c3));
    vec = fftshift(FFT2D(c3,true));
    CrossCorrelation(:,:,I) = vec;
    temp = vec.*NotchFilter2;
    temp = log(1+abs(temp));
    temp = temp./max(max(temp));
    [yPos,xPos] = find(temp==max(max(temp)));
    peak.xPos = xPos(1);
    peak.yPos = yPos(1);
    k0(I) = sqrt((peak.xPos-cnt(1))^2+(peak.yPos-cnt(2))^2);
end

for I = 1:dataparams.numangles
    vec = CrossCorrelation(:,:,I);
    temp = vec.*NotchFilter2;
    temp = log(1+abs(temp));
    temp = temp./max(max(temp));
    
    [yPos,xPos] = find(temp==max(max(temp)));
    peak.xPos = xPos(1);
    peak.yPos = yPos(1);
    
    cntrl = zeros(10,30);
    overlap = 0.15;
    step = 2.5;
    bn1 = (nrBands-1)*2;
    kx = (peak.xPos-cnt(2));
    ky = (peak.yPos-cnt(1));
    
    separateII = SeparateII{1,I};
    [peak,~] = fitPeak(separateII(:,:,1)/(max(max(abs(separateII(:,:,1))))),separateII(:,:,fb)/(max(max(abs(separateII(:,:,fb))))),1,bn1,OtfProvider,-kx,-ky,overlap,step,cntrl);
    
    p1 = getPeak(separateII(:,:,1),separateII(:,:,lb),0,1,OtfProvider,peak.kx/2,peak.ky/2,overlap);
    p2 = getPeak(separateII(:,:,1)/(max(max(abs(separateII(:,:,1))))),separateII(:,:,hb)/(max(max(abs(separateII(:,:,1))))),0,2,OtfProvider,peak.kx,peak.ky,overlap);
    
    params.Dir(I).px = -peak.kx/2;
    params.Dir(I).py = -peak.ky/2;
    params.Dir(I).phaOff=-angle(p1);
    
    Temp_m1 = abs(p1);
    Temp_m2 = abs(p2);
    
    Temp_m1(Temp_m1>1.0) = 1.0;
    Temp_m2(Temp_m2>1.0) = 1.0;
    params.Dir(I).modul(1) = Temp_m1;
    params.Dir(I).modul(2) = Temp_m2;
end

%% Save the results
for jangle = 1:numangles
    dataparams.allpatternpitch(:,1,1,jangle) = [params.Dir(jangle).px,params.Dir(jangle).py];
    dataparams.allpatternangle(:,1,1,jangle) = atan(params.Dir(jangle).py/params.Dir(jangle).px)*180/pi;
    dataparams.allpatternphases(:,1,1,jangle) = params.Dir(jangle).phaOff + [0 2*pi/5 4*pi/5 6*pi/5 8*pi/5];
    dataparams.allmodule(:,1,1,jangle) = [1 params.Dir(jangle).modul(1) params.Dir(jangle).modul(1) params.Dir(jangle).modul(2) params.Dir(jangle).modul(2)];
end

end