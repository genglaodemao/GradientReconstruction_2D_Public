function [res] = featureHold(image,bestH,bestR,R,step,iffilter,masscut,mask)
%Locate coordinate for SMM
%INPUT:
%image - original 2D image
%bestH, bestR, R and step - see bestH.m
%iffilter - if a filter is needed for the original image.
%optional:
%mask - if detected size is significant smaller than real size due to dimmer edge, set
%mask=real radius- detected radius. default =0.
%masscut - reject mass less than this value, default = 0. set to non zero if image is
%noisy.


%Define some parameters
xyzmax=size(image);
if nargin < 7, masscut=0; end
if nargin < 8, mask=0; end
res=[];
RR=R(1):step:R(2);
l_frno=length(RR);
for i=1:l_frno
    extentall(i)=ceil(2*RR(i)+1)+mod(ceil(2*RR(i)+1)+1,2);
    sepall(i)=ceil(RR(i))+min(R);
    maskszall(i)=ceil(2*RR(i))+mask;
end

%Put a boader around image to avoid out boundry
[nx, ny] = size( bestH );
a = zeros( nx+extentall(l_frno), ny+extentall(l_frno), 'single' );
b = zeros( nx+extentall(l_frno), ny+extentall(l_frno), 'single');

a(fix(extentall(l_frno)/2)+1:fix((extentall(l_frno)/2))+nx,fix(extentall(l_frno)/2)+1:fix((extentall(l_frno)/2))+ny)=bestH(:,:);
b(fix(extentall(l_frno)/2)+1:fix((extentall(l_frno)/2))+nx,fix(extentall(l_frno)/2)+1:fix((extentall(l_frno)/2))+ny)=bestR(:,:);



%Finding local maxima
loc= localmaxHold(a,b,RR,sepall,extentall);

if (numel(loc) == 0 || loc(1) == -1)
    res = [];
    return
end

%disp('Subpixel accuracy calculating.');

% Go back or NOT go back to the original image
clear a b
[nx, ny] = size( image );
a = zeros( nx+extentall(l_frno), ny+extentall(l_frno), 'single' );
a(fix(extentall(l_frno)/2)+1:fix((extentall(l_frno)/2))+nx,fix(extentall(l_frno)/2)+1:fix((extentall(l_frno)/2))+ny)=bestH(:,:);
% a(fix(extentall(l_frno)/2)+1:fix((extentall(l_frno)/2))+nx,fix(extentall(l_frno)/2)+1:fix((extentall(l_frno)/2))+ny)=image(:,:);
nx = nx + extentall(l_frno); 
ny = ny + extentall(l_frno);
%end------------------------------------------------


%set up same stuff
xall = loc(:,1);
yall = loc(:,2);
sall = single(loc(:,3));
% Mall = loc(:,4);
Mall=a(yall,xall);

%%Leave some space near the edge to avoid out of border
id=find(xall>maskszall(l_frno) & xall<xyzmax(2)+extentall(l_frno)-maskszall(l_frno) & yall>maskszall(l_frno) & yall<xyzmax(1)+extentall(l_frno)-maskszall(l_frno) );
xall=xall(id); yall=yall(id);  sall=sall(id); Mall = Mall(id);
totalno=0;

