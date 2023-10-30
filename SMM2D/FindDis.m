function [Dis] = FindDis(im)
% find distance of 2 particles with bootstrap method and Gaussian fit.
[ny,nx] = size(im);
Mass = 1000;
I = im(:)/sum(im(:))*Mass;
Pool = zeros(length(I),1);
for i = 1 : length(I) 
Pool(i) = sum(I(1:i));
end

% creat replica images
R = rand(Mass,1)*Mass;
ID = zeros(Mass,3);
for i =1 : Mass
    r = find(Pool >= R(i));
    ID(i,1) = r(1);
    ID(i,2) = floor((ID(i,1)-1)/ny)+1+rand(1,1)-0.5;
    ID(i,3) = mod(ID(i,1)-1,ny)+1+rand(1,1)-0.5;
end
X=ID(:,2);
%
numberOfClusters = 2;
[~,kMeansClusters] = kmeans(X,numberOfClusters);
% Fit GMM using the k-means centers as the initial conditions
% We only have mean initial conditions from the k-means algorithm, so we
% can specify some arbitrary initial variance and mixture weights.
gmInitialVariance = 0.1;
initialSigma = cat(3,gmInitialVariance,gmInitialVariance);
% Initial weights are set at 50%
initialWeights = [0.5 0.5];
% Initial condition structure for the gmdistribution.fit function
S.mu = kMeansClusters;
S.Sigma = initialSigma;
S.PComponents = initialWeights;
%'MaxIter',1000
options = statset('MaxIter',1000);
obj = gmdistribution.fit(X,2,'Start',S,'Options',options);
Dis=abs(obj.mu(1)-obj.mu(2));
% scatter(X(:,1),X(:,2),10,'o');





end