%5x5 Desvio Padrao 1
%3x3 Desvio Padrao 0.5

%% Exercício 5d
clear, close all
g = imread('Lenna256g.png');
%Parâmetro:densidade de pixels com ruído
gsp = imnoise(g, 'salt & pepper', 0.05);
%Apenas ruído, só pra visualizar
z = uint8(zeros(size(g))+127);
sp = imnoise(z, 'salt & pepper', 0.05);
unique(sp)%para notar que sal=255,pim=0
%Display
figure
subplot(3,2,1)
imshow(g), title('Original')
subplot(3,2,2)
imshow(gsp)
title('Ruído sal-e-pimenta d=5%')
subplot(3,2,3)
imshow(sp)
title('Apenas ruído com d=5%')
subplot(3,2,4)
imhist(sp), ylim([0 numel(sp)*0.05])
title('Histograma do ruído')

gspmf = medfilt2(gsp, [3 3]);
subplot(3,2,5)
imshow(gspmf)
title('Filtro de Mediana')

%% exercicio 5.6
clear, close all;

g = imread('salt-and-pepper1.tif');
subplot(1, 4, 1)
imshow(g)
title('Original')

gmf = medfilt2(g, [3 3]);
subplot(1, 4, 2)
imshow(gmf)
title('Filtro de Mediana')

gbox3 = imfilter(g, 1/10 * ones(3,3));
subplot(1, 4, 3)
imshow(gbox3)
title('Filtro Box 3x3')

gbox5 = imfilter(g, 1/20 * ones(5,5));
subplot(1, 4, 4)
imshow(gbox5)
title('Filtro Box 5x5')

%% Exercicio 5.7

clear; close all;

g = imread('salt-and-pepper1.tif');
[h, w] = size(g);

% padding opcional
gp = zeros(h+2, w+2);
gp(2:h+1, 2:w+1) = g;


gm = zeros(h+2, w+2);

 for y = 1:h-2
     for x = 1:w-2
         region = g(y:y+2, x:x+2);
         gm(y, x) = median(region(:));

     end
 end

imshow(uint8(gm))

%% 5.8

a = fspecial('laplacian', 0);
bar3(a)

% Retorna um laplaciano invertido

%% 5.9

clear
close all

g = imread('flowervaseg.png');
%Imfilter retorna imagem da mesma clase da
%de entrada. Se g fosse uint8 o imfilter
%truncaria os valores de saída e a
%visualização da convolução
%seria comprometida. Por isso:
gd = im2double(g);
h = fspecial('laplacian', 0);
gdL = imfilter(gd, h, 'replicate');
gdLs = gd - gdL;
gdLsu = im2uint8(gdLs); %trunca
%Display
subplot(2, 3, 1), imshow(g)
title('Original')
%mat2gray apenas para a
%visualização do Laplaciano
gdLn = mat2gray(gdL);
subplot(2, 3, 2), imshow(gdLn)
title('Laplaciano')
subplot(2, 3, 3), imshow(gdLsu)
title('Realce')


hdir = -h;
gdL = imfilter(gd, hdir, 'replicate');
gdLs = gd + gdL;
gdLsu = im2uint8(gdLs); %trunca
gdlsm2g = mat2gray(gdLs);
subplot(2, 3, 5), imshow(gdLsu)
title('Direto Truncado')
subplot(2, 3, 6), imshow(gdlsm2g)
title('Direto Normalizado')


