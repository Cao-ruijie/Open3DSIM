function [center_fft_filter] = WoFilterCenterF(OTF_shift,Mask,center_fft)
OTFshift = squeeze(OTF_shift(:,:,1,:,1,1,1));
% OTF功率
OTFpower = OTFshift.*conj(OTFshift);
% Noise功率

nNoise = center_fft.*(1-Mask);
NoisePower = sum(sum(sum( nNoise.*conj(nNoise) )))./( sum(sum(sum(1-Mask))) - sum(sum(sum(Mask))) );

SFo = 1;
co = 1;
center_fft_filter = center_fft.*(SFo.*conj(OTFshift)./NoisePower)./((SFo.^2).*OTFpower./NoisePower + co./OBJpower);

end