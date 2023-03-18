function [ ret] = getPeak( band0,band1,bn0,bn1,otf,kx,ky,weightLimit )
    b0=band0;
    b1=band1;
    dist=0.15;
    [b0,b1]=commonRegion(band0,band1,bn0,bn1,otf,kx,ky,dist,weightLimit,true);

    b0=FFT2D(b0,true);
    b1=FFT2D(b1,true);

    if bn0~=1
        b0=fourierShift(b0,kx,ky);
        b1=fourierShift(b1,kx*2,ky*2);
    else
        b1=fourierShift(b1,kx,ky);
    end

    b1=b1.*conj(b0);

    scal=1/sum(sum(real(b0).^2+imag(b0).^2));
    ret=sum(sum(b1))*scal;
end

