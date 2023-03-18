function [ otfAtt ] = getotfAtt( imgSize,cyclesPerMicron,attfwhm,kx,ky )
    w=imgSize;
    h=imgSize;
    siz=[h w];
    cnt=siz/2+1;
    kx=kx+cnt(2);
    ky=ky+cnt(1);
    otfAtt=zeros(h,w);

    y=1:h;
    x=1:w;
    [x,y]=meshgrid(x,y);
    rad=hypot(y-ky,x-kx);
    cycl=rad.*cyclesPerMicron;
    otfAtt=valAttenuation(cycl,attfwhm);

end

function [va]= valAttenuation(dist,fwhm)
    va=(1-exp(-power(dist,4)/(2*power(fwhm,4))));
end

