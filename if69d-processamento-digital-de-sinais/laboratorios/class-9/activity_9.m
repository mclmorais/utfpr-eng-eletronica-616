clear;
clc;

dir_number = '10';
c(:,:,1) = imread(strcat(['mugs\mug_', dir_number, '\mug_', dir_number, '_01.png']));
c(:,:,2) = imread(strcat(['mugs\mug_', dir_number, '\mug_', dir_number, '_02.png']));
c(:,:,3) = imread(strcat(['mugs\mug_', dir_number, '\mug_', dir_number, '_03.png']));
c(:,:,4) = imread(strcat(['mugs\mug_', dir_number, '\mug_', dir_number, '_04.png']));
c(:,:,5) = imread(strcat(['mugs\mug_', dir_number, '\mug_', dir_number, '_05.png']));
c(:,:,6) = imread(strcat(['mugs\mug_', dir_number, '\mug_', dir_number, '_06.png']));
c(:,:,7) = imread(strcat(['mugs\mug_', dir_number, '\mug_', dir_number, '_07.png']));
c(:,:,8) = imread(strcat(['mugs\mug_', dir_number, '\mug_', dir_number, '_08.png']));

somas_esq = [];
somas_dir = [];
for z = 1:8
    
g = c(:,:,z);

subplot(1,2,1), imshow(g);


[h, w] = size(g);

g = g(0.5*h:0.85*h , 0.2*w:0.8*w);


g_mean = mean(g(:));

if(g_mean < 60)
    white_limit = 70;
else
    white_limit = 95;
end

g = mat2gray(g,[0, white_limit]);
threshold = graythresh(g);

g0 = g;
g = im2double(g);

g(g > threshold) = 1;
g(g <= threshold) = 0;

se = strel('square', 3);

[rv8, nrv8] = bwlabel(imcomplement(g), 8);

rv8rgb = label2rgb(rv8);

% image(rv8rgb)
[h, w] = size(g);

% se = strel('square', 5);
% g = imclose(g, se);

esquerda = logical(g(:, 1:int16(w/2)));
direita = logical(g(:, int16(w/2+1):w));

sum_esq = sum(esquerda(:));

sum_dir = sum(direita(:));

if(sum_esq > sum_dir)
    lado = 'esquerdo';
else
    lado = 'direito';
end

    subplot(1, 2, 2), imshow(g), title(lado)

    somas_esq(z) = sum_esq;
    somas_dir(z) = sum_dir;
end
 
 diff_lados = somas_esq - somas_dir;
 
 [zz, indice_esq] = max(diff_lados);
 [zz, indice_dir] = min(diff_lados);
 
 subplot(1, 2, 1), imshow(c(:,:,indice_esq)), title('esquerda');
 subplot(1, 2, 2), imshow(c(:,:,indice_dir)), title('direita');

 
%  subplot(1,2,1), imshow(c(indice)), 

