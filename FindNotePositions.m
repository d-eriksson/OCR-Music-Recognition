function NotePositions = FindNotePositions(grayimg ,HalfNoteHeight)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
level = graythresh(grayimg);
BW = grayimg > level;

VerticalSum = sum(BW, 1); % Change to 1 for columns
[pks, locs] = findpeaks(VerticalSum);
map = pks > 0.03*size(BW,1);
locs = locs .* map;
locs = locs(locs ~= 0);
BW(:, 1:round(locs(1,1)+HalfNoteHeight*10)) = 0;
BW = bwmorph(BW, 'open'); % Morph image with open filter

STATS = regionprops(logical(BW),'Area','Eccentricity');
idx = find([STATS.Area] > HalfNoteHeight*HalfNoteHeight*3 & [STATS.Eccentricity] < 0.8); 
BW2 = ismember(labelmatrix(bwconncomp(BW)), idx);
DOTSSTATS = regionprops(logical(BW2),'centroid');
NotePositions = cat(1, DOTSSTATS.Centroid);
end

