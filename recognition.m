%% Pre-requisites
% Load image ( and invert it )
close all
clear
grayimg = rgb2gray(im2double(imread('im13s.jpg'))).*(-1)+1;

%% Perform automatic rotation
grayimg = autorotate(grayimg);

%% Define size of staff segments (find absolute size measurement)
[HalfNoteHeight, NumStaffSegs, peaks] = staffspace(grayimg);

centroids = FindNotePositions(grayimg,HalfNoteHeight);

imshow(grayimg)
hold on
plot(centroids(:,1), centroids(:,2), 'b*')
hold off
%% Find stafflines and their location

STR = generate_string(centroids, HalfNoteHeight, NumStaffSegs, peaks);