function [outv] = NfourierShift( inv,kx,ky )
    inv=(ifft2(fftshift(inv)));
    outv=fourierShift(inv,kx,ky);
    outv=fftshift(fft2((outv)));
end

