function [gr] = Refine_gr(imgr,gr,Pos,dgrX,dgrY,Rcut)
imsize=size(imgr.X);
ny=imsize(1);
nx=imsize(2);
[X,Y] = meshgrid(1:1:nx,1:1:ny);
%%
for i = 1 : 10
    xc=Pos(1,1);
    yc=Pos(1,2);
    magification=1/Pos(1,3);
    intensity=1/Pos(1,4);
    Xid = X - xc;
    Yid = Y - yc;
    GrXid1 = interp2(Xid*magification,Yid*magification,dgrX*intensity/2,gr.X,gr.Y);
    GrXid1(isnan(GrXid1))=0;
    GrYid1 = interp2(Xid*magification,Yid*magification,dgrY*intensity/2,gr.X,gr.Y);
    GrYid1(isnan(GrYid1))=0;
    %
    xc=Pos(2,1);
    yc=Pos(2,2);
    magification=1/Pos(2,3);
    intensity=1/Pos(2,4);
    Xid = X - xc;
    Yid = Y - yc;
    GrXid2 = interp2(Xid*magification,Yid*magification,dgrX*intensity/2,gr.X,gr.Y);
    GrXid2(isnan(GrXid2))=0;
    GrYid2 = interp2(Xid*magification,Yid*magification,dgrY*intensity/2,gr.X,gr.Y);
    GrYid2(isnan(GrYid2))=0;
    %
    GrXid=(GrXid1+GrXid2)/2;
    GrYid=(GrYid1+GrYid2)/2;
    gr.grX=gr.grX+GrXid;
    gr.grY=gr.grY+GrYid;
    %
    [imgrR] = Reconstruct(imsize,gr,Pos,Rcut);
    [~,~,dgrX,dgrY]=CompareGradient(imgr,imgrR);
end
    %
end