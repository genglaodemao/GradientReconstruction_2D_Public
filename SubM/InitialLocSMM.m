function [r,bestH]=InitialLocSMM(im,R,ifplot)

av=160;  %intensity within the template, should roughly equal to the mean intensity of particles
bc=1;    %background intensity, do not set to 0
k=10^7;  %Wiener filter parameter, optimised for the example
step=0.1; %step of size in pixel, increase step to save time, decrease step to gain accuracy. Normally meaningless is smaller than 0.1.

iffilter=0; %set to 1 means convolute the peaks (particles) with Gaussian kernel with corresponding size. 0 otherwise.

masscut=0; %reject particle with mass less than
mask=0; %if particle edge is significantly dimmer, the detected size will be smaller. mask=real size - detected size is the correction for this.
noise=20; %pixel with intensity less than maximum/noise will be excluded
pN=1;
%Computing

[bestH,bestR]=bestH2D(im,R,av,bc,k,step,noise);
% [bestH,bestR,s]=bestH2DRing(im,R,av,bc,k,step,noise,0);
% [r] = featureHold(im,bestH,bestR,R,step,iffilter,masscut,mask);
[r,~] = featureH(im,pN,bestH,bestR,R,step,iffilter,masscut,mask);
if isempty(r) == 0
r(:,1)=r(:,1);
r(:,2)=r(:,2);
end
%visuilizing
if ifplot
find2img(im,r,1,2,3);
end
end