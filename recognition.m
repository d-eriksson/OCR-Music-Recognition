%% Pre-requisites
% Load image ( and invert it )
close all
clear
grayimg = rgb2gray(im2double(imread('im1s.jpg'))).*(-1)+1;

%% Perform automatic rotation
grayimg = autorotate(grayimg);

%% Define size of staff segments (find absolute size measurement)
[HalfNoteHeight, NumStaffSegs, peaks] = staffspace(grayimg);

centroids = FindNotePositions(grayimg,HalfNoteHeight);

[centroids, STEMS] = FindEights(grayimg, centroids, HalfNoteHeight);

centroids = FindSingleNotes(centroids, STEMS, HalfNoteHeight, grayimg);

%% Find stafflines and their location

STR = generate_string(centroids, HalfNoteHeight, NumStaffSegs, peaks);