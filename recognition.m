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

[centroids, STEMS] = NoteGroupIdentify(grayimg, centroids, HalfNoteHeight);
centroids = FindSingleNotes(centroids, STEMS, HalfNoteHeight, grayimg);


imshow(grayimg)
hold on
    plot(centroids(centroids(:,3)==4,1),centroids(centroids(:,3)==4,2),'xm');
    plot(centroids(centroids(:,3)==8,1),centroids(centroids(:,3)==8,2),'+b');
    plot(centroids(centroids(:,3)==16,1),centroids(centroids(:,3)==16,2),'*r');
hold off
%% Find stafflines and their location

[STR,Notething] = generate_string(centroids, HalfNoteHeight, NumStaffSegs, peaks);
if(false)
    PlayMusic(Notething);
end