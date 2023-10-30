function []=ParRun_2p2D_Golden_fun(imagepath,folder,BG,gr,Rguess,Rreal,Intensity,Rangey,Rangex,Gkernel,Rcut,codepath,M,N)
%two particle
cd(codepath);
%
mkdir respar2p
%
addpath([codepath 'SMM2D'])
addpath([codepath 'parfunc'])
addpath([codepath 'Gradient'])
addpath([codepath 'Runme'])
addpath([codepath 'SubM'])

tic
checkfile=1;
disp(['Folder ' folder ' is now running, number of images ' num2str(N) '.']);
for circles = 1 : M
    IDstart = (circles-1)*N+1;
    IDend=circles*N;
parfor id = IDstart : IDend
folder1 = 'respar2p\';
if checkfile
    filename=[codepath folder1 folder '_Gradient_rfinal_temp' num2str(id,'%06i') '.mat'];    
    if isfile(filename)
    disp(['Results of image ' num2str(id) ' already exist, skipping...']);
    ifdo=0;
    else
    ifdo=1;
    end
else
    ifdo=1;
end
if ifdo
    if mod(id,100)==1
    disp(['current processing ' num2str(id) '...']);
    end

    name=['at' num2str(id,'%06i') '.tif'];
    % disp(name);
    try
        im=imread([imagepath folder '.nd2\' name]); 
    catch ME
        ME
        disp(ME.message)
        disp(id)
        continue 
    end
    im=double(im)-BG;
    im=im(Rangey(1):Rangey(2),Rangex(1):Rangex(2));
    im=im-min(im(:));
    im=im/max(im(:))*255;
    if Gkernel>0
    [im]=conv2d(im,Gkernel);
    end%
    [imgr,PosGuess] = prepGolden_2p(im,Rguess,Rreal,Intensity);
    PosStep=[0.1,0.1,0.1,0.1;0.1,0.1,0.1,0.1];
%%
    [res1] = GoldenSectionSearch_Gradient(imgr,gr,PosGuess,Rcut,PosStep);
   parsave(codepath,folder1,folder, id, res1);
end
end
end
time = toc;
disp(['total time:' num2str(time/3600) 'hours'])

cd([codepath 'respar2p\'])
ALLres = [];
a = dir(pwd); 
N = length(a);
for id = 3 : N
    name=[a(id).name];
    load(name);
    ALLres(2*id,:) = res(1,:);
    ALLres(2*id-1,:) = res(2,:);
%     ALLres(id,5) = num2str(id,'%05i');
%     if mod(id,1000)==0
%         disp(['percentage advanced ' num2str(100*(id)/N) '%'])
%     end
end
ALLres = ALLres(5:end,:);
cd(imagepath);
save([folder '_2D.mat'], 'ALLres')
cd(codepath);
rmdir respar2p s
end