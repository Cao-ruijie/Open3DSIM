function [zvals] = get_rimismatchpars(OTFparams)
% This function computes relevant parameters for the aberration function
% pertaining to refractive index mismatch. In particular, the routine
% computes the optimum z-stage position, given the nominal free working
% distance and imaging depth from the cover slip and the different
% refractive index values.
%
% relevant z-positions:
% zvals = [nominal stage position, free working distance, -image depth from cover slip]
%
% overall aberration function
% W = zvals_1*W_1 - zvals_2*W_2 - zvals_3*W_3
% W_1 = sqrt(refimm^2-rho^2*NA^2)
% W_2 = sqrt(refimmnom^2-rho^2*NA^2)
% W_3 = sqrt(refmed^2-rho^2*NA^2)
%
% The unknown parameter zvals_1 is computed by minimizing the variance in W
% across the pupil plane W_rms^2 = <W^2> - <W>^2, this is evaluated
% analyticaly with Mathematica, involving:
%
% Amat_{ij} = <W_i*W_j> - <W_i>*<W_j>
%
% minimizing W_rms^2 w.r.t. zvals_1 gives:
%
% zvals_1 = (Amat_{12}/Amat_{11})*zvals_2 + (Amat_{13}/Amat_{11})*zvals_3
%
% and a minimum/optimum rms wavefront aberration
%
% W_rms^2 = (Amat_{22} - Amat_{12}^2/Amat_{11})*zvals_2^2
%         + (Amat_{33} - Amat_{13}^2/Amat_{11})*zvals_3^2
%         + 2*(Amat_{23} - Amat_{12}*Amat_{13}/Amat_{11})*zvals_2*zvals_3
%
% The resulting expressions are numerically unstable in the paraxial regime,
% there a Taylor-series in NA is used. So far, it is assumed that all waves
% are propagating, i.e. NA < refmed in particular, so the outcome should be
% applied with caution to TIRF situations.
%
% copyright Sjoerd Stallinga, TU Delft, 2017

refins = [OTFparams.refimm OTFparams.refimmnom OTFparams.refmed];
zvals = [0 OTFparams.fwd -OTFparams.depth];
NA = OTFparams.NA;
% reduce NA in case of TIRF conditions
if (NA>OTFparams.refmed)
    NA = OTFparams.refmed;
end
paraxiallimit = 0.2;
K = length(refins);

if NA>paraxiallimit
    fsqav = zeros(K,1);
    fav = zeros(K,1);
    Amat = zeros(K,K);
    for jj = 1:K
        fsqav(jj) = refins(jj)^2-(1/2)*NA^2;
        fav(jj) = (2/3/NA^2)*(refins(jj)^3-(refins(jj)^2-NA^2)^(3/2));
        %     fav(jj) = (2/3)*(3*refins(jj)^4-3*refins(jj)^2*NA^2+NA^4)/(refins(jj)^3+(refins(jj)^2-NA^2)^(3/2));
        Amat(jj,jj) = fsqav(jj)-fav(jj)^2;
        for kk = 1:jj-1
            Amat(jj,kk) = (1/4/NA^2)*(refins(jj)*refins(kk)*(refins(jj)^2+refins(kk)^2)...
                          -(refins(jj)^2+refins(kk)^2-2*NA^2)*sqrt(refins(jj)^2-NA^2)*sqrt(refins(kk)^2-NA^2)...
                          +(refins(jj)^2-refins(kk)^2)^2*log((sqrt(refins(jj)^2-NA^2)+sqrt(refins(kk)^2-NA^2))/(refins(jj)+refins(kk))));
            Amat(jj,kk) = Amat(jj,kk)-fav(jj)*fav(kk);
            Amat(kk,jj) = Amat(jj,kk);
        end
    end
    zvalsratio = zeros(K,1);
    Wrmsratio = zeros(K,K);
    for jv = 2:K
        zvalsratio(jv) = Amat(1,jv)/Amat(1,1);
        for kv = 2:K
            Wrmsratio(jv,kv) = Amat(jv,kv)-Amat(1,jv)*Amat(1,kv)/Amat(1,1);
        end
    end
else
    % paraxial limit, Taylor-series in NA
    zvalsratio = zeros(K,1);
    Wrmsratio = [0.0,0.0,0.0; 0.0,0.0,0.0; 0.0,0.0,0.0];
%     Wrmsratio = zeros(K,K);
    for jv = 2:K
        zvalsratio(jv) = refins(1)/refins(jv)+NA^2*(refins(1)^2-refins(jv)^2)/(4*refins(1)*refins(jv)^3);
        for kv = 2:K
            Wrmsratio(jv,kv) = NA^8*(refins(1)^2-refins(jv)^2)*(refins(1)^2-refins(kv)^2)/(11520*refins(1)^4*refins(jv)^3*refins(kv)^3);
        end
    end
end
zvals(1) = zvalsratio(2)*zvals(2)+zvalsratio(3)*zvals(3);


end

