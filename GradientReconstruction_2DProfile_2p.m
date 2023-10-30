%Particle tracking Gradient reconstruction (2p).
%Chi Zhang, Physics department, Fribourg University, Switzerland
%chi.zhang2@unifr.ch
%Oct, 2023
clear
close all
currentFolder = pwd;
codepath=currentFolder;
imagepath=[currentFolder '\Images\'];
%Load shape S (Profile).
load([imagepath 'Profile_1p.mat'])
% Set some parameters
Rguess=3; %radius in px for Centroid tracking
Gkernel=0; %smooth Gaussian kernel, defult = 0;
Rcut=25; %fitting range in px, radius of mask 
Intensity=1;
Rreal=1;
%folder name that contains target images.
folder='2p';
%add sub-folders
cd(codepath);
addpath('SMM2D')
addpath('Gradient')
addpath('SubM')
%set ROI, make sure each dimesion is an even number.
Rangey=[13,70];
Rangey(2)=(floor((Rangey(2)-Rangey(1))/2)+0.5)*2+Rangey(1);
Rangex=[21,90];
Rangex(2)=(floor((Rangex(2)-Rangex(1))/2)+0.5)*2+Rangex(1);
%select a image
id=floor(rand(1,1)*1000)+1;
name=['at' num2str(id,'%06i') '.tif'];
disp(['Targeting image: ' name]);
%load image and rescale it
im=double(imread([imagepath folder '\' name])); 
%---enable if remove backgraound is needed 
% %Load background, ready for background cancellation.
% load([imagepath 'bg.mat' ])
%     im=im-BG;
%     im=im-min(im(:));
%-----------------------------------------
im=im/max(im(:))*255;
im=im(Rangey(1):Rangey(2),Rangex(1):Rangex(2));
%slightly smooth the image, if needed. Otherwise, set Gkernel = 0. 
if Gkernel>0
[im]=conv2d(im,Gkernel);
end
%prepare fit, get guess values and define initial guessing step.
[imgr,PosGuess] = prepGolden_2p(im,Rguess,Rreal,Intensity,1);
title('Initial guess')
PosStep=[0.1,0.1,0.1,0.1;0.1,0.1,0.1,0.1];
% fit
tic
[res,PosStep] = GoldenSectionSearch_Gradient(imgr,gr,PosGuess,Rcut,PosStep);
time=toc;
disp(['time = ' num2str(time) ' s']);
%% visualization
imsize=size(im);
[X,Y] = meshgrid(1:1:imsize(2),1:1:imsize(1));
[FX,FY] = gradient(im);
imgr.X=FX;
imgr.Y=FY;
[imgrR] = Reconstruct(imsize,gr,res,Rcut);
[er,residual,dx,dy]=CompareGradient(imgr,imgrR);
disp(['mean er = ' num2str(er)])
%
figure('units','normalized','outerposition',[0 0 1 1])
%
subplot(2,3,1)
imshow(im,[]);
title('Image')
%
subplot(2,3,2)
imshow(imgrR.profile,[])
title('Reconstruction')
%
subplot(2,3,3)
grX=imgr.X;
grY=imgr.Y;
grRX=imgrR.X;
grRY=imgrR.Y;
quiver(X(:),Y(:),grX(:),grY(:),'linewidth',0.5);
hold on
quiver(X(:),Y(:),grRX(:),grRY(:),'linewidth',0.5);
hold off
nx1=min(res(:,1))-10;
nx2=max(res(:,1))+10;
ny1=min(res(:,2))-10;
ny2=max(res(:,2))+10;
xlim([nx1,nx2])
ylim([ny1,ny2])
title('Gradient of both')
%
subplot(2,3,4)
clims = [0 25];
imagesc((abs(residual.*imgrR.mask)),clims)
% imagesc(sign(residual).*sqrt(abs(residual)),clims)
axis equal
title({'Residual of Gradient:','(Im - Recon)^2 '})
colorbar
%
subplot(2,3,5)
Imdif=im-imgrR.profile;
meanImdif=mean(Imdif(:));
Imdif=Imdif-meanImdif;
clims = [-10 10];
imagesc(Imdif,clims)
axis equal
colorbar
title({'Diffrence of Intensity:' 'Image - Recon'})
subplot(2,3,6)
histogram(Imdif,-10:1:10)
title('Histogram(Diffrence)')
%%disp results
disp('Fitting results:')
disp('--x------y------size------intensity------mean residual')
disp(res)
%%