function [s]=Stemplate2D(im,r,av,bc)
%define template
%r - radius in px
%av - intensity of particle, should equals to the average intensity of all
%particles in im
%ba - background level

[x y]=size(im);
%set sphere spread funcion
s=rand(x,y)*bc; %background
xc=(x+1)/2;
yc=(y+1)/2;
Midx=zeros(x,y);
Midy=zeros(x,y);

for i=1:x
    Midx(i,:,:)=i;
end
for j=1:y
    Midy(:,j,:)=j;
end

dis=sqrt((xc-Midx).^2+(yc-Midy).^2);
f=find(dis<=r);
s(f)=av;

s=s-bc/2;
s=max(s,0);


end