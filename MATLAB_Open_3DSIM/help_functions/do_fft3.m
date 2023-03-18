function [fttempimage_ups] = do_fft3(tempimage)
fttempimage_ups = fftshift(fftn(ifftshift(tempimage)));
end