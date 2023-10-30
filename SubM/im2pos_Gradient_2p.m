function [res] = im2pos_Gradient_2p(im,gr,Rguess,Rreal,Intensity,Rcut)
%Tracking of 1p with Gradient method
[FX,FY] = gradient(im);
imgr.X=FX;
imgr.Y=FY;
[rguess,~]=InitialLocSMM2(im,[Rguess Rguess],0);
res=[rguess(1,1:2) Rreal Intensity;rguess(2,1:2) Rreal Intensity]; 
fun = @(p) FitCore(gr,p,Rcut,imgr);
pguess = res;
options = optimset('MaxIter',1000);
[pfit,fval] = fminsearch(fun,pguess,options);
res=pfit;
res(:,5)=fval;
end