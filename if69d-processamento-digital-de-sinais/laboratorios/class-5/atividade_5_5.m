clear all;
close all;
clc;

%Exercicio 5.5

%Filtro da média
G_0_5 = fspecial('gaussian',[25 25], .5);
G_1 = fspecial('gaussian',[25 25], 1);
G_2 = fspecial('gaussian',[25 25], 2);
G_3 = fspecial('gaussian',[25 25], 3);
G_4 = fspecial('gaussian',[25 25], 4);
G_5 = fspecial('gaussian',[25 25], 5);
G_10 = fspecial('gaussian',[25 25], 10);
G_25 = fspecial('gaussian',[25 25], 25);
G_50 = fspecial('gaussian',[25 25], 50);

%Display
figure
subplot(1,2,1)
mesh(G_0_5, 'EdgeColor', 'black')
subplot(1,2,2)
bar3(G_0_5)
title('sigma=0.5')

figure
subplot(1,2,1)
mesh(G_1, 'EdgeColor', 'black')
subplot(1,2,2)
bar3(G_1)
title('sigma=1')

figure
subplot(1,2,1)
mesh(G_2, 'EdgeColor', 'black')
subplot(1,2,2)
bar3(G_2)
title('sigma=2')

figure
subplot(1,2,1)
mesh(G_3, 'EdgeColor', 'black')
subplot(1,2,2)
bar3(G_3)
title('sigma=3')

figure
subplot(1,2,1)
mesh(G_4, 'EdgeColor', 'black')
subplot(1,2,2)
bar3(G_4)
title('sigma=4')

figure
subplot(1,2,1)
mesh(G_5, 'EdgeColor', 'black')
subplot(1,2,2)
bar3(G_5)
title('sigma=5')

figure
subplot(1,2,1)
mesh(G_10, 'EdgeColor', 'black')
subplot(1,2,2)
bar3(G_10)
title('sigma=10')

figure
subplot(1,2,1)
mesh(G_25, 'EdgeColor', 'black')
subplot(1,2,2)
bar3(G_25)
title('sigma=25')

figure
subplot(1,2,1)
mesh(G_50, 'EdgeColor', 'black')
subplot(1,2,2)
bar3(G_50)
title('sigma=50')
