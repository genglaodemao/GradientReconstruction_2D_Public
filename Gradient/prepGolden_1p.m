function [imgr,PosGuess] = prepGolden_1p(im,Rguess,Rreal,Intensity,iftest)
if nargin < 5
    iftest=0;
end
[FX,FY] = gradient(im);
imgr.X=FX;
imgr.Y=FY;
[rguess,~]=InitialLocSMM(im,[Rguess Rguess],iftest);
PosGuess=[rguess(1:2) Rreal Intensity];
end