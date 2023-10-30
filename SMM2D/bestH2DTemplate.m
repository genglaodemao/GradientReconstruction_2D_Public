function [bestH,bestR]=bestH2DTemplate(im,k,noise,R)
%find the all H, ready to locating centers
%R - [r1 r2] smallest and largest particle radii in px
%noise - less than (top intensity)/noise will be considered as noise
%rest parameter see SMM.m and Stemplate.m
%OUTPUT: allH - all H
%        BestR - radius in px of the maximal H
%disp('Computing SMM...');

%define some format

[x,y]=size(im);
bestR=zeros(x,y)+mean(R);

%start seaching for bestH
    load('D:\Matlab Code\SMM_2P\Template\SingleTemplate.mat')
    bestH=SMM(im,template,k); %SMM
    
%rescale the intensity of bestH
meanH=mean(bestH(:));
bestH=max(0,bestH-meanH); %exclude pixels with intensity less than the mean
maxH=max(bestH(:));
bestH=max(0,bestH-maxH/noise); %exclude pixels set by the parameter "noise"
bestH=bestH/max(bestH(:))*255; %rescale

    
    



end