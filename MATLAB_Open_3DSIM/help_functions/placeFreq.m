function [out] = placeFreq( in )
    siz=size(in);
    w=siz(2);
    h=siz(1);
    out=zeros(2*w,2*h);
    out(h/2+1:h+h/2,w/2+1:w+w/2)=in;
end