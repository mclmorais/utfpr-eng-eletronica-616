%% 
clear all, close all
clc
% Cria imagem sintética g
w = 256;
objt = 192; fundo = 64; rdn = 10;
g = makeImSynthHex(w,objt,fundo, rand());
g = im2double(g);
hv = [-1 0 1];
gv = imfilter(g, hv, 'replicate');%correlat.
hh = hv';
gh = imfilter(g, hh, 'replicate');%correlat.
% Normaliza, pois existem
% valores negativos
gv = mat2gray(gv);
gh = mat2gray(gh);
% Display
figure, imshow(g)
title('Imagem de entrada')
figure, imshow(gv)
title('Resultado da máscara vertical')
figure, imshow(gh)
title('Resultado da máscara horizontal')
%% 7.2
clear all, close all
clc
% Cria imagem sintética g
w = 256;
objt = 192; fundo = 64; rdn = 10;
g = makeImSynthHex(w,objt,fundo,rdn);
g = im2double(g);
subplot(2,5,1), imshow(g), title ('Original');
Sh = fspecial('sobel');
gSh = imfilter(g,Sh,'replicate','conv');
subplot(2,5,2), imshow(gSh), title('Conv Horizontal');
Sv = Sh';
gSv = imfilter(g,Sv,'replicate','conv');
subplot(2,5,3), imshow(gSv), title('Conv Vertical');

% Imagem de magnitude do gradiente
S = sqrt(gSv.^2 + gSh.^2);
% Normaliza
gSh = mat2gray(gSh);
gSv = mat2gray(gSv);
S = mat2gray(S);
% Limiariza
Sbw = im2bw(S,graythresh(S));
% Display
subplot(2,5,4), imshow(S), title('Conv Mag Grad');
subplot(2,5,5), imshow(Sbw), title('Conv Mag Grad BW');

%-------

Sh = fspecial('sobel');
gSh = imfilter(g,Sh,'replicate');
subplot(2,5,7), imshow(gSh), title('Horizontal');
Sv = Sh';
gSv = imfilter(g,Sv,'replicate');
subplot(2,5,8), imshow(gSv), title('Vertical');

% Imagem de magnitude do gradiente
S = sqrt(gSv.^2 + gSh.^2);
% Normaliza
gSh = mat2gray(gSh);
gSv = mat2gray(gSv);
S = mat2gray(S);
% Limiariza
Sbw2 = im2bw(S,graythresh(S));
% Display
subplot(2,5,9), imshow(S), title('Mag Grad');
subplot(2,5,10), imshow(Sbw2), title('Mag Grad BW');
subplot(2,5,6), imshow(Sbw2 - Sbw), title('Diferenca')

%% 7.3

clear all, close all
clc
% Cria imagem sintética g
w = 256;
objt = 192; fundo = 64; rdn = 10;
g = makeImSynthHex(w,objt,fundo,rdn);
g = im2double(g);
subplot(2,5,1), imshow(g), title ('Original');
Sh = fspecial('sobel');
gSh = imfilter(g,Sh,'replicate','conv');
subplot(2,5,2), imshow(gSh), title('Conv Horizontal');
Sv = Sh';
gSv = imfilter(g,Sv,'replicate','conv');
subplot(2,5,3), imshow(gSv), title('Conv Vertical');

% Imagem de magnitude do gradiente
S = sqrt(gSv.^2 + gSh.^2);
% Normaliza
gSh = mat2gray(gSh);
subplot(2,5,6), imshow(gSh), title('Conv Horizontal Mat2Gray');
gSv = mat2gray(gSv);
S = mat2gray(S);
% Limiariza
Sbw = im2bw(S,graythresh(S));
% Display
subplot(2,5,4), imshow(S), title('Conv Mag Grad');
subplot(2,5,5), imshow(Sbw), title('Conv Mag Grad BW');

%------------

Sh = fspecial('sobel');
gSh = imfilter(g,Sh,'replicate','conv');
Sv = Sh';
gSv = imfilter(g,Sv,'replicate','conv');

S = (abs(gSv) + abs(gSh));
S2 = (abs(gSv) + abs(gSh))./2;
% Normaliza
gSh = mat2gray(gSh);
gSv = mat2gray(gSv);
S = mat2gray(S);
S2 = mat2gray(S2);

