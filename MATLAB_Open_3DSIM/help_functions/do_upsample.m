function [image_out] = do_upsample(image_in,upsamp)

ftimage_in = fftshift(fftn(ifftshift(image_in)));
arraysize_in = size(image_in);
arraysize_out = upsamp(1:length(arraysize_in)).*arraysize_in;

%% do the zero-padding, this uses the dip function extend
padvalue = 0;
image_out = double(extend(ftimage_in,arraysize_out,'symmetric',padvalue));

end