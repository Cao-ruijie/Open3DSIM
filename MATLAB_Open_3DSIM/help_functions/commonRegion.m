function [ newb0,newb1 ] = commonRegion( band0, band1, bn0, bn1, otf, kx, ky, dist,weightLimit, divideByOtf)
    siz=size(band0);
    w=siz(2);
    h=siz(1);
    cnt=[siz(1)/2+1,siz(2)/2+1];

    weight0=zeros(h,w);
    weight1=zeros(h,w);
    wt0=zeros(h,w);
    wt1=zeros(h,w);

    if bn0==1
        weight0=writeOtfVector(weight0,otf,bn0,0,0);
        weight1=writeOtfVector(weight1,otf,bn1,0,0);
    else
        weight0=writeOtfVector(weight0,otf,bn0,0,0);
        weight1=writeOtfVector(weight1,otf,bn1,0,0);
    end
    wt0=writeOtfVector(wt0,otf,bn0,kx,ky);
    wt1=writeOtfVector(wt1,otf,bn1,-kx,-ky);


    x=1:w;
    y=1:h;
    [x,y]=meshgrid(x,y);
    rad=sqrt((y-cnt(1)).^2+(x-cnt(2)).^2);
    max=sqrt(kx*kx+ky*ky);
    ratio=rad./max;

    mask1=(abs(weight0)<weightLimit) | (abs(wt0)<weightLimit);
    cutCount=length(find(mask1~=0));
    band0(mask1)=0;

    mask2=abs(weight1)<weightLimit | abs(wt1)<weightLimit;
    band1(mask2)=0;

    weight0(weight0==0)=1;
    weight1(weight1==0)=1;
    wt0(wt0==0)=1;
    wt1(wt1==0)=1;

    if divideByOtf==true
        band0=band0./weight0;
        band1=band1./weight1;
    end


    mask=ratio<dist | ratio>(1-dist);
    band0(mask)=0;

    idx = repmat({':'}, ndims(mask), 1); 
    n = size(mask, 1 ); 
    if kx>0
        idx{2}=[round(kx)+1:n 1:round(kx)];
    else
        idx{2}=[n-round(abs(kx))+1:n 1:n-round(abs(kx))];
    end
    if ky>0
        idx{1}=[round(ky)+1:n 1:round(ky)];
    else
        idx{1}=[n-round(abs(ky))+1:n 1:n-round(abs(ky))];
    end
    mask0=mask(idx{:});
    band1(mask0)=0;

    newb0=band0;
    newb1=band1;
end

