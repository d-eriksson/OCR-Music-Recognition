function [STR] = generate_string(grayimg, centroids)
    %% Find stafflines and their location
    BW = grayimg > graythresh(grayimg);
    BW = bwmorph(BW, 'skeleton');
    HorizontalSum = sum(BW, 2); % Change to 1 for columns
    [pks, locs] = findpeaks(HorizontalSum);
    map = pks > 350;
    locs = locs .* map;
    peaks = locs(locs ~= 0);
    NumStaffSegs = size(peaks,1) / 5;
    HalfNoteHeight = ((peaks(5,1) - peaks(1,1)))/8;
    %% Find location of notes
    load Eights;
    INDEXNOTEMAP = (-9:20)';
 
    DistMap = [centroids(:,2) - peaks(1,1), centroids(:,2) - peaks(6,1), centroids(:,2) - peaks(11,1)];
    
    [~, ind] = min(abs(DistMap), [], 2);
    for k = 1:size(DistMap,1)
        TempDistMap(k,1) = DistMap(k,ind(k,1));
    end
    DistMap = TempDistMap;
    DistMap(:,2) = ind;
    Notething = round(DistMap(:,1) ./HalfNoteHeight);
    Notething(:,2) = ind;
    Notething = sortrows(Notething,2);
    for i = 1:size(Notething(:,1))
        X = find(INDEXNOTEMAP == Notething(i,1));
        STR(i) = Eights(X); 
    end
end