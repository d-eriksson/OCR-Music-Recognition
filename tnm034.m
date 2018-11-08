function [strout, BW] = tnm034(Im)
%
% Im: Input image of captured sheet music. Im should be in 
% double format, normalized to the interval [0,1]
%
% strout: The resulting character string of the detected notes.  
% The string must follow the pre-defined format, explained below.
%
% Your program code
grayImg = rgb2gray(Im);
imshow(grayImg);
level = graythresh(grayImg);
BW = grayImg < level;
klaplace = [-1, -1, -1, -1; 1, 1 ,1 ,1; -1, -1,-1, -1; -1, -1,-1,-1];
BW=conv2(BW,klaplace);
imshow(BW);
figure;

[H, theta, rho] = hough(BW);
imshow(H,[],'XData',theta,'YData',rho,...
            'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = theta(P(:,2)); 
y = rho(P(:,1));
plot(x,y,'s','color','white');


lines = houghlines(BW,theta,rho,P,'FillGap',20,'MinLength',70);
figure, imshow(grayImg), hold on
max_len = 0;
length(lines)
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
strout="unfinished";
