% Load image ( and invert it, only to make the extra rotation work for
% testing purposes)
grayimg = rgb2gray(im2double(imread('im3s.jpg'))).*(-1)+1;

% Extra rotation for testing purposes
%grayimg = imrotate(grayimg, 10, 'bicubic', 'crop');

% The function autorotate identifies the rotation and corrects for it
rotimg = autorotate(grayimg);
imshow(rotimg)

% The next step is to identify musical notes and characters
