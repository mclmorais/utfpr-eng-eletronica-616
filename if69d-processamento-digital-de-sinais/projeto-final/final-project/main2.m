clc
g = imbinarize(rgb2gray(imread('pdf2/pl_2_1.png')));

g_comp = imbinarize(rgb2gray(imread('pdf2/pl_2_2.png')));
range = 1:400;
 imshow(erosionStep(g(range,range),3, g_comp(range,range)));
% imshow(erosionStep(g, 3, g_comp));
% immatrix = [1 0 1; 0 1 0; 1 0 1]
% imshow(imerode(g, immatrix);