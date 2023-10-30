function [imgr,PosGuess] = prepGolden_2p(im,Rguess,Rreal,Intensity,iftest)
if nargin < 5
    iftest=0;
end
[FX,FY] = gradient(im);
imgr.X=FX;
imgr.Y=FY;
[rguess,~]=InitialLocSMM2(im,[Rguess Rguess],iftest);
PosGuess=[rguess(1,1:2) Rreal Intensity; rguess(2,1:2) Rreal Intensity];
end