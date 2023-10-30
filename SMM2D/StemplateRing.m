function [s]=StemplateRing(im,r,a,av,bc,rot)
%define template
%r - radius in px
%av - intensity of particle, should equals to the average intensity of all
%particles in im
%ba - background level

[x y]=size(im);
%set sphere spread funcion
s=rand(x,y)*bc;%background
BC=s;
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
f=find(dis<=r+a/2);
s(f)=av;
f=find(dis<=r-a/2);
s(f)=BC(f);

%-----customize the template to make "C" shape-----

%  cs=(Midy-yc)./sqrt((Midx-xc).^2+(Midy-yc).^2);
%  f1=find(cs>cos(45/180*pi)); %open a gap from (-45, 45)
%  sn=(Midx-xc)./sqrt((Midx-xc).^2+(Midy-yc).^2);
% %  f2=find(sn(f1)>sin(-0/180*pi)); %adjust the gap to (-20,45)
% %  f=f1(f2);
% f=f1;
% if rot
%   f=x*y-f+1;  %rotate the template by 180 degree 
% end 
%  s(f)=BC(f);
%--------------------------------------------------

s=s-bc/2;
s=max(s,0);
%-------
% figure
% imshow(s,[])


end