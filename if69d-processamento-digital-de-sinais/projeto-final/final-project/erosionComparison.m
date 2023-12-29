clear; clc

g = imbinarize(rgb2gray(imread('pdf/Page-3-Image-3.png')));

% y =g_ero & 107;
% x = 335;
% g = g(y:y+9, x:x+9);

g_comp = imbinarize(rgb2gray(imread('pdf/Page-3-Image-4.png')));
% g_comp = g_comp(y:y+9, x:x+9);


g_ero = imbinarize(majorityErosion(g, 3));



% subplot(2, 3, 1), imshow(g);
subplot(1, 2, 1), imshow(g_comp);
subplot(1, 2, 2), imshow(g_ero & g);
% subplot(2, 3, 4), imshow(g_comp - g_ero);