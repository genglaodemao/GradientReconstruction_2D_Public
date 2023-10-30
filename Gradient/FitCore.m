function [er] = FitCore(gr,Pos,Rcut,imgr)
%Core of fitting function 
%reconstruct gradient and compare with raw image gradient to get error
%functio value
imsize=size(imgr.X);
[imgrR] = Reconstruct(imsize,gr,Pos,Rcut);
[er,~]=CompareGradient(imgr,imgrR);
end