function final_image = autorotate(grayimg)
% Conversion to binary using Osus' method
level = graythresh(grayimg);
BW1 = grayimg > level;

% Hough transform, hough peaks, hough lines
[H, T, R] = hough(BW1, 'RhoResolution', 0.5, 'theta', -90:0.5:89);
P = houghpeaks(H, 4);
L = houghlines(BW1, T, R, P);

% Rotate by the median line angle
median_theta = median([L.theta]);
if(median_theta > 0)
    angle_hough = median_theta-90;
else
    angle_hough = 90+median_theta;
end

% For debugging
rotimg = imrotate(grayimg, angle_hough, 'bicubic');

%% Make fine adjustments to the rotated image

index = 1;
% Angle list is used to fetch the angle once
% we know which index of the loop performed the best
angle_list = -0.5:0.1:0.5;
% Test different rotations and measure the peaks from each rotation
for angle = -0.5:0.1:0.5
    rotimg2 = imrotate(rotimg, angle);
    HorizontalSum = sum(rotimg2 > graythresh(rotimg2), 2);
    [pks, ~] = findpeaks(HorizontalSum);
    
    max_peaks(index) = max(pks);
    
    index = index+1;
end
% Find the index of the loop with the highest peak
[~,max_peak_index] = max(max_peaks);
% Fetch the angle using that index
fine_angle = angle_list(max_peak_index);
% Rotate the final image with hough + fine adjustment
final_image = imrotate(grayimg, angle_hough+fine_angle, 'bicubic');
imshow(final_image)
end