%find coordinates with different particle size
for fr=1:l_frno
    s=RR(fr);
    r_s=find(sall==single(s));
    x=xall(r_s);
    y=yall(r_s);
    sc=sall(r_s);
    Mc=Mall(r_s);
    nmax=length(x);
    m=zeros(nmax,1);
  if nmax>0
    masksz=maskszall(fr); 
    extent = fix(masksz) + 1;
    extent = extent + mod((extent+1),2);
    xl = x - fix(extent/2); 
    xh = xl + extent -1;
    yl = y - fix(extent/2); 
    yh = yl + extent -1;

 %Set up some masks
    rsq = rsqd( extent,extent );
    t = thetarr( extent );
    mask = le(rsq,(extent/2)^2);      
    mask2 = ones(1,extent)'*[1:extent];
    mask2 = mask2.*mask;           
    mask3= (rsq.*mask) + (1/6);
    cen = (extent-1)/2 +1;           
    cmask = cos(2*t).*mask;
    smask = sin(2*t).*mask;
    cmask(cen,cen) = 0.0;
    smask(cen,cen) = 0.0;  

    suba = zeros(extent, extent, nmax);
    xmask = mask2;
    ymask = mask2';
          
    yscale = 1;
    ycen = cen;             
    
    %	Estimate the mass
    
    for i=1:nmax 
        m(i) = sum(sum(double(a(fix(yl(i)):fix(yh(i)),fix(xl(i)):fix(xh(i))).*mask))); 
    end
    
    % remove features based on 'masscut' parameter
    b = find(m > masscut);    %only those features with a total mass higher than masscut make the grade
    nmax=length(b);
    
    xl = xl(b);
    xh = xh(b);
    yl = yl(b);
    yh = yh(b);
    x = x(b);
    y = y(b);
    m = m(b);
    sc = sc(b);
    Mc = Mc(b);
    xloc = x  - fix(extentall(l_frno)/2);
    yloc = y  - fix(extentall(l_frno)/2) * yscale;

    %	Setup some result arrays
    xc = zeros(nmax,1);
    yc = zeros(nmax,1);
    rg = zeros(nmax,1);
    e  = zeros(nmax,1);

    %	Calculate feature centers
   if nmax>0
    clear m
    for i=1:nmax,
        clear temp temp1
        temp=a(fix(yl(i)):fix(yh(i)),fix(xl(i)):fix(xh(i))); 
        m(i)=sum(sum(temp.*mask));
        xc(i) = sum(sum(temp.*xmask));  
        yc(i) = sum(sum(temp.*ymask));
    end

    %	Correct for the 'offset' of the centroid masks
    
    xc = xc./m' - ((extent+1)/2);            
    yc = (yc./m' - (extent+1)/2)/yscale;  
    %	Update the positions and correct for the width of the 'border'
    x = x + xc ;
    y = ( y + yc ) * yscale;
    x2=x;
    y2=y;
    x = x  - fix(extentall(l_frno)/2);
    y = y  - fix(extentall(l_frno)/2) * yscale;
    
    %	Construct the subarray and calculate the mass, squared radius of gyration, eccentricity
  clear m
  xcn=xc;
  ycn=yc;
  for j=1:20
    for i=1:nmax
        clear temp temp1
        temp=a(fix(yl(i)):fix(yh(i)),fix(xl(i)):fix(xh(i)));
        
     %filter
      if iffilter>0
        temp1=conv2d(temp,s);
    	temp=temp1;
        clear temp1;
      else temp=temp;
      end
     %end filter
     
        suba(:,:,i) = fracshift( double(temp), -xcn(i) , -ycn(i) );
        clear temp
        m(i) = sum(sum(( suba(:,:,i).*mask )));             % mass
        rg(i) = (sum(sum( suba(:,:,i).*mask3 ))) / m(i);    % squared radius of gyration
        tmp = sqrt(( (sum(sum( suba(:,:,i).*cmask )))^2 ) +( (sum(sum( suba(:,:,i).*smask )))^2 )); 
        tmp2 = (m(i)-suba(cen,ycen,i)+1e-6);
        e(i) = tmp/tmp2;                                    % eccentricity
    end
    for i=1:nmax,
        m(i) = sum(sum(double(suba(:,:,i)).*mask));
        xc(i) = sum(sum(double(suba(:,:,i)).*xmask));  
        yc(i) = sum(sum(double(suba(:,:,i)).*ymask));
    end

    xc = xc./m' - ((extent+1)/2);             
    yc = (yc./m' - (extent+1)/2)/yscale;  %get mass center
    xcn=xc+xcn;
    ycn=yc+ycn;
    x2=x2+xc;
    y2=y2+yc;
  end
    x3 = x2  - fix(extentall(l_frno)/2);
    y3 = ( y2  - fix(extentall(l_frno)/2) ) * yscale;
    
    
    
    r = [x3,y3,sc,Mc,m',rg,e];
    res((totalno+1):(totalno+nmax),:)=r;
    totalno=totalno+nmax;
    clear r suba
   else continue
   end
  else continue
  end
    
   
end
%disp([num2str(length(res(:,1))) ' particles kept.'])
end

