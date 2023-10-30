function [gr_iso] = Iso_gr(gr)
% make gr isotropic
Profile0=gr.profile;
Profile1=flipud(Profile0);
Profile2=fliplr(Profile0);
Profile3=rot90(Profile0,2);
Profile=(Profile0+Profile1+Profile2+Profile3)/4;
gr_iso.X=gr.X;
gr_iso.Y=gr.Y;
gr_iso.profile=Profile;
[grX,grY] = gradient(Profile);
gr_iso.grX=grX;
gr_iso.grY=grY;
end