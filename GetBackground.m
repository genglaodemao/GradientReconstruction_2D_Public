%Average images without particle to get the background. This is useful if
%the field of view has some background patterns (e.g. from dirt in the light path)
%Chi Zhang, Physics department, Fribourg University, Switzerland
%chi.zhang2@unifr.ch
%Oct, 2023
clear
currentFolder = pwd;
path=[currentFolder '\Images\BG\'];
N = 1000;
BG=zeros(82,102);
for id = 1 : N
    disp(id);
    name=['at' num2str(id,'%06i') '.tif'];
    im=imread([path name]);
    im=double(im);
    BG=BG+im/N;
    clear im
end
cd(path)
cd ..
save('BG.mat','BG');