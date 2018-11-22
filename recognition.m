%% Pre-requisites
% Load image ( and invert it, only to make the extra rotation work for
% testing purposes)
grayimg = rgb2gray(im2double(imread('im5s.jpg'))).*(-1)+1;
% Convert image to BW
BW = grayimg > graythresh(grayimg);

%% Morphological operations

BW = bwmorph(BW, 'open');
%SE = [-1,1,-1;-1,1,-1;-1,1,-1];
%BW = conv2(BW, SE);

imshow(BW)

%% Creating a labeling matrix from the image
L = bwlabel(BW);

figure
imshow(L./256)
colormap colorcube