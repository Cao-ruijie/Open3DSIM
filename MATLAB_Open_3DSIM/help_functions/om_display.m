function [wf, ld_om, cm, ouf, fig] = om_display(ld, cmin, cmax, is_display)
%%
ld_s = mean(ld,3); 
ld_s = max(ld_s-cmin, 0); 
ld_s = min(ld_s/cmax, 1);
wf = ld_s;
ld_of = fft(ld,[],3);
phy = angle(ld_of(:,:,2));
alpha = mod(-phy/2, pi);
h = alpha/pi;
s = 0.6*ones(size(h));
v = ld_s;
ld_om_hsv = cat(3, h, s, v);
ld_om = hsv2rgb(ld_om_hsv);
if is_display
    fig = figure;
    imshow(ld_om)
else
    fig = -1;
end
%
cm = zeros(100, 100);
s = 0.6*ones(size(cm));
%
xx = 0:size(cm,1)-1; yy = xx; c0 = size(cm,1)/2-0.5;
[xx,yy] = meshgrid(xx,yy);
radius = sqrt((xx-c0).^2+(yy-c0).^2);
mask = (radius <= 50) .* (radius>30);  
v = ones(size(cm)).*mask;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Horizontal as zero degree
% anti-clockwise as plus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
phy = atan((c0-yy)./(xx-c0));
phy = mod(phy, pi);
h = phy/pi;
%
cm_hsv = cat(3, h, s, v);
cm = hsv2rgb(cm_hsv);
%%
ac = abs(ld_of(:,:,2));
dc = abs(ld_of(:,:,1));
ouf = ac./dc;