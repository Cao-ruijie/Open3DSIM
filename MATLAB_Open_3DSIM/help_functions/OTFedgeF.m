function [Mask] = OTFedgeF(OTFex)
[numpixelsx,numpixelsy,numfocus] = size(OTFex);
Mask = zeros(numpixelsx,numpixelsy,numfocus);
max_OTF = max(max(max(OTFex)));
OTFtruncate = 0.006;
for jx = 1:numpixelsx
    for jy = 1:numpixelsy
        for jz = 1:numfocus
            if abs(OTFex(jx,jy,jz))>OTFtruncate*max_OTF
                Mask(jx,jy,jz) = 1;
            end
        end
    end
end
end