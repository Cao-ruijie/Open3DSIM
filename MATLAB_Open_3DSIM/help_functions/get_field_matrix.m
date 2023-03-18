function [XImage,YImage,ZImage,FieldMatrix] = get_field_matrix(PupilMatrix,wavevector,wavevectorzmed,OTFparams)

%% Basic parameter
NA = OTFparams.NA;
lambda = OTFparams.lambda;
xemit = OTFparams.xemit;
yemit = OTFparams.yemit;
zemit = OTFparams.zemit;
xrange = OTFparams.xrange;
yrange = OTFparams.yrange;
zmin = OTFparams.zrange(1);
zmax = OTFparams.zrange(2);
Npupil = OTFparams.Npupil;
Mx = OTFparams.Mx;
My = OTFparams.My;
Mz = OTFparams.Mz;
PupilSize = NA/lambda;
ImageSizex = xrange;
ImageSizey = yrange;
ImageSizez = (zmax-zmin)/2;
DxImage = 2*ImageSizex/Mx;
DyImage = 2*ImageSizey/My;
DzImage = 2*ImageSizez/Mz;
ximagelin = -ImageSizex+DxImage/2:DxImage:ImageSizex;
yimagelin = -ImageSizey+DyImage/2:DyImage:ImageSizey;
[YImage,XImage] = meshgrid(yimagelin,ximagelin);
ZImage = zmin+DzImage/2:DzImage:zmax;

%% Aberration correction
Wpos = xemit*wavevector{1}+yemit*wavevector{2}+zemit*wavevectorzmed;

%% Auxiliary vector of DZT transformation
[Ax,Bx,Dx] = prechirpz(PupilSize,ImageSizex,Npupil,Mx);
[Ay,By,Dy] = prechirpz(PupilSize,ImageSizey,Npupil,My);

%% Field matrix
FieldMatrix = cell(2,3,Mz);
for jz = 1:numel(ZImage)
    zemitrun = ZImage(jz);
    PositionPhaseMask = exp(1i*(Wpos+zemitrun*wavevectorzmed));
    for itel = 1:2
        for jtel = 1:3
            PupilFunction = PositionPhaseMask.*PupilMatrix{itel,jtel};
            IntermediateImage = transpose(cztfunc(PupilFunction,Ay,By,Dy));
            FieldMatrix{itel,jtel,jz} = transpose(cztfunc(IntermediateImage,Ax,Bx,Dx));
        end
    end
end

end