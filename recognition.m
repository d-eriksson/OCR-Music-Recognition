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

centroids = NoteGroupIdentify(grayimg, centroids, HalfNoteHeight);
figure;
imshow(grayimg)
hold on
plot(centroids(centroids(:,3)==0,1),centroids(centroids(:,3)==0,2),'om');
plot(centroids(centroids(:,3)==8,1),centroids(centroids(:,3)==8,2),'+b');
plot(centroids(centroids(:,3)==16,1),centroids(centroids(:,3)==16,2),'*r');
hold off
%% Find stafflines and their location

STR = generate_string(centroids, HalfNoteHeight, NumStaffSegs, peaks);