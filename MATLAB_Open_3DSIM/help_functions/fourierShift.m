function [ comshift ] = fourierShift( vec, kx, ky  )
    siz=size(vec);
    [x,y]=meshgrid(0:siz(2)-1,0:siz(1)-1);
    x=x/siz(2);
    y=y/siz(1);
    comshift=vec.*exp(2*pi*1i*(ky*y+kx*x));
end