% Limiariza
SbwAbs = im2bw(S,graythresh(S));
% Display
subplot(2,5,7), imshow(S), title('Soma Abs');
subplot(2,5,8), imshow(S2), title('Soma Abs/2');
subplot(2,5,9), imshow(SbwAbs - Sbw), title('Diferenca BW');
subplot(2,5,10), imshow(SbwAbs), title('Soma Abs BW');

%% 7.4
clear all, close all
clc
% Cria imagem sintética g
w = 256;
objt = 192; fundo = 64; rdn = 10;
g = makeImSynthHex(w,objt,fundo,rdn);
g = im2double(g);
subplot(1,5,1), imshow(g), title ('Original');
Sh = fspecial('sobel');
gSh = imfilter(g,Sh,'replicate','conv');
subplot(1,5,2), imshow(gSh), title('Conv Horizontal');
Sv = Sh';
gSv = imfilter(g,Sv,'replicate','conv');
subplot(1,5,3), imshow(gSv), title('Conv Vertical');

% Imagem de magnitude do gradiente
[h, w] = size(gSv);

for a = 1 : h
    for b = 1 : w
        S(a, b) = max(abs(gSv(a, b)), abs(gSh(a, b)));
    end
end
% S = max(abs(gSv), abs(gSh));


% Normaliza
gSh = mat2gray(gSh);
gSv = mat2gray(gSv);
S = mat2gray(S);
% Limiariza
Sbw = im2bw(S,graythresh(S));
% Display
subplot(1,5,4), imshow(S), title('Conv Mag Grad');
subplot(1,5,5), imshow(Sbw), title('Conv Mag Grad BW');

%% 7.5

img = imread('cameraman.tif');

h = fspecial('laplacian',0);
lap = edge(img,'zerocross',0.5,h); %t é um limiar que atua na sensibilidade da
 %detecção das passagens por zero
subplot(1,2,1), imshow(lap);

sob = edge(img,'sobel');
subplot(1,2,2), imshow(sob);

%% 7.6

img = imread('cameraman.tif');
thresh = 0.5;

for sigma =  0.1 : 0.1 : 1.5
BW = edge(img,'log',thresh,sigma);
imshow(BW);
pause(0.5)
end

%% 7.7

img = imread('cameraman.tif');


K(1:3, 1:3, 1) = [-3 -3 5; -3 0 5; -3 -3 5];
K(1:3, 1:3, 2) = [-3 5 5; -3 0 5; -3 -3 -3];
K(1:3, 1:3, 3) = [5 5 5; -3 0 -3; -3 -3 -3];
K(1:3, 1:3, 4) = [5 5 -3; 5 0 -3; -3 -3 -3];
K(1:3, 1:3, 5) = [5 -3 -3; 5 0 -3; 5 -3 -3];
K(1:3, 1:3, 6) = [-3 -3 -3; 5 0 -3; 5 5 -3];
K(1:3, 1:3, 7) = [-3 -3 -3; -3 0 -3; 5 5 5];
K(1:3, 1:3, 8) = [-3 -3 -3; -3 0 5; -3 5 5];

for a = 1:8
    G(:,:,a) = imfilter(img, K(:,:,a));
end

kirsch = max(G,[],3);

imshow(kirsch)

%% 7.8
img1 = imread('cameraman.tif');
img2 = imread('moon.tif');
img3 = imread('kids.tif');

subplot(3,3,1), imshow(img1); title('original')
sob = edge(img1,'sobel', 0.05);
subplot(3,3,2), imshow(sob); title('sobel')
canny = edge(img1,'canny');
subplot(3,3,3), imshow(canny); title('canny')

subplot(3,3,4), imshow(img2); title('original')
sob = edge(img2,'sobel', 0.02);
subplot(3,3,5), imshow(sob); title('sobel')
canny = edge(img2,'canny');
subplot(3,3,6), imshow(canny); title('canny')

subplot(3,3,7), imshow(img3); title('original')
sob = edge(img3,'sobel', 0.015);
subplot(3,3,8), imshow(sob); title('sobel')
canny = edge(img3,'canny');
subplot(3,3,9), imshow(canny); title('canny')




