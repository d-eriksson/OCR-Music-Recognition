function rotimg = autorotate(grayimg)
% Conversion to binary using Osus' method
level = graythresh(grayimg);
BW1 = grayimg > level;

% Hough transform, hough peaks, hough lines
[H, T, R] = hough(BW1, 'RhoResolution',0.5, 'theta', -90:0.5:89);
P = houghpeaks(H, 2);
L = houghlines(BW1, T, R, P);

% Rotate by the median line angle
median_theta = median([L.theta]);
if(median_theta > 0)
    angle_hough = median_theta-90;
else
    angle_hough = 90+median_theta;
end

rotimg = imrotate(grayimg, angle_hough, 'bicubic');
end