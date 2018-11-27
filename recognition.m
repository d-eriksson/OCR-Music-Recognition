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
grayimg = autorotate(grayimg);

BW123 = grayimg > graythresh(grayimg);
BW123 = bwmorph(BW123, 'skeleton');
numberOfOnesPerRow = sum(BW123, 2); % Change to 1 for columns
[pks, locs] = findpeaks(numberOfOnesPerRow);
map = pks > 350;
locs = locs .* map;
peaks = locs(locs ~= 0);
NUMBEROFSEGS = size(peaks,1) / 5;
StaffSize = ((peaks(5,1) - peaks(1,1))+(peaks(10,1) - peaks(6,1))+(peaks(15,1) - peaks(11,1)))/24;
%% Find location of notes
NoteMapFourth =["E4",-6;"D4",-5;"C4",-4;"B3",-3;"A3",-2;"G3", -1 ;"F3",0 ; "E3",1 ; "D3",2 ; "C3", 3; "B3", 4 ;
          "A3", 5; "G2" , 6; "F2",7; "E2",8; "D2",9 ; "C2", 10; "B2", 11 ; "A2", 12; "G2", 13; "F2", 14; "E2", 15;
          "D2", 16; "C2", 17; "B1",18; "A1",19; "G1", 20];
NoteMapEight =["e4";"d4";"c4";"b3";"a3";"g3";"f3"; "e3"; "d3";
                "c3"; "b3";"a3"; "g2"; "f2"; "e2"; "d2"; "c2"; "b2"; "a2"; "g2"; "f2"; "e2";"d2";
                "c2"; "b1"; "a1"; "g1"];
INDEXNOTEMAP = (-6:20)';
%for  NOTE = 1:size(centroids,1)
%    centroid(NOTES,1) - peaks(1,1);
%    centroid(NOTES,1) - peaks(6,1);
%    centroid(NOTES,1) - peaks(11,1);
%end

DistMap = zeros(size(centroids,1),NUMBEROFSEGS);
DistMap(:,1) = peaks(1,1) - centroids(:,2);
DistMap(:,2) = peaks(6,1) - centroids(:,2);
DistMap(:,3) = peaks(11,1) - centroids(:,2);
[DistMap, ind] = min(abs(DistMap), [], 2);
DistMap(:,2) = ind;
Notething = round(DistMap(:,1) ./StaffSize);
Notething(:,2) = ind;
Notething = sortrows(Notething,2);


