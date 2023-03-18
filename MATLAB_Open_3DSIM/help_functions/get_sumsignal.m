function [dataparams] = get_sumsignal(dataparams,widefield)

allwfsumsignal = zeros(dataparams.numchannels,dataparams.numframes);
for jchannel = 1:dataparams.numchannels
    for jframe = 1:dataparams.numframes
      widefieldtmp = squeeze(widefield(:,:,:,jchannel,jframe));
      allwfsumsignal(jchannel,jframe) = sum(widefieldtmp(:));
    end
end
dataparams.allwfsumsignal = allwfsumsignal;

end