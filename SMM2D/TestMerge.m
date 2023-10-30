clear
clc
cd 'D:\Matlab Code\SMM2D\'
load('D:\Data\pNAPAM interaction\Test 28.03.2019\Results\Background.mat')
imagepath='D:\Data\pNAPAM interaction\Test 28.03.2019\';
V=[55 60 65 70 75 80 85 90 95 100 105 110 115 120 125 130 135 140 145];
 fol=1
name=['V' num2str(V(fol)) 'mV'];
disp(name);
imagepathA=[imagepath 'TrapA\' name '\'];
imagepathB=[imagepath 'TrapB\' name '\'];
ires=0;
res=[];
%%

idA=844;
idB=1880;
A=imread([imagepathA 'Autosave_' num2str(idA) '.tif']);   
B=imread([imagepathB 'Autosave_' num2str(idB) '.tif']);
A=double(A)-BG;
B=double(B)-BG;
Merge=A+B;
Merge=Merge-min(Merge(:));
Merge=Merge/max(Merge(:))*255;
im=Merge;
 R=[3 3]; %radius range in pixel
av=160;  %intensity within the template, should roughly equal to the mean intensity of particles
bc=1;    %background intensity, do not set to 0
k=10^7;  %Wiener filter parameter, optimised for the example
step=0.1; %step of size in pixel, increase step to save time, decrease step to gain accuracy. Normally meaningless is smaller than 0.1.
masscut=1;  %reject particle with mass less than (5th column)
iffilter=0; %set to 1 means convolute the peaks (particles) with Gaussian kernel with corresponding size. 0 otherwise.
mask=0; %if particle edge is significantly dimmer, the detected size will be smaller. mask=real size - detected size is the correction for this.
noise=5; %pixel with intensity less than maximum/noise will be excluded
pN=2;
%Computing
% R=(R(1)+R(2))/2;
% bestH = bpass(im,1,Ra,noise);
% bestR=bestH*0+Ra;
[bestH,bestR]=bestH2DTemplate(im,k,noise,R);
[r] = featureH(im,pN,bestH,bestR,R,step,iffilter,masscut,mask); %r is the final result
% [r] = featureHold(im,bestH,bestR,R,step,iffilter,masscut,mask); %r is the final result
% r=r(r(:,7)<0.12,:); %peak intensity, set to exclude fake one
% %visuilizing
 find2img(Merge,r,1,2,3);
 return
% disp(['Compting time: ' num2str(floor(t/60)) 'm' num2str(round(mod(t,60))) 's.']);
% disp(['the ' num2str(i) ' frame,' num2str(lr) ' particles found.']);
