g = imread('../final-project/assets/img_002.png');

% sky & greenery removal
[h, s, v] = rgb2hsv(g);

[row, col, depth] = size(g);
mean_s = mean(s(:));
v = v .* (s <= 0.39);

% 2.15
% v = v .* (v < 0.99);

% 2.3
rgb = hsv2rgb(cat(3, h, s, v));
gray = rgb2gray(rgb);
t = adaptthresh(gray, 'NeighborhoodSize', 199, 'Statistic', 'gaussian', 'ForegroundPolarity', 'bright');
% imshow(t);
% figure(2);

bw = imbinarize(gray, t);


bw = imclose(bw, ones(7));

bw = erosionStep(bw, 3, bw);


% bw = imdilate(bw, [1 1 1; 1 1 1; 0 1 0]);

% bw = imclose(bw, ones(3));
% bw = bwmorph(bw,'skel',1);

%hough

[H,T,R] = hough(bw);

P  = houghpeaks(H,5,'threshold',ceil(0.03*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
lines = houghlines(bw,T,R,P,'FillGap',30,'MinLength',1);
imshow(bw), hold on
max_len = 0;
for k = 1:length(lines)
    
   if(lines(k).theta > 70 || lines(k).theta < -70)
     continue;
   end
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');

   % Plot beginnings and ends of lines
%    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
%    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end


% resultado
% imshow(bw);

