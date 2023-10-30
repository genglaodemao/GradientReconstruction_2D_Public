function [grX,grY] = Profile2Gradient(Profile,Rprofile)
[FX,FY] = gradient(Profile);
[mask,~,~] = Maskit(Profile,size(Profile)/2+0.5,Rprofile);
grX=FX.*mask;
grY=FY.*mask;
end


