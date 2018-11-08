close all
img = imread('im5s.jpg');
img = im2double(img);
[strout, BW]  = tnm034(img);