function [scatter]=image2scatter(im,N,x1,y1,x2,y2,xl,yl,bound)
im=double(im);
im=im+1;
[ny,nx]=size(im);
s=im(:)/sum(im(:));
sx=cumsum(s);
sy=(1:nx*ny)';
am=rand(N,1);
pos=spline(sx,sy,am);
x=floor(pos/ny)+1+(rand(N,1)-0.5);
y=mod(pos-1,ny)+1;
scatter=[x,y];
%remove scatters out of particles range
dis1=sqrt((x-x1+xl-1).^2+(y-y1+yl-1).^2);
dis2=sqrt((x-x2+xl-1).^2+(y-y2+yl-1).^2);
dis=min(dis1,dis2);
scatter=scatter(dis<bound,:);
end