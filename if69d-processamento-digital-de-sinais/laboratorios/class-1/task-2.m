clear all
close all
%Define o plano xy para o qual
%a função Z será avaliada
interval = 10;
x = -interval:1:interval;
y = -interval:1:interval;
%X e Y contém todos os pares de
%coordenadas do plano xy
[X, Y] = meshgrid(x,y);
%Calcula Z para todos os pares
%de coordenada do plano xy
Z = X.^4 - (4.*X.^2.*Y.^2) + Y.^4;
%Função surf
figure
surf(X, Y, Z)
xlim([-25 25]), ylim([-25, 25])
title('surf')
%Função surf sem linhas
%e com transparência
figure
surf(X, Y, Z)
xlim([-25 25]), ylim([-25, 25])
title('surf, shading, alpha')
shading('interp')
alpha(0.7)
%Função surfc
figure
surfc(X, Y, Z)
xlim([-25 25]), ylim([-25, 25])
title('surfc')
%Função mesh com linhas pretas
figure
mesh(X, Y, Z, 'EdgeColor', ...
'black')
xlim([-25 25]), ylim([-25, 25])
title('mesh')