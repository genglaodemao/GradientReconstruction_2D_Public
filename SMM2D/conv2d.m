function [res]=conv2d(im,r)
%Convolution with 2D Gaussian kernel
[nx,ny]=size(im);

%------put walls around image
pad=round(r);
img=zeros(nx+2*pad,ny+2*pad);
img(pad+1:nx+pad,pad+1:ny+pad)=im;
[nx,ny]=size(img);
%---------------   

[gsigma]=gaussiankernel(r);
res=conv2(img(:,:),gsigma,'same');
temp=res;
res=temp(pad+1:nx-pad,pad+1:ny-pad);
clear temp

end