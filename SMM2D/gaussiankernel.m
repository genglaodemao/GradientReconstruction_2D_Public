function [gsigma]=gaussiankernel(sig)
w=round(sig);
r=single(-w:w)/sig;
gx=exp( -r.^2 );
gy=gx';
gsigma=gy*gx;
gsigma=double(gsigma/sum(gsigma(:)));
end


    