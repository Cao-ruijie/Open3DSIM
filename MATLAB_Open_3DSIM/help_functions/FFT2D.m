function [ out ] = FFT2D( in,inverse )
    if inverse==true
        out=(ifft2(fftshift(in)));
    else
        out=fftshift(fft2(in));
    end
end

