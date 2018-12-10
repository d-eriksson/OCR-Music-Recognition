
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
R = round(HalfNoteHeight);
if mod(R,2) ~= 0
    R = R - 1;
end
NOTEHEADS_SE = strel('disk', R);
NOTEHEADS = imopen(BW,NOTEHEADS_SE);
ENLARGE = strel('disk', R);
NOTEHEADS = imdilate(NOTEHEADS,ENLARGE);

mn = [3,4];
FLAGS_SE = strel('rectangle', mn);
FLAGS = imopen(BW - NOTEHEADS, FLAGS_SE);
BW3 = FLAGS + STEMS + NOTEHEADS;
BW3 = bwmorph(BW3, 'bridge',2);


st = regionprops(logical(BW3), 'Area');
idx = find([st.Area] > HalfNoteHeight*HalfNoteHeight*10); 
FILTEREDIMG = ismember(labelmatrix(bwconncomp(BW3)), idx);
STATS = regionprops(logical(FILTEREDIMG),'BoundingBox');

BW3 = FLAGS-NOTEHEADS;
BW3 = BW3 == 1;
centroids(:,3) = zeros(length(centroids),1);
imshow(BW);
hold on
for i = 1:size(STATS,1)
    rectangle('Position',[STATS(i).BoundingBox(1) - HalfNoteHeight,STATS(i).BoundingBox(2)- HalfNoteHeight,STATS(i).BoundingBox(3)+ 2*HalfNoteHeight,STATS(i).BoundingBox(4)+2*HalfNoteHeight], 'EdgeColor','r','LineWidth',2 )
    %I = centroids(:,1) > STATS(i).BoundingBox(1) & centroids(:,1) < STATS(i).BoundingBox(1)- HalfNoteHeight + STATS(i).BoundingBox(3)+ 2*HalfNoteHeight & centroids(:,2)
    LEFT = STATS(i).BoundingBox(1)- HalfNoteHeight;
    RIGHT = LEFT + STATS(i).BoundingBox(3)+ 2*HalfNoteHeight;
    UP = STATS(i).BoundingBox(2)-HalfNoteHeight;
    DOWN = UP + STATS(i).BoundingBox(4)+ 2*HalfNoteHeight;
    I = centroids(:,1) > LEFT & centroids(:,1) < RIGHT & centroids(:,2) > UP & centroids(:,2) < DOWN;   
    AMOUNT = size(I(I~=0),1);
    TMP =[centroids(I,1) - LEFT,centroids(I,2)-UP];
    Index = find(I);
    HorizontalProjection = sum(BW3(UP:DOWN, LEFT:RIGHT),2);
    HorizontalSumUP = sum(HorizontalProjection(1:round(length(HorizontalProjection)/2)));
    HorizontalSumDOWN = sum(HorizontalProjection(round(length(HorizontalProjection)/2):round(length(HorizontalProjection))));
    
    for k = 1:AMOUNT-1
        if HorizontalSumUP > HorizontalSumDOWN
            % An upper bracket
            %VerticalSum = sum(BW3(round(UP):round(DOWN), round(TMP(k,1) +(abs(TMP(k,1) - TMP(k+1,1))/2 -HalfNoteHeight/2)+LEFT): round(TMP(k,1) +abs(TMP(k,1) - TMP(k+1,1))/2 + HalfNoteHeight/2+LEFT)),1);
            VerticalSum = sum(BW3(round(UP):round(TMP(k,2)-2*HalfNoteHeight+UP), round(TMP(k,1)+1.5*HalfNoteHeight+LEFT):round(TMP(k,1)+3.5*HalfNoteHeight+LEFT),1));
            %imshow(BW3(round(UP):round(TMP(k,2)+HalfNoteHeight), round(TMP(k,1)+HalfNoteHeight):round(TMP(k,1)+2*HalfNoteHeight)));
            plot( round(TMP(k,1)+1.5*HalfNoteHeight+LEFT),round(UP), '+r');
            plot( round(TMP(k,1)+1.5*HalfNoteHeight+LEFT),round(TMP(k,2)-2*HalfNoteHeight+UP), '+r');
            plot( round(TMP(k,1)+3.5*HalfNoteHeight+LEFT),round(UP), '+r');
            plot( round(TMP(k,1)+3.5*HalfNoteHeight+LEFT),round(TMP(k,2)-2*HalfNoteHeight+UP), '+r');
            
        else
            % A lower bracket
            VerticalSum = sum(BW3(round(TMP(k,2)+2*HalfNoteHeight+UP):round(DOWN), round(TMP(k,1)+LEFT):round(TMP(k,1)+1.5*HalfNoteHeight+LEFT),1));
            plot( round(TMP(k,1)+LEFT),round(DOWN), '+g');
            plot( round(TMP(k,1)+LEFT),round(TMP(k,2)+2*HalfNoteHeight+UP), '+g');
            plot( round(TMP(k,1)+1.5*HalfNoteHeight+LEFT),round(DOWN), '+g');
            plot( round(TMP(k,1)+1.5*HalfNoteHeight+LEFT),round(TMP(k,2)+2*HalfNoteHeight+UP), '+g');
        end
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

end

%rectangle('Position',[STATS(1).BoundingBox(1) - HalfNoteHeight,STATS(1).BoundingBox(2)- HalfNoteHeight,STATS(1).BoundingBox(3)+ 2*HalfNoteHeight,STATS(1).BoundingBox(4)+2*HalfNoteHeight], 'EdgeColor','b','LineWidth',2 )

hold off
figure

end

