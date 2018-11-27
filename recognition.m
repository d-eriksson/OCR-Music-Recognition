%% Pre-requisites
% Load image ( and invert it, only to make the extra rotation work for
% testing purposes)
close all
grayimg = rgb2gray(im2double(imread('im5s.jpg'))).*(-1)+1;
% Convert image to BW
BW = grayimg > graythresh(grayimg);

%% Morphological operations

BW = bwmorph(BW, 'open');
%SE =[1, 1, 1, 1;
%    1, 0, 0, 1;
%    1, 0, 0, 1;
%    1, 1, 1, 1];
%BW = conv2(BW, SE);


imshow(BW);

%% Creating a labeling matrix from the image
L = bwlabel(BW);

figure
imshow(L./256)
colormap colorcube

cc = bwconncomp(BW);
STATS = regionprops(L,'Area','Eccentricity');
idx = find([STATS.Area] > 80 & [STATS.Eccentricity] < 0.8); 
BW2 = ismember(labelmatrix(cc), idx);
figure
imshow(BW2);

DOTS = bwlabel(BW2);
DOTSSTATS = regionprops(DOTS,'centroid');
centroids = cat(1, DOTSSTATS.Centroid);
imshow(BW2)
hold on
plot(centroids(:,1), centroids(:,2), 'b*')
hold off
