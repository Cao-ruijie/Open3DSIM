function [final_image] = filter_3D(dataparams,sum_fft,Nx,Ny,Nz,lambdaregul1,lambdaregul2,output)

%% Calculate the Frequency mask
Mask_final = ones(Nx,Ny,Nz);
Mask_final(sum_fft==0)=0;

%% Ccalucalte filter1
lambdaregul = lambdaregul1;
Filter1 = get_filter1(dataparams,lambdaregul).*Mask_final;
lambdaregul = lambdaregul2;
Filter2 = get_filter2(dataparams,lambdaregul).*Mask_final;

%% Do the filter
sum_fft1 = sum_fft.*Filter1.*Filter2;
final_image = fftshift(abs(ifftn(ifftshift(sum_fft1))));

%% Save the results
maxnum = max(max(max(final_image)));
final_image = uint8(255*final_image./maxnum);
stackfilename = [output ,'Open_3DSIM.tif'];
for k = 1:Nz
    imwrite(final_image(:,:,k), stackfilename, 'WriteMode','append') % Ð´ÈëstackÍ¼Ïñ
end

