function [anneuation] = writeApoVector(dataparams,Mask)

cyclesPerMicron = 1./(dataparams.rawpixelsize*1e-3)./[dataparams.numpixelsx,dataparams.numpixelsy,dataparams.numfocus];

siz = size(dataparams.OTFem);
w=siz(2);
h=siz(1);
t=siz(3);
cnt=siz/2+1;
kx=cnt(2);
ky=cnt(1);
kz=floor(cnt(3));

rad = zeros(w,h);
for jx = 1:w
    for jy = 1:h
        rad(jx,jy) = sqrt( ((jx-kx).*cyclesPerMicron(1))^2+((jy-ky).*cyclesPerMicron(2))^2);
    end
end

kk = dataparams.allpatternpitch(2,1,1,1)/dataparams.allpatternpitch(1,1,1,1);
for jz = 1:t
    for xx = kx:1:w
        yy = floor(kk*(xx-kx)+ky);
        if Mask(xx,yy,jz) == 0
            sampleLateral(jz) = floor(sqrt((xx-kx)^2+(yy-ky)^2))+1;break;
        end
    end
end
sampleLateral = sampleLateral + 5;

for jz = 1:t
    va1 = zeros(1,sampleLateral(jz));
    va2 = zeros(1,sampleLateral(jz));
    for i = 1:sampleLateral(jz)
        dist1 = abs(i-1)/sampleLateral(jz);
        dist2 = abs(i-1)*cyclesPerMicron(1);
        va1(i)=(1/pi)*(2*acos(dist1)-sin(2*acos(dist1)));
        fwhm = 1;
        str = 0.9;
        va2(i)=(1-str*(exp(-power(dist2,2)/(power(0.5*fwhm,3)))).^1);
        va2(i)=va2(i)*va1(i);
    end
    va11(jz,1:sampleLateral(jz)) = va1;
    va22(jz,1:sampleLateral(jz)) = va2;
end



val = zeros(w,h,t);
for jz = 1:t
    mask = zeros(w,h);
    for ii = 1:w
        for jj = 1:h
            if (ii-kx)^2+(jj-ky)^2<=sampleLateral(jz)^2
                mask(ii,jj) = 1;
            end
        end
    end
    rad1 = rad.*mask;

    pos = rad1./cyclesPerMicron(1);
    cpos= pos+1;
    lpos=floor(cpos);
    hpos=ceil(cpos);
    f=cpos-lpos;
        val1_temp = va11(jz,:);
        val1_temp(find(val1_temp==0))=[];
        val1_temp = [val1_temp,0,0];
        retl=val1_temp(lpos).*(1-f);
        reth=val1_temp(hpos).*f;

    val(:,:,jz)=retl+reth;
    val(:,:,jz)=val(:,:,jz).*mask;
end

anneuation = val;
end