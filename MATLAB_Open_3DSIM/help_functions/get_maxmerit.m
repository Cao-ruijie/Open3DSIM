function [maxx,maxy] = get_maxmerit(meritmat,peakroisize)
% This function finds the location of the absolute maximum of meritmat,
% first up to one Fourier pixel size, then refined with a parabolic fit
% to a region around that maximum
%
% copyright Sjoerd Stallinga TUD 2017-2020

% find row and column index of absolute maximum
[Nrow,Ncol] = size(meritmat);
[maxval,maxind] = max(meritmat(:));
[maxrow,maxcol] = ind2sub([Nrow,Ncol],maxind);

% crop to roi around absolute maximum
xrange = maxrow-peakroisize:maxrow+peakroisize;
if (min(xrange)<1)
  xrange = xrange-min(xrange)+1;
  maxrow = maxrow-min(xrange)+1;
end
if (max(xrange)>Nrow)
  xrange = xrange-max(xrange)+Nrow;
  maxrow = maxrow-max(xrange)+Nrow;
end
yrange = maxcol-peakroisize:maxcol+peakroisize;
if (min(yrange)<1)
  yrange = yrange-min(yrange)+1;
  maxcol = maxcol-min(yrange)+1;
end
if (max(yrange)>Ncol)
  yrange = yrange-max(yrange)+Ncol;
  maxcol = maxcol-max(yrange)+Ncol;
end
tempimroi = meritmat(xrange,yrange);

% make parabolic fit to region around absolute maximum
xyv = -peakroisize:peakroisize;
weight = ones(size(tempimroi));
polorder = 2;
polcoefs = polyfitweighted2(xyv,xyv,tempimroi,polorder,weight);
bb = [polcoefs(2); polcoefs(3)];
Aa = [2*polcoefs(4) polcoefs(5); polcoefs(5) 2*polcoefs(6)];
delpixs = Aa\bb;

% final values
maxx = maxcol-delpixs(1);
maxy = maxrow-delpixs(2);

end

