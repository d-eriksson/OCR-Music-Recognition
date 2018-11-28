function NotePositions = FindNotePositions(BW)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
BW = bwmorph(BW, 'open'); % Morph image with open filter
STATS = regionprops(bwlabel(BW),'Area','Eccentricity');
idx = find([STATS.Area] > 80 & [STATS.Eccentricity] < 0.8); 
BW2 = ismember(labelmatrix(bwconncomp(BW)), idx);

DOTSSTATS = regionprops(bwlabel(BW2),'centroid');
NotePositions = cat(1, DOTSSTATS.Centroid);
end

