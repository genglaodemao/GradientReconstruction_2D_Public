function [H]=SMM(im,s,k)
%SMM inversed FFT results
%im - original image
%s - template
%k - parameter of wiener filter

I=double(im);
% I=(I-min(min(min(I))))/(max(max(max(I)))-min(min(min(I))))*255;

%FFT of original image
FI=fft2(I);

%FFT of point spread function
FS=fft2(s);

%Wiener filter
Ns=abs(FS);
w=Ns./(Ns+k);

%H
FH=(FI./FS).*w;
H=ifft2(FH);
H=ifftshift(H);
H=max(H,0);

end