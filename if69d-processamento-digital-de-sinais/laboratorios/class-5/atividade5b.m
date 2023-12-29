clear all;
close all;
clc;

%Exercicio 5.b

g = imread('Lenna256g.png');
%m=0 e desvio padr�o = 20
gg = imnoise(g,'gaussian',(0/255),(20/255)^2);
%Apenas ru�do
s = imsubtract(double(g), double(gg));
%Para visualizar o ru�do
sviz = uint8(s + 127);
%Display
figure
subplot(4,1,1)
imshow(g), title('Original')
subplot(4,1,2)
imshow(gg)
title('Ru�do Gaussiano m=0 dp=20')
subplot(4,1,3)
imshow(sviz)
title('(Original)-(Com ru�do)+127')
subplot(4,1,4)
imhist(sviz)
ylim('auto'), title('Histograma do ru�do')