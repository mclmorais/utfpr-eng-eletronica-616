clear; clc
g = imread('assets/img_014.png');
g = mat2gray(rgb2gray(g));
subplot(2,2,1); imshow(g);

t = adaptthresh(g, 'NeighborhoodSize', 3, 'Statistic', 'gaussian', 'ForegroundPolarity', 'bright');
subplot(2,2,2), imshow(t);
 gbw = imbinarize(g, t);
 subplot(2,2,3), imshow(gbw);

%imshow(gbw)
gero = majorityErosion(gbw, 1);
% imshow(gero)
 subplot(2,2,4), imshow(mat2gray(gero));