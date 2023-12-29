clear all;
close all;
clc;

%Exercicio 3-4
%filtro_m = (1/25)*ones(5,5);
%filtro_g = fspecial('gaussian',[5 5], 1);

I1 = imread('b5s.40.bmp');
I2 = imread('b5s.100.bmp');

%Filtro da média
H1 = fspecial('average', [3 3]);
I1H1 = imfilter(I1, H1, 'symmetric');
I2H1 = imfilter(I2, H1, 'symmetric');
H2 = fspecial('average', [7 7]);
I1H2 = imfilter(I1, H2, 'symmetric');
I2H2 = imfilter(I2, H2, 'symmetric');

subplot(1,3,1);
imshow(I1);
title('original');
subplot(1,3,2);
imshow(I1H1);
title('média 3x3');
subplot(1,3,3);
imshow(I1H2);
title('média 5x5');

figure

subplot(1,3,1);
imshow(I2);
title('original');
subplot(1,3,2);
imshow(I2H1);
title('média 3x3');
subplot(1,3,3);
imshow(I2H2);
title('média 5x5');