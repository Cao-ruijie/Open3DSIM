function [out] = importImages_process(images,num_taper)
    N=size(images,3);
    L=size(images,1);
    for I=1:N
        curImg=images(:,:,I);
        curImg=fadeBorderCos(curImg,num_taper);
        images(:,:,I)=curImg;
    end
    out=images;
end

function [ out ] = fadeBorderCos( img, px )
    [h,w]=size(img);
    fac=1/px*pi/2;
    dat=img;
    %top
    for y=1:px
        for x=1:w
            dat(y,x)=dat(y,x)*power(sin((y-1)*fac),2);
        end
    end
    %bottom
    for y=h-px+1:h
        for x=1:w
            dat(y,x)=dat(y,x)*power(sin((h-y)*fac),2);
        end
    end
    % left
    for y=1:h
        for x=1:px
            dat(y,x)=dat(y,x)*power(sin((x-1)*fac),2);
        end
    end
    %right
    for y=1:h
        for x=w-px+1:w
            dat(y,x)=dat(y,x)*power(sin((w-x)*fac),2);
        end
    end
    out=dat;
end