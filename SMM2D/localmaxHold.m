function [r]= localmaxHold(a,b,RR,sepall,extentall)
%find local maxmal for polydisperse systems
%this subfunction is used in featureH.m

%disp('Locating possible particles...');
lf=length(RR);
pad=fix((extentall(:,lf)/2));
hash=b;
clear b
allmin = min(a(:));
allmax = max(a(:));
a(1,1) = allmin;        
a=fix(((255.0+1)*single(a-allmin)-1)/single(allmax-allmin));
allmin = a(1,1);			
[nx, ny]= size(a);
bignum = nx*ny;



    r = -1;
    f = -1;
    M = -1;
    
% start to find local maximum from smallest size

for k=1:lf
    
    extent=extentall(k);
    sep=sepall(k);
    rsq = rsqd(extent,extent);
    mask = rsq < sep^2;

% cast the mask into a one dimensional form-- imask!
    bmask = zeros(nx,ny);
    bmask(1:extent,1:extent) = mask;
    imask = find(bmask > 0) + bignum -(nx*fix((extent/2))) -fix(extent/2);
    
% let's try Eric's hash table concept.----------------------------------

%select intereted size by making other to the minimum
    r_other=find(hash~=single(RR(k)));
    clear temp
    temp=a;
    temp(r_other)=allmin;
    
% set percentile to 0. if you want ever voxel to be a potential maximum
% set it to 0.8 or so if you have lots of tiny spikes, to run faster    
    percentile = 0;
    clear ww nww 
    ww = find(temp > allmin);
    nww=length(ww); 
    [junk,ss] = sort(temp(ww)); 
    s = ww(ss(fix(percentile*nww)+1:end)); 
    s = [fliplr(s'),1]; % so it knows how to stop!, since a(1) contains the minimum intensity
    idx = 1; 
    rr = s(idx); 
    m = temp(rr);

    erwidx=length(s);
    
 if erwidx>1
  while 1
        % get the actual local max in a small mask
        indx= mod(rr+imask-2,bignum)+1;  
        %indx=indx(indx~=rr);
        [actmax,id] = max(a(indx(:)));
        
        % if our friend is a local max, then nuke out the big mask, update r
    if m >= actmax
        r = [r,rr];
        f = [f,RR(k)];
        M = [M,m];
        hash(indx) = 0;
        
       
    else
        
        w = find(a(indx) < m);
        nw=length(w);
            if nw > 0 
            indx2= mod(rr+imask(w)-2,bignum)+1;
            hash(indx2) = 0; 
            end
     
    end

    % get the next non-nuked id
    while 1  
    idx = idx+1;
        if hash(s(idx)) ==single(RR(k)) || idx >= erwidx
             break, end
    end
        if (idx < erwidx) 
            rr = s(idx);
            m = temp(s(idx));
        else
            m = allmin;
        end
    if (m <= allmin), break, end
  end
 else continue
 end

end

if numel(r) > 1 
    r = r(2:end);
    f = f(2:end);
    M = M(2:end);
else
    r=-1;
    f=-1;
    M=-1;
end

y = mod(r-1,nx)+1;
x = fix((r-1) / nx+1); 
w=find(x>pad & x<ny-pad-1 & y>pad & y<nx-pad-1 );
clear r;
nw=length(w);
if nw > 0 
    r = [x(w)' y(w)' f(w)' M(w)'];
    %disp([num2str(nw) ' possible particles found.']);
else
    r=-1; 
    %disp('No particle found!')
end
    
    
end
    
    
    	