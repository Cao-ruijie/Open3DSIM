function Wk11 = notchfiltercenter(Wk1,dataparams)

siz = size(dataparams.OTFem);
w=siz(2);
h=siz(1);
t=siz(3);
cnt=siz/2+1;
kx=cnt(2);
ky=cnt(1);
kz=floor(cnt(3));
x=1:w;
y=1:h;
[x,y]=meshgrid(x,y);

patternpitch = dataparams.allpatternpitch(:,1,1,1);
sampleLateral = floor(sqrt(sum(patternpitch.^2))/8);


va1 = ones(1,dataparams.numpixelsx*2);
for i = 1:sampleLateral
    dist1 = abs(i-1)/sampleLateral;
    va1(i)=(1/pi)*(2*acos(dist1)-sin(2*acos(dist1)));
end
va1(1:sampleLateral) = (2-va1(1:sampleLateral))/2;

rad=hypot(y-ky,x-kx);
lpos=uint16(floor(rad))+1;
notchfilter = va1(lpos);
Wk11 = Wk1;
Wk11(:,:,kz) = Wk1(:,:,kz).*notchfilter;

end