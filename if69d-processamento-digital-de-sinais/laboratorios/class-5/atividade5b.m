clear all;
close all;
clc;

%Exercicio 5.b

g = imread('Lenna256g.png');
%m=0 e desvio padrão = 20
gg = imnoise(g,'gaussian',(0/255),(20/255)^2);
%Apenas ruído
s = imsubtract(double(g), double(gg));
%Para visualizar o ruído
sviz = uint8(s + 127);
%Display
figure
subplot(4,1,1)
imshow(g), title('Original')
subplot(4,1,2)
imshow(gg)
title('Ruído Gaussiano m=0 dp=20')
subplot(4,1,3)
imshow(sviz)
title('(Original)-(Com ruído)+127')
subplot(4,1,4)
imhist(sviz)
ylim('auto'), title('Histograma do ruído')