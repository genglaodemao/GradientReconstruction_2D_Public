function [imgrR] = Reconstruct(imsize,gr,Pos,Rcut)
% reconstruc gradient based on profile and position (size)
ny=imsize(1);
nx=imsize(2);
imgrR.X=zeros(imsize);
imgrR.Y=zeros(imsize);
imgrR.profile=zeros(imsize);
maskALL=zeros(imsize);
[X,Y] = meshgrid(1:1:nx,1:1:ny);
N = length(Pos(:,1));
for id = 1 : N
    xc=Pos(id,1);
    yc=Pos(id,2);
    magification=Pos(id,3);
    intensity=Pos(id,4);
    Xid = X - xc;
    Yid = Y - yc;
    GrXid = interp2(gr.X*magification,gr.Y*magification,gr.grX*intensity,Xid,Yid);
    GrXid(isnan(GrXid))=0;
    GrYid = interp2(gr.X*magification,gr.Y*magification,gr.grY*intensity,Xid,Yid);
    GrYid(isnan(GrYid))=0;
    %get baseline
    t=gr.profile(:);
    baseline=(mean(t(1:200))+mean(t(end-200:end)))/2;
    Newprofile=gr.profile-baseline;
    GrProfile = interp2(gr.X*magification,gr.Y*magification,Newprofile*intensity,Xid,Yid);
    GrProfile(isnan(GrProfile))=0;
    [mask,~,~] = Maskit(GrXid*0+1,[xc,yc],Rcut);
    imgrR.X=imgrR.X+GrXid.*mask;
    imgrR.Y=imgrR.Y+GrYid.*mask;
    imgrR.profile=imgrR.profile+GrProfile;
    maskALL=maskALL+mask;
end
imgrR.profile=imgrR.profile+baseline;
maskALL(maskALL>0)=1;
imgrR.mask=maskALL;
end