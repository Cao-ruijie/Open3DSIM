function [ ret ] = SimOtfProvider(dataparams,NA,lambda,cyclesPerMicron,a)
    ret.na=NA;
    ret.lambda=lambda;

    ret.cutoff=1000/(0.5*lambda/NA);
%     disp(ret.cutoff);
    ret.imgSize=dataparams.numpixelsx;
    ret.cyclesPerMicron=cyclesPerMicron;
%     disp(ret.cyclesPerMicron);
    ret.sampleLateral=ceil(ret.cutoff/ret.cyclesPerMicron)+1;

    ret.estimateAValue=a;
    ret.maxBand=2;
    ret.attStrength=dataparams.attStrength;
    ret.attFWHM=1.0;
    ret.useAttenuation=1;

    ret=fromEstimate(ret);
    
    ret.otf=zeros(dataparams.numpixelsx,dataparams.numpixelsx);
    ret.otfatt=zeros(dataparams.numpixelsx,dataparams.numpixelsx);
    ret.onlyatt=zeros(dataparams.numpixelsx,dataparams.numpixelsx);

    ret.otf=writeOtfVector(ret.otf,ret,1,0,0);
    ret.onlyatt=getonlyatt(ret,0,0);
    ret.otfatt=ret.otf.*ret.onlyatt;
end

function [va]=valIdealOTF(dist)
    if dist<0 || dist>1
        va=0;
        return;
    end
    va=(1/pi)*(2*acos(dist)-sin(2*acos(dist)));
end

function [va]= valAttenuation(dist,str,fwhm)
    va=(1-str*(exp(-power(dist,2)/(power(0.5*fwhm,2)))).^1);
end

function [ret] = fromEstimate(ret)
    ret.isMultiband=0;
    ret.isEstimate=1;
    vals1=zeros(1,ret.sampleLateral);
    valsAtt=zeros(1,ret.sampleLateral);
    valsOnlyAtt=zeros(1,ret.sampleLateral);


    for I=1:ret.sampleLateral
        v=abs(I-1)/ret.sampleLateral;
        r1=valIdealOTF(v)*power(ret.estimateAValue,v);
        vals1(I)=r1;
    end

    for I=1:ret.sampleLateral
        dist=abs(I-1)*ret.cyclesPerMicron;
        valsOnlyAtt(I)=valAttenuation(dist,ret.attStrength,ret.attFWHM);
        valsAtt(I)=vals1(I)*valsOnlyAtt(I);
    end

    ret.vals=vals1;

    ret.valsAtt=valsAtt;
    ret.valsOnlyAtt=valsOnlyAtt;

end

function [ onlyatt ] = getonlyatt( ret,kx,ky )
    w=ret.imgSize;
    h=ret.imgSize;
    siz=[h w];
    cnt=siz/2+1;
    kx=kx+cnt(2);
    ky=ky+cnt(1);
    onlyatt=zeros(h,w);

    y=1:h;
    x=1:w;
    [x,y]=meshgrid(x,y);
    rad=hypot(y-ky,x-kx);
    cycl=rad.*ret.cyclesPerMicron;
    onlyatt=valAttenuation(cycl,ret.attStrength,ret.attFWHM);

end


