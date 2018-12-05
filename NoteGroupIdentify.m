
function [centroids, STEMS] = NoteGroupIdentify(grayimg, centroids, HalfNoteHeight)
level = graythresh(grayimg);
BW = grayimg > level;

VerticalSum = sum(BW, 1); % Change to 1 for columns
[pks, locs] = findpeaks(VerticalSum);
map = pks > 0.03*size(BW,1);
locs = locs .* map;
locs = locs(locs ~= 0);
BW(:, 1:round(locs(1,1)+HalfNoteHeight*10)) = 0;

STEMS_SE = strel('line', 20, 90);
STEMS = imopen(BW, STEMS_SE);
R = round(HalfNoteHeight*1.5);
if mod(R,2) ~= 0
    R = R + 1;
end
NOTEHEADS_SE = strel('disk', R);
NOTEHEADS = imopen(BW,NOTEHEADS_SE);
ENLARGE = strel('disk', R);
NOTEHEADS = imdilate(NOTEHEADS,ENLARGE);

mn = [3,4];
FLAGS_SE = strel('rectangle', mn);
FLAGS = imopen(BW - NOTEHEADS, FLAGS_SE);
BW3 = FLAGS + STEMS + NOTEHEADS;
BW3 = bwmorph(BW3, 'bridge');


st = regionprops(logical(BW3), 'Area');
idx = find([st.Area] > HalfNoteHeight*HalfNoteHeight*10); 
FILTEREDIMG = ismember(labelmatrix(bwconncomp(BW3)), idx);
STATS = regionprops(logical(FILTEREDIMG),'BoundingBox');

BW3 = FLAGS;
centroids(:,3) = zeros(length(centroids),1);
for i = 1:size(STATS,1)
    %rectangle('Position',[STATS(i).BoundingBox(1) - HalfNoteHeight,STATS(i).BoundingBox(2)- HalfNoteHeight,STATS(i).BoundingBox(3)+ 2*HalfNoteHeight,STATS(i).BoundingBox(4)+2*HalfNoteHeight], 'EdgeColor','r','LineWidth',2 )
    %I = centroids(:,1) > STATS(i).BoundingBox(1) & centroids(:,1) < STATS(i).BoundingBox(1)- HalfNoteHeight + STATS(i).BoundingBox(3)+ 2*HalfNoteHeight & centroids(:,2)
    LEFT = STATS(i).BoundingBox(1)- HalfNoteHeight;
    RIGHT = LEFT + STATS(i).BoundingBox(3)+ 2*HalfNoteHeight;
    UP = STATS(i).BoundingBox(2)-HalfNoteHeight;
    DOWN = UP + STATS(i).BoundingBox(4)+ 2*HalfNoteHeight;
    I = centroids(:,1) > LEFT & centroids(:,1) < RIGHT & centroids(:,2) > UP & centroids(:,2) < DOWN;   
    AMOUNT = size(I(I~=0),1);
    TMP =[centroids(I,1) - LEFT,centroids(I,2)-UP];
    Index = find(I);
    for k = 1:AMOUNT-1
        VerticalSum = sum(BW3(round(UP):round(DOWN), round(TMP(k,1) +(abs(TMP(k,1) - TMP(k+1,1))/2 -HalfNoteHeight/2)+LEFT): round(TMP(k,1) +abs(TMP(k,1) - TMP(k+1,1))/2 + HalfNoteHeight/2+LEFT)),1);
        if(mean(VerticalSum) < HalfNoteHeight *1.5)
            if(centroids(Index(k),3) ~= 16)
                centroids(Index(k),3) = 8;
            end
            if(k+1 == AMOUNT)
                centroids(Index(k+1),3) = 8;
            end
        else
            centroids(Index(k),3) = 16;
            centroids(Index(k+1),3) = 16;
        end    
    end
%     figure
%     imshow(BW3(UP:DOWN, LEFT:RIGHT));
%     hold on
%     plot( centroids(I,1) - LEFT,centroids(I,2) -UP, '*b');
%     hold off

end

%rectangle('Position',[STATS(1).BoundingBox(1) - HalfNoteHeight,STATS(1).BoundingBox(2)- HalfNoteHeight,STATS(1).BoundingBox(3)+ 2*HalfNoteHeight,STATS(1).BoundingBox(4)+2*HalfNoteHeight], 'EdgeColor','b','LineWidth',2 )

hold off

end

