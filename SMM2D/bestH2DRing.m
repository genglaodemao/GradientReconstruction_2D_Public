function [bestH,bestR,s]=bestH2DRing(im,R,av,bc,k,step,noise,rot)
%find the all H, ready to locating centers
%R - [r1 r2] smallest and largest particle radii in px
%noise - less than (top intensity)/noise will be considered as noise
%rest parameter see SMM.m and Stemplate.m
%OUTPUT: allH - all H
%        BestR - radius in px of the maximal H
%disp('Computing SMM...');

%define some format
r1=R(1);
r2=R(2);
[x,y]=size(im);
l=length(r1:step:r2);
meanH=zeros(l,1);
bestR=zeros(x,y);
bestH=zeros(x,y);

%start seaching for bestH
Id=0;
for r=r1:step:r2
    Id=Id+1;
    [s]=StemplateRing(im,r,2,av,bc,rot); %generate templates
    [H]=SMM(im,s,k); %SMM
    meanH(Id)=mean(mean(mean(H))); 
    bestH=max(bestH,H); %upgrade bestH
    bestR(bestH==H)=r; %upgrade bestR
end
clear H im

%rescale the intensity of bestH
meanH=mean(meanH);
bestH=max(0,bestH-meanH); %exclude pixels with intensity less than the mean
maxH=max(bestH(:));
bestH=max(0,bestH-maxH/noise); %exclude pixels set by the parameter "noise"
bestH=bestH/max(bestH(:))*255; %rescale

    
    



end