function [widefield,ftwidefield] = get_widefield(allimages_in)
%% size of image
[numpixelsx,numpixelsy,~,numfocus,numchannels,numframes,~] = size(allimages_in);
%% get WF
widefield = zeros(numpixelsx,numpixelsy,numfocus,numchannels,numframes);
widefield(:,:,:,:,:) = sum(sum(allimages_in(:,:,:,:,:,:,:),7),3);
%% get FFT of WF
ftwidefield = zeros(numpixelsx,numpixelsy,numfocus,numchannels,numframes);
for jframe = 1:numframes
  for jchannel = 1:numchannels
    tempim = squeeze(widefield(:,:,:,jchannel,jframe));
    ftwidefield(:,:,:,jchannel,jframe) = fftshift(fftn(ifftshift(tempim)));
  end
end

end

