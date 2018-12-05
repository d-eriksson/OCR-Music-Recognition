function centroids2 = FindSingleNotes(centroids, STEMS, HalfNoteHeight, grayimg)
    % Copy opriginal matrixuxs
    centroids2 = centroids;

    % Filter out all centroids that are not alone
    centroids(centroids(:, 3)~= 0, :)= [];
    stem_centroids = zeros(size(centroids, 1), 2);
    
    SE_select_thick_lines = strel('rectangle', [10 4]);
    thick_lines = imopen(STEMS, SE_select_thick_lines);
    STEMS = logical(STEMS - thick_lines);
    
    
    % Determine sub image size
    width = 1.5*HalfNoteHeight;
    height = 7*HalfNoteHeight;
    
    for i = 1:size(centroids, 1)
        % Define the subimage
        subimg_begin_y = round(centroids(i,2)-height);
        subimg_begin_x = round(centroids(i,1)-width);
        subimg_end_y = round(centroids(i,2)+height);
        subimg_end_x = round(centroids(i,1)+width);
        % Create a subimage around the note head
        subimagemat = STEMS(subimg_begin_y:subimg_end_y, subimg_begin_x:subimg_end_x);
        % Find all note stems  in the subimage
        STATS = regionprops(logical(bwlabel(subimagemat)), 'centroid');
        
        % If only one stem is found (most cases)
        if(size(STATS, 1) == 1)
        % Add the origin of the subimage and the position of the stem in the subimage
            stem_centroids(i, 1:2) = [subimg_begin_x + STATS(1).Centroid(1), subimg_begin_y + STATS(1).Centroid(2)];

        % If more than one stem is found:
        elseif(size(STATS, 1)>1)
            % Measure the x-distance to the discovered stems
            for j = 1:size(STATS, 1)
                distance(j) = norm(STATS(j).Centroid-centroids(i));
            end
            % Find index of the minimum distance from STATS
            [~, mindistindex] = min(distance);
            % Select the centroid from STATS with shortest x-distance
            stem_centroids(i) = STATS(mindistindex).Centroid;
        % If no stem is found
        elseif(size(STATS, 1) == 0)
            % Shouldn't happen, but typically means a whole note was found
        end
    end
    
    % Create BW
    BW = grayimg > graythresh(grayimg);
    mn2 = [3 1];
    SE_FLAGS = strel('rectangle', mn2);
    FLAGS = imopen(BW, SE_FLAGS);
    
    R = round(HalfNoteHeight);
    if(mod(R,2) ~= 0)
        R = R-1;
    end
    SE_NOTEHEADS = strel('disk', R);
    NOTEHEADS = imopen(BW, SE_NOTEHEADS);
    
    % Create the filtered BW image
    BW_new = FLAGS-NOTEHEADS;
    
    % Determine subimage size
    width = 4*HalfNoteHeight;
    height = 6*HalfNoteHeight;
    margin = 2*HalfNoteHeight;
    
    for i = 1:size(stem_centroids,1)
        % If stem is up
        if(stem_centroids(i,2)-centroids(i,2) < 0)
            % Determine position of subimage
            subimg_begin_y = round(centroids(i,2) - height);
            subimg_begin_x = round(centroids(i,1));
            subimg_end_y = round(centroids(i,2) - margin);
            subimg_end_x = round(centroids(i,1) + width);
        else
            % Determine position of subimage
            subimg_begin_y = round(centroids(i,2) + margin);
            subimg_begin_x = round(centroids(i,1) - margin);
            subimg_end_y = round(centroids(i,2) + height);
            subimg_end_x = round(centroids(i,1) + 0.5*width);
        end
        
        % Create the subimage
        subimage = BW_new(subimg_begin_y:subimg_end_y, subimg_begin_x:subimg_end_x);
        
        % Vertical Projection
        VerticalSum = sum(subimage, 1);
        HorizontalSum = sum(subimage, 2);
        
        % Find how many peaks
        [pksvert, ~] = findpeaks(VerticalSum, 'MinPeakHeight', 0.5*size(subimage,1));
        
        % If one peak, it's a fourth, if two peaks, a eighth
        if(size(pksvert, 2) == 1)
            centroids(i, 3) = 4;
        elseif(size(pksvert, 2) == 2)
            centroids(i, 3) = 8;
        end
    end

    centroids2(centroids2(:,3) == 0, :) = centroids;
    
end