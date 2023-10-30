%Average images with 1 particle to get the shape function S (Profile).
%Chi Zhang, Physics department, Fribourg University, Switzerland
%chi.zhang2@unifr.ch
%Oct, 2023
clear
close all
%set iftest = 1 for parameter test.
%set iftest = 0 to run over all images.
iftest=0;
%add sub-folders
currentFolder = pwd;
path=[currentFolder '\Images\'];
codepath=currentFolder;
cd(codepath);
addpath('SMM2D')
addpath('SubM')
addpath('Gradient')
folder='1p';
%Set dimension of profile
%RSMM - particle radius in px.
%Rprofile - dimention of S (Profile)
RSMM = 3;
Rprofile=10*RSMM; 
%Set up some varibles.
step=1;
[Xq,Yq] = meshgrid(-Rprofile:step:Rprofile);
Profile=zeros(size(Xq));
N=1000;
EP=1;
%get intensity as a function of to centre distance
 for id = 1 : 1000
    if mod(id,100)==0
    disp(id);
    end
% load image
    name=['at' num2str(id,'%06i') '.tif'];
    im=double(imread([path folder '\' name]));
%---enable if remove backgraound is needed 
% %Load background, ready for background cancellation.
% load([path 'BG.mat']);
%     im=im-BG;
%     im=im-min(im(:));
%-----------------------------------------
    im0=im;    
    im=im/max(im(:))*255;
 %smooth image and get center
    Gkernel=RSMM;
    im0=im0-min(im0(:));
    im0=im0/max(im0(:))*255;
    [im0]=conv2d(im0,Gkernel);
    [r,bestH]=InitialLocSMM(im0,[RSMM,RSMM],iftest);
    if iftest
        daspect([1 1 1])
    return
    end
    if isempty(r)
        EP=EP+1; %in case of no particle detected in one frame
    else
% get intensity profile from non-smoothed image
    center=r(1:2);
    [~,X,Y] = Maskit(im,center,Rprofile);
    ImProfile = interp2(X,Y,im,Xq,Yq);
    Profile = Profile + ImProfile;
    end
 end
% wrap up results
Profile = Profile /(N-EP);
[grX,grY] = Profile2Gradient(Profile,Rprofile/step);
gr.X=Xq;
gr.Y=Yq;
gr.grX=grX;
gr.grY=grY;
gr.profile=Profile;
%show results
 figure
 subplot(1,3,1)
 imshow(Profile,[])
 title('Intensity Profile')
 subplot(1,3,2)
 imshow(grX,[])
 title('Gradient X')
 subplot(1,3,3)
 imshow(grY,[])
 title('Gradient Y')
 %save results
save([path '\Profile_' folder '.mat'],'gr');