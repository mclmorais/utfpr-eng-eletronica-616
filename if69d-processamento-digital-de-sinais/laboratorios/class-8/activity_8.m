%% 8.1



%% 8.2
% otsu
% inverte
% fechamento
% abertura
%%8.3

%% 8.4 - Rotulação de regiões em imagens binárias (função bwlabel)
% Faça um script para contar quantas células existem na imagem whitecells4.png.

g = imread('assets/whitecells4.png');

subplot(1, 2, 1), imshow(g), title('Original')

threshold = graythresh(g);

g = im2double(g);

g(g > threshold) = 1;
g(g <= threshold) = 0;

[~, nrv8] = bwlabel(g, 8);

subplot(1, 2, 2), imshow(mat2gray(g)), title(['Limiarizada (Otsu): ', num2str(nrv8), ' manchas'])


%% 8.5

g = imread('assets/whitecells4.png');

subplot(1, 3, 1), imshow(g), title('Original')

threshold = graythresh(g);

g = im2double(g);

g(g > threshold) = 1;
g(g <= threshold) = 0;

[rv8, nrv8] = bwlabel(g, 8);

subplot(1, 3, 2), imshow(mat2gray(g)), title(['Limiarizada (Otsu): ', num2str(nrv8), ' manchas'])

sizes = zeros(1, nrv8);
for a = 1 : nrv8
    segment = find(rv8 == a);
    sizes(a) = length(segment(:));
end

subplot(1, 3, 3), hist(sizes)

%% 8.6

g = imread('assets/whitecells4.png');

% subplot(1, 2, 1), imshow(g), title('Original')

threshold = graythresh(g);

g0 = g;
g = im2double(g);

g(g > threshold) = 1;
g(g <= threshold) = 0;

[rv8, nrv8] = bwlabel(g, 8);


sizes = zeros(1, nrv8);
for a = 1 : nrv8
    segment = find(rv8 == a);
    sizes(a) = length(segment(:));
end

percent = 10;
min_prc = prctile(sizes, [(100-percent), 100]);
min_prc = min_prc(1);

low_vals = zeros(1, nrv8);
low_vals(sizes < min_prc) = 1;

for a = 1 : nrv8
    if(low_vals(a) == 1)
        rv8(rv8 == a) = 0;
    end
end

imshow(im2double(g0) .* logical(rv8)), title(['Top ', num2str(percent), '%'])



%% 8.8

% adaptive_Th [script]
% Tutorial 'Adaptive Thresholding',
% capítulo 15,
% páginas 350 até 352 do livro
% Oge Marques, Practical image and video
% processing using MATLAB, Wiley, 2011.
clear all; close all; clc
g = imread('assets/gradient_with_text.tif');
figure, imshow(g), title('in')
% Global Th
ggth = im2bw(g, graythresh(g));
figure, imshow(ggth), title('ggth')
figure, imhist(g) % pelo histograma:
% otsu não é uma boa
% Adaptive Th
% Função blockproc é sem overlap
% Cria function handle
fun = @(myBlock) adaptThStd(myBlock.data);
gath = blockproc(g, [10 10], fun); % processa
figure, imshow(gath), title(gath)
