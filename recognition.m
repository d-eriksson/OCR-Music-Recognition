%% Pre-requisites
% Load image ( and invert it )
close all
grayimg = rgb2gray(im2double(imread('im5s.jpg'))).*(-1)+1;

%% Perform automatic rotation
grayimg = autorotate(grayimg);

%% Define size of staff segments (find absolute size measurement)
[HalfNoteHeight, NumStaffSegs, peaks] = staffspace(grayimg);

%% Morphological operations

BW = bwmorph(BW, 'open');

%% Creating a labeling matrix from the image
L = bwlabel(BW);

cc = bwconncomp(BW);
STATS = regionprops(L,'Area','Eccentricity');
idx = find([STATS.Area] > 80 & [STATS.Eccentricity] < 0.8); 
BW2 = ismember(labelmatrix(cc), idx);
figure
imshow(BW2);

DOTS = bwlabel(BW2);
DOTSSTATS = regionprops(DOTS,'centroid');
centroids = cat(1, DOTSSTATS.Centroid);
hold on
plot(centroids(:,1), centroids(:,2), 'b*')
hold off

%% Find stafflines and their location

STR = generate_string(centroids, HalfNoteHeight, NumStaffSegs, peaks);
