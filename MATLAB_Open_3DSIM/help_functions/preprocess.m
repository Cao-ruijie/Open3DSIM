function dataparams = preprocess(dataparams,psf,num_taper)
[numpixelsx,numpixelsy,numsteps,numfocus,numchannels,numframes,numangles] = size(dataparams.allimages_in);

%% 边缘模糊
Temp = zeros(numpixelsx,numpixelsy,numchannels,numframes,numfocus,numangles*numsteps);
for jchannel = 1:numchannels
    for jframe = 1:numframes
        for jangle = 1:numangles
            for jstep = 1:numsteps
                for jz = 1:numfocus
                    temp = double(dataparams.allimages_in(:,:,jstep,jz,jchannel,jframe,jangle));
                    Temp(:,:,jchannel,jframe,jz,(jangle-1)*numsteps+jstep) = importImages_process(temp,num_taper);
                end
            end
        end
    end
end
clear temp

%% RL反卷积
dataparams.allimages_in = zeros(numpixelsx,numpixelsy,numsteps,numfocus,numchannels,numframes,numangles);
for jchannel = 1:numchannels
    for jframe = 1:numframes
        for jz = 1:numfocus
            temp = squeeze(Temp(:,:,1,1,jz,:));
            %temp = deconvlucy(squeeze(Temp(:,:,1,1,jz,:)),psf,5);
            for jangle = 1:numangles
                for jstep = 1:numsteps    
                    dataparams.allimages_in(:,:,jstep,jz,jchannel,jframe,jangle) = temp(:,:,(jangle-1)*numsteps+jstep);
                end
            end
        end
    end
end

end