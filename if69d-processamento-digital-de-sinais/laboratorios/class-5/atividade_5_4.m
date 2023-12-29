clear all;
close all;
clc;

%Exercicio 5

I1 = imread('b5s.40.bmp');
I2 = imread('b5s.100.bmp');

%Filtro da média
H = fspecial('average', [5 5]);
G = fspecial('gaussian',[5 5], 1);

I1H = imfilter(I1, H, 'symmetric');
I1G = imfilter(I1, G, 'symmetric');
I2H = imfilter(I2, H, 'symmetric');
I2G = imfilter(I2, G, 'symmetric');

subplot(1,3,1);
imshow(I1);
title('original');
subplot(1,3,2);
imshow(I1H);
title('média 5x5');
subplot(1,3,3);
imshow(I1G);
title('Gaussiano');

figure

subplot(1,3,1);
imshow(I2);
title('original');
subplot(1,3,2);
imshow(I2H);
title('média 5x5');
subplot(1,3,3);
imshow(I2G);
title('Gaussiano');