function anneuation = applyOtf(OTFex,dataparams,cutoffxy,cutoffz,flag)
siz = size(OTFex);
w=siz(2);
h=siz(1);
t=siz(3);
cnt=siz/2+1;
kx=cnt(2);
ky=cnt(1);
kz=floor(cnt(3));
x=1:w;
y=1:h;
z=1:t;
[x,y,z]=meshgrid(x,y,z);
rad = zeros(w,h,t);
cyclesPerMicron = 1./(dataparams.rawpixelsize*1e-3)./[dataparams.numpixelsx,dataparams.numpixelsy,dataparams.numfocus];
sampleLateral = ceil([cutoffxy,cutoffxy,cutoffz]./cyclesPerMicron)+1;
va1 = zeros(1,sampleLateral(1));
va2 = zeros(1,sampleLateral(1));
for i = 1:sampleLateral(1)
    dist1 = abs(i-1)/sampleLateral(1);
    dist2 = abs(i-1)*cyclesPerMicron(1);
    va1(i)=(1/pi)*(2*acos(dist1)-sin(2*acos(dist1)));
    fwhm = 1;
    str = 0.9;
    va2(i)=(1-str*(exp(-power(dist2,2)/(power(0.5*fwhm,2)))).^1);
    va2(i)=va2(i)*va1(i);
end
for jz = 1:t
    for jx = 1:w
        for jy = 1:h
            rad(jx,jy,jz) = sqrt( ((jx-kx).*cyclesPerMicron(1))^2+((jy-ky).*cyclesPerMicron(2))^2+((jz-kz).*cyclesPerMicron(3))^2 );
        end
    end
end

rad1 = rad.*dataparams.Mask;

val = zeros(w,h,t);
for jz = 1:t
    pos = rad1(:,:,jz)./cyclesPerMicron(1);
    cpos= pos+1;
    lpos=floor(cpos);
    hpos=ceil(cpos);
    f=cpos-lpos;
    if flag == 0
        retl=va1(lpos).*(1-f);
        reth=va1(hpos).*f;
    else
        retl=va2(lpos).*(1-f);
        reth=va2(hpos).*f;
    end
    val(:,:,jz)=retl+reth;
end

val = val.*dataparams.Mask;
anneuation = val;

end