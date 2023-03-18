function [imoutA,imoutB] = do_binosplit(imin,psplit)
% This function splits an input image in two parts using the binomial
% random distribution. If the noise on imin follows Poison-statistics then
% the noise on imoutA and imoutB also follow Poisson-statistics with rates
% that are psplit and (1-psplit) times less. The parameter psplit must
% satisfy 0<psplit<1. For high photon counts we approximate the binomial
% distribution with a Gaussian in order to speed up computations.
%
% copyright Sjoerd Stallinga, TU Delft, 2017-2020

epsy = 100*eps;
imthr = 150; % threshold above which the binomial random numbers are replaced with Gaussian random numbers
tempim = round(imin); % make integer from pixel value
diffim = imin-tempim; % remainder of pixel value with integer
tempimlo = tempim;
tempimlo(tempim>=imthr) = 1; % dummy value
imoutAlo = binornd(tempimlo,psplit); % binomial random number for low counts
imoutAlo(tempim>=imthr) = 0;
tempimhi = tempim;
tempimhi(tempim<imthr) = 1.0; % dummy value
imoutAhi = normrnd(psplit.*tempimhi,sqrt(psplit.*(1-psplit).*tempimhi)); % Gaussian random number for high counts
tempsplit = psplit.*tempimhi;
imoutAhi(imoutAhi>=tempimhi) = tempsplit(imoutAhi>=tempimhi); % provision for a split that is higher than the total
imoutAhi(imoutAhi<0) = tempsplit(imoutAhi<0); % provision for a split that is lower than zero
imoutAhi(tempim<imthr) = 0;
imoutA = imoutAlo+imoutAhi;
% imoutA = binornd(tempim,psplit); % binomial random number
imoutA = imoutA+(imoutA./(imin+epsy)).*diffim; % split remainder with uniform distribution
imoutB = imin-imoutA; % complementary pixel value

end

