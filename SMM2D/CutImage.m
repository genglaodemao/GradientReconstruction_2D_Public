function [subim,xl,yl]=CutImage(im,x1,y1,x2,y2,bound)
[ny,nx]=size(im);
xl=floor(min(x1,x2)-bound);
yl=floor(min(y1,y2)-bound);
xh=ceil(max(x1,x2)+bound);
yh=ceil(max(y1,y2)+bound);
xl=max(1,xl);
yl=max(1,yl);
xh=min(nx,xh);
yh=min(ny,yh);
subim=im(yl:yh,xl:xh);
end