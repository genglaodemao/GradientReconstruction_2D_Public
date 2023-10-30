function [imS] = Sythetic2p(imsize,gr,res,Rcut,fluc,noise)
[imgrR] = Reconstruct(imsize,gr,res,Rcut);
imS=imgrR.profile*60;
imfluc=zeros(imsize)+1-fluc*randn(imsize);
imnoise=randn(imsize)*noise*mean(imS(:));
imS=imS.*imfluc + imnoise;
end