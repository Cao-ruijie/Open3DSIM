function final_fft = imerge(fftimagetemp,OTFshifttemp,dataparams,sumotf)

[numpixelsx,numpixelsy,numfocus] = size(dataparams.OTFex);
final_fft = zeros(numpixelsx,numpixelsy,numfocus);
for jangle = 1:dataparams.numangles
    fftimage = squeeze(fftimagetemp(:,:,:,:,jangle));
    OTFshift = squeeze(OTFshifttemp(:,:,:,:,jangle));
    for jstep = 1:dataparams.numsteps        
            final_fft = final_fft + squeeze(fftimage(:,:,jstep,:)).*conj(squeeze(OTFshift(:,:,jstep,:)))./(  squeeze(OTFshift(:,:,jstep,:)).^2 + 0.5*dataparams.w^2 );
    end
end
final_fft = final_fft .*sumotf;
end