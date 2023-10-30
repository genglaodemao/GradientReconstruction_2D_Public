function [r]=findcenters(im,pN,R,k,noise,step,iffilter,masscut,mask,ifplot)
[bestH,bestR]=bestH2D(im,R,160,1,k,step,noise);
bestR=bestR*0+3;
R=[3,3];
[r] = featureH(im,pN,bestH,bestR,R,step,iffilter,masscut,mask); %r is the final result
if ifplot
      find2img(bestH,r,1,2,3);
end


end