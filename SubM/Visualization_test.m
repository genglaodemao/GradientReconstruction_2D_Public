clear all
close all
load('D:\Data\pNAPAM interaction\APR05\PS1038_2GX7_12_lp27_2p.mat')

imagepath='D:\Data\pNAPAM interaction\APR05\';
folder='PS1038_2GX7_12_lp27.nd2';
BGpath=[imagepath 'BG.mat' ];
grpath=[imagepath 'gr1p1038.mat' ];
Rguess=5;
Rreal=5;
Intensity=0.18;
Rangey=[21,88];
Rangex=[21,140];
Gkernel=0.5;
rcut=5;
codepath='D:\Matlab Code\Tracking Code\GradientTrackingMultiP_new\';
cd(codepath);

addpath('SMM2D')
addpath('Image')
addpath('Gradient')
load(BGpath)
load(grpath)

id=floor(rand(1,1)*40000)+1;
name=['at' num2str(id,'%06i') '.tif'];
disp(name);
im=imread([imagepath folder '\' name]); 
 
% return
im=double(im)-BG;
im=im(Rangey(1):Rangey(2),Rangex(1):Rangex(2));
% return

gr=gr(gr(:,1)<rcut,:);
im=im-min(im(:));
im=im/max(im(:))*255;
[im]=conv2d(im,Gkernel);
res=ALLres(ALLres(:,6)==id,:);
% return
%% visualization 
[fig]=find2img(im,res,1,2,3);
[FX0,FY0] = gradient(im);
[nx,ny]=size(im);
Yid=diag(1:nx)*(zeros(nx,ny)+1);
Xid=(diag(1:ny)*(zeros(nx,ny)+1)')';
Para.FX0=FX0;
Para.FY0=FY0;
Para.sizeim=[nx,ny];
Para.Xid=Xid;
Para.Yid=Yid;
Para.sizeim=[nx,ny];
[residual]=plotCompareGradient(Para,res,gr);
daspect([1 1 1])
disp(['Total residual = ' num2str(sum(residual(:)))]);
dis1=sqrt((res(1,1)-res(2,1))^2+(res(1,2)-res(2,2))^2);
disp(['Gredient method - distance: ' num2str(dis1)])
%

disp(['Toal residual record = ' num2str(res(1,5))]);
% Fluctuation=0.01;Noise=1;
% [imS]=SytheticImage(size(im),res,gr,Fluctuation,Noise);
% figure
% imshow(im,[]);
% figure
% imshow(imS,[]);
figure
imshow(residual,[]);
cd(imagepath)
%%
