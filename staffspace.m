function [HalfNoteHeight, NumStaffSegs, peaks] = staffspace(grayimg)
    % Pre-Processing
    BW = grayimg > graythresh(grayimg);
    SE_horline = strel('line', 20, 0);
    BW = imopen(BW, SE_horline);
    SE_rect = strel('rectangle', [3,15]);
    BW2 = imopen(BW, SE_rect);
    BW = BW - BW2;
    
    % Horizontal Projection
    HorizontalSum = sum(BW, 2);
    HorizontalSumSmooth = smoothdata(HorizontalSum,'movmean', length(HorizontalSum)/10);
    [pks, locs_smooth, w] = findpeaks(HorizontalSumSmooth);
    
    % Remove narrow peaks
    map_width_height_filter = w >= 0.05*size(BW,1) & pks>0.2*max(pks);
    pks_width_filtered = pks .* map_width_height_filter;
    pks_width_filtered = pks_width_filtered(pks_width_filtered ~= 0);
%    locs_smooth_filtered = locs_smooth .* map_width_height_filter;
%    locs_smooth_filtered = locs_smooth_filtered(locs_smooth_filtered ~= 0);
    
%     plot(HorizontalSumSmooth)
%     hold on
%     for i = 1:length(pks_width_filtered)
%         plot(locs_smooth_filtered(i), pks_width_filtered(i), 'ob')
%     end
    
%     % Calculate median smoothed peak distance (could be useful)
%     peak_distances = zeros(length(locs_smooth_filtered)-1, 1);
%     for i = 1:length(peak_distances)
%         peak_distances(i,1) = locs_smooth_filtered(i+1)-locs_smooth_filtered(i);
%     end
%     approx_staff_seg_distance = median(peak_distances);
    
    % Calculate number of staff lines
    NumStaffSegs = length(pks_width_filtered);
    NumStaffLines = NumStaffSegs*5;
    
    % Select the number of peaks we have staff lines and store in "peaks"
    [pks, locs] = findpeaks(HorizontalSum);
    pks_sorted = sort(pks, 'descend');
    map = pks >= pks_sorted(NumStaffLines);
    locs_result = locs .* map;
    peaks = locs_result(locs_result ~= 0);
    
    % Calculate average distance for a half note from first segment
    HalfNoteHeight = ((peaks(5,1) - peaks(1,1)))/8;
    
end