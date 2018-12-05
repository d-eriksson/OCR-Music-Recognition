close all
grayimg = rgb2gray(im2double(imread('im1s.jpg'))).*(-1)+1;
level = graythresh(grayimg);
BW = grayimg > level;
figure
imshow(BW);
se = strel('disk', 4);
BW2 = imopen(BW,se);
%BW = BW - BW2;
HalfNoteHeight=4.75;

VerticalSum = sum(BW, 1); % Change to 1 for columns
[pks, locs] = findpeaks(VerticalSum);
map = pks > 0.03*size(BW,1);
locs = locs .* map;
locs = locs(locs ~= 0);
BW(:, 1:round(locs(1,1)+HalfNoteHeight*10)) = 0;


mn = [4,30];
STRAIGHTFLAGS_SE = strel('rectangle',mn);
STRAIGHTFLAGS = imopen(BW, STRAIGHTFLAGS_SE);

STEMS_SE = strel('line', 10, 90);
STEMS = imopen(BW, STEMS_SE);

STAFFLINES_SE = strel('line',5,0);
STAFFLINES = imopen(BW, STAFFLINES_SE);

NOTEHEADS_SE = strel('disk', 4);
NOTEHEADS = imopen(BW,NOTEHEADS_SE);

mn2 = [3,1];
FLAGS_SE = strel('rectangle', mn2);
FLAGS = imopen(BW, FLAGS_SE);

figure
imshow(FLAGS);
%imshow(NOTEHEADS + STEMS);
BW3 = FLAGS + STEMS + NOTEHEADS;

% st = regionprops(logical(BW3), 'Area');
% idx = find([st.Area] > HalfNoteHeight*HalfNoteHeight*25); 
% FILTEREDIMG = ismember(labelmatrix(bwconncomp(BW3)), idx);
% STATS = regionprops(logical(FILTEREDIMG),'BoundingBox');
% % NotePositions = cat(1, DOTSSTATS.Centroid);
% 
% %imshow(STEMS + NOTEHEADS + STRAIGHTFLAGS );
% imshow(BW3);
% hold on
% for i = 1:size(STATS,1)
%     rectangle('Position',[STATS(i).BoundingBox(1) - 2*HalfNoteHeight,STATS(i).BoundingBox(2)- 2*HalfNoteHeight,STATS(i).BoundingBox(3)+ 4*HalfNoteHeight,STATS(i).BoundingBox(4)+4*HalfNoteHeight], 'EdgeColor','r','LineWidth',2 )
% end
% hold off
%%
