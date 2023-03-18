function [MCNR_ims,allmodulations] = do_modulationcheck(allimages_in)

%% define parameter
[Nx,Ny,numsteps,numfocus,numchannels,numframes,numangles] = size(allimages_in);
maxorder = (numsteps+1)/2; % this assumes that the # independent image Fourier orders = # phase steps
allimages_in = 2*sqrt(double(allimages_in)+3/8);

%% compute modulations by 1D FT in the phase direction
allmodulation_ims = ones(Nx,Ny,maxorder,numfocus,numchannels,numframes,numangles);
allmodulations = ones(maxorder,numfocus,numchannels,numframes,numangles);
for jfocus = 1:numfocus
    for jchannel = 1:numchannels
        for jframe = 1:numframes
            for jangle = 1:numangles
                tempimstack = squeeze(allimages_in(:,:,:,jfocus,jchannel,jframe,jangle));
                tempimstack = permute(tempimstack,[3 1 2]);
                bandstack = fft(tempimstack);
                orderamplitude = zeros(maxorder,1);
                for jorder = 1:maxorder
                    tempim = squeeze(bandstack(jorder,:,:));
                    % correction factor to find A0,A1,... in signal=A0+A1*cos(2*pi*n/N)+... from fft convention
                    if (jorder==1)
                        allmodulation_ims(:,:,jorder,jfocus,jchannel,jframe,jangle) = abs(tempim)/numsteps;
                    else
                        allmodulation_ims(:,:,jorder,jfocus,jchannel,jframe,jangle) = 2*abs(tempim)/numsteps;
                    end
                    orderamplitude(jorder) = sum(sum(abs(tempim)));
                end
                allmodulations(2:end,jfocus,jchannel,jframe,jangle) = 2*orderamplitude(2:end)/orderamplitude(1);
            end
        end
    end
end
modulationcontrast_ims = 2*sqrt(sum(allmodulation_ims(:,:,2:end,:,:,:,:).^2,3));
modulationcontrast_ims = reshape(modulationcontrast_ims,[Nx,Ny,numfocus,numchannels,numframes,numangles]);
MCNR_ims = modulationcontrast_ims; % take this formula with Anscombe transform

%% average over the pattern angles
allmodulations = mean(allmodulations,5);
MCNR_ims = mean(MCNR_ims,6);

end
