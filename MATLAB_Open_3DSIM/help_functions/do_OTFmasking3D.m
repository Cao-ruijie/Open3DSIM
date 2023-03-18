function OTFinc = do_OTFmasking3D(OTFinc,parameters)

%% Basic parameter
NA = parameters.NA;
lambda = parameters.lambda;
refmed = parameters.refmed;

%% OTF support and sampling (in physical units)
SupportSizex = parameters.supportsizex;
SupportSizey = parameters.supportsizey;
SupportSizez = parameters.supportsizez;
Nsupportx = parameters.Nsupportx;
Nsupporty = parameters.Nsupporty;
Nsupportz = parameters.Nsupportz;
Dqx = 2*SupportSizex/Nsupportx;
Dqy = 2*SupportSizex/Nsupporty;
Dqz = 2*SupportSizez/Nsupportz;
shiftqx = parameters.shiftsupport(1)*Dqx;
shiftqy = parameters.shiftsupport(2)*Dqy;
shiftqz = parameters.shiftsupport(3)*Dqz;
qx = -SupportSizex+Dqx/2:Dqx:SupportSizex;
qy = -SupportSizey+Dqy/2:Dqy:SupportSizey;
qz = -SupportSizez+Dqz/2:Dqz:SupportSizez;
qx = qx-shiftqx;
qy = qy-shiftqy;
qz = qz-shiftqz;
[spatfreqsx,spatfreqsy,spatfreqsz] = meshgrid(qx,qy,qz);

%% Masking
epsy = 1e2*eps;
q0 = refmed/lambda;
NAl = NA/lambda;
NBl = sqrt(q0^2-NAl^2);
spatfreqsxy = sqrt(spatfreqsx.^2+spatfreqsy.^2);
qcutoff = double(spatfreqsxy<=2*NAl).*(sqrt(q0^2-(spatfreqsxy-NAl).^2)-NBl);
OTFmask = double(abs(spatfreqsz)<=qcutoff+Dqz/2);
OTFinc = OTFmask.*OTFinc;

end

