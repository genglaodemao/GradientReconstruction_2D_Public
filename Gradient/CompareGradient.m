function [er,residual,dx,dy]=CompareGradient(imgr,imgrR,Orthogonal)
%calculate error of image gradient between raw image and reconstructed
%image with in the mask (given by the reconstructed image).
if nargin < 3
    Orthogonal = 0; %put weight on the orientation of the residual, set Orthogonal =1; default = 0;
end
dx=imgr.X-imgrR.X;
dy=imgr.Y-imgrR.Y;
d=dx.^2+dy.^2;
theta1=angle(imgr.X+1i*imgr.Y);
theta2=angle(imgrR.X+1i*imgrR.Y);
% theta2=angle(dx+1i*dy);
theta=theta1-theta2;
if ~Orthogonal
    d=d.*sign(sin(theta)); %defult
else
    d=d.*((abs(sin(theta))+0.3).*sign(sin(theta))); %put weight on the orientation of the residual. 0.7*amplitude+amplitude*sin(differenc of angle)
end
mask=imgrR.mask;
dx=dx.*mask;
dy=dy.*mask;
residual=d.*mask;
er=sum(abs(residual(:))/sum(mask(:)));
residual=d;
end