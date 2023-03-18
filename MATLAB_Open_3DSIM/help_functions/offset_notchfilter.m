function final_fft = offset_notchfilter(fft_image,Mask_total_final,sumtotal_filter,sumotf,dataparams)
dx = dataparams.rawpixelsize(1)/600;   % Sampling in lateral plane at the sample in um
res=dataparams.exwavelength/(2*dataparams.NA);
oversampling=res/dx;                   % factor by which pupil plane oversamples the coherent psf data
N = dataparams.numpixelsx;
dk=oversampling/(N/2);                 % Pupil plane sampling
[kxbig,kybig] = meshgrid(-dk*N:dk:dk*N-dk,-dk*N:dk:dk*N-dk);
kr=sqrt(kxbig.^2+kybig.^2);
sumtotal_filter = ( sumtotal_filter-min(min(min(sumtotal_filter))) )./( max(max(max(sumtotal_filter)))-min(min(min(sumtotal_filter))) );
%wienerfilter = (1-kr/400)./( sumtotal_filter.*Mask_total_final.*sumotf + dataparams.w^2 );
wienerfilter = 1./( sumtotal_filter + dataparams.w^2 );
wienerfilter = wienerfilter.*Mask_total_final;
final_fft = fft_image.*wienerfilter;
end