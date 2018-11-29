function [HalfNoteHeight, NumStaffSegs, peaks] = staffspace(grayimg)
    % Pre-Processing
    BW = grayimg > graythresh(grayimg);
    BW = bwmorph(BW, 'skeleton');

    % Horizontal projection
    HorizontalSum = sum(BW, 2);
    [pks, locs] = findpeaks(HorizontalSum);
    map = pks > 0.4*max(pks);
    locs = locs .* map;
    peaks = locs(locs ~= 0);
    NumStaffSegs = size(peaks,1) / 5;
    HalfNoteHeight = ((peaks(5,1) - peaks(1,1)))/8;
end