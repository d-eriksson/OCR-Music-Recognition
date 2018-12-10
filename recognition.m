%% Pre-requisites
% Load image ( and invert it )
close all
clear

grayimg = rgb2gray(im2double(imread('im1s.jpg'))).*(-1)+1;

% Perform automatic rotation
grayimg = autorotate(grayimg);

%% All major identification steps
% Find stafflines and define size of staff segments (absolute measurement)
[HalfNoteHeight, NumStaffSegs, peaks] = staffspace(grayimg);

% Find the positions of all notes
centroids = FindNotePositions(grayimg,HalfNoteHeight);

% Identify all notes that are grouped together
[centroids, STEMS] = NoteGroupIdentify(grayimg, centroids, HalfNoteHeight);

% Identify all notes that are not grouped
centroids = FindSingleNotes(centroids, STEMS, HalfNoteHeight, grayimg);

% Plot the identified notes over the original (rotated) image
imshow(grayimg)
hold on
plot(centroids(centroids(:,3)==0,1),centroids(centroids(:,3)==0,2),'oc');
    plot(centroids(centroids(:,3)==4,1),centroids(centroids(:,3)==4,2),'xm');
    plot(centroids(centroids(:,3)==8,1),centroids(centroids(:,3)==8,2),'+b');
    plot(centroids(centroids(:,3)==16,1),centroids(centroids(:,3)==16,2),'*r');
hold off

%% Generate a string and play the notes
[STR,Notething] = generate_string(centroids, HalfNoteHeight, NumStaffSegs, peaks);

if(false)
    PlayMusic(Notething,40);
end