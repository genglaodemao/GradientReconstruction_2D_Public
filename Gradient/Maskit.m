function [mask,Xid,Yid] = Maskit(im,center,radius)
%Generate a mask based on existing image.
%mask = 1 if in mask, 0 otherwise
[ny,nx] = size(im);
[X,Y] = meshgrid(1:1:nx,1:1:ny);
N=length(center(:,1));
mask=zeros(size(im));
for id = 1 : N
    Xid=X-center(id,1);
    Yid=Y-center(id,2);
    dis=sqrt(Xid.^2+Yid.^2);
    maskid = double(dis<radius);
    mask=mask+maskid;
end
    mask(mask>0)=1;
end
