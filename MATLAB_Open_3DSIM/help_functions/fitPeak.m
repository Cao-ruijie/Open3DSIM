function [ peak ,cntrl] = fitPeak( band0, band1, bn0, bn1, otf, kx, ky, weightLimit, search, cntrl)
    resPhase=0;
    resMag=0;
    for iter=1:3
        b0=band0;
        b1=band1;
        dist=0.15;
        divideByOtf=true;
        [b0,b1]=commonRegion(b0,b1,bn0,bn1,otf,kx,ky,dist,weightLimit,divideByOtf);

        b0=FFT2D(b0,true);
        b1=FFT2D(b1,true);

        corr=zeros(10,10);
        scal=1/sum(sum(real(b0).^2+imag(b0).^2));
        cmax=0;
        cmin=inf;
        newKx=0;
        newKy=0;

        tkx=kx;
        tky=ky;
        ts=search;
        for yi=1:10
            for xi=1:10

                xpos=tkx+(((xi-1)-4.5)/4.5)*ts;
                ypos=tky+(((yi-1)-4.5)/4.5)*ts;

                b1s=b1;
                b1s=fourierShift(b1,xpos,ypos);

                b1s=b1s.*conj(b0);
                corr(xi,yi)=sum(sum(b1s))*scal;
            end
        end

        for yi=1:10
            for xi=1:10
                if abs(corr(xi,yi))>cmax
                    cmax=abs(corr(xi,yi));
                    newKx=tkx+(((xi-1)-4.5)/4.5)*ts;
                    newKy=tky+(((yi-1)-4.5)/4.5)*ts;
                    resPhase=angle(corr(xi,yi));
                    resMag=abs(corr(xi,yi));
                end

                if abs(corr(xi,yi)<cmin)
                    cmin=abs(corr(xi,yi));
                end
            end
        end

        if ~isempty(cntrl)
            for yi=1:10
                for xi=1:10
                    cntrl(yi,xi+(iter-1)*10)=(abs(corr(xi,yi))-cmin)/(cmax-cmin);
                end
            end
        end

        kx=newKx;
        ky=newKy;

        search=search/3;
    end

    peak.kx=kx;
    peak.ky=ky;
    peak.resPhase=resPhase;
    peak.resMag=resMag;
end

