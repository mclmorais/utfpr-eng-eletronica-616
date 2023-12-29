% AULA 04 - 10/09/2019 --------------------------------------

%% 1 ---------------------------------------------------------

clear all, close all
I = imread('Fig0304(a)(breast_digital_Xray).tif');
y = uint8(255:-1:0);
plot(y); xlim([0 255]); ylim([0 255]);
Ia = y(I + 1);
figure, subplot(1,2,1), imshow(I), title('Original');
subplot(1,2,2), imshow(Ia), title('Transformação');

%% 2 ---------------------------------------------------------

clear all, close all
I = imread('Fig0304(a)(breast_digital_Xray).tif');
y = uint8(255:-1:0);
plot(y); xlim([0 255]); ylim([0 255]);
Ia = intlut(I,y);
figure, subplot(1,2,1), imshow(I), title('Original');
subplot(1,2,2), imshow(Ia), title('Transformação');

%% 3 ---------------------------------------------------------

I = imread('radio.tif');
x = double(0:255);
%Funcao log
%Logaritmo neperiano (base e)
y = log(1 + x);
Ia = y(I + 1);
Ia = Ia ./ max(Ia(:));
%Display
subplot(1,2,1), imshow(I), title('Original');
subplot(1,2,2), imshow(Ia), title('Transformação2');
figure, plot(y)
grid on
title('log function')
xlabel('x')
ylabel('y = log(x)')

%% 4 ---------------------------------------------------------

I = imread('pout.tif');
subplot(2,2,1), imshow(I), title('Original');

Im = mat2gray(I);
subplot(2,2,2), imshow(Im), title('mat2gray');

Im = double(I);
Imin = min(min(Im));
Imax = max(max(Im));
Ia = imadjust(I, [Imin/255 Imax/255]);
subplot(2,2,3), imshow(Ia), title('imadjust');

Im = double(I);
Imin = min(min(Im));
Imax = max(max(Im));
Imn = (Im - Imin)/Imax;
subplot(2,2,4), imshow(Imn), title('na mão');

%% 5 ---------------------------------------------------------

I = imread('radio.tif');

%Funcao Gamma
x = 0:0.01:1;
y1 = x.^0.4;
y2 = x.^0.1;
y3 = x.^2.0;
y4 = x.^10;

I1 = imadjust(I,[],[],0.4);
I2 = imadjust(I,[],[],0.1);
I3 = imadjust(I,[],[],2);
I4 = imadjust(I,[],[],10);

%Display
figure
subplot(2,2,1), imshow(I1)
grid on
title('Gamma = 0.4')
subplot(2,2,2), imshow(I2)
grid on
title('Gamma = 0.1')
subplot(2,2,3), imshow(I3)
grid on
title('Gamma = 2.0')
subplot(2,2,4), imshow(I4)
grid on
title('Gamma = 10')

figure
subplot(2,2,1), plot(x,y1)
grid on
title('Gamma = 0.4')
subplot(2,2,2), plot(x,y2)
grid on
title('Gamma = 0.1')
subplot(2,2,3), plot(x,y3)
grid on
title('Gamma = 2.0')
subplot(2,2,4), plot(x,y4)
grid on
title('Gamma = 10')

%% 6 ---------------------------------------------------------

%Contrast stretching
%Aloca uint8
%para depopis usar funcao intlut (y1 é a LUT)
y1 = uint8(zeros([1 256]));
%Equação da reta inferior y = (1/3)*x
y1(1:97) = (1/3)*(0:96);
%Equação da reta intermediária y = 3*x -256
y1(98:161) = 3*(97:160) - 256;
%Equação da reta superior y = (1/3)*x + 170
y1(162:256) = (1/3)*(161:255) + 170;
%Display
figure, plot(y1)
xlim([0 255]), ylim([0 255])
grid on
title('Contrast streching')
xlabel('x'), ylabel('y')
%Intensity-level slicing
%Aloca uint8
%para depopis usar funcao intlut (y2 é a LUT)
y2 = uint8(zeros([1 256]));
%Equação da reta inferior y = x (identidade)
y2(1:97) = 0:96;
%Equação da reta intermediária
%y = 250(um único nível de cinza cte)
y2(98:161) = 250;
%Equação da reta superior y = x (identidade)
y2(162:256) = 161:255;
%Display
figure, plot(y2)
xlim([0 255]), ylim([0 255])
grid on
title('Intensity-level slicing')
xlabel('x'), ylabel('y')

figure
I = imread('Fig0310(b)(washed_out_pollen_image).tif');
Ia = intlut(I,y1);
Ib = intlut(I,y2);
subplot(1,3,1), imshow(I), title('Original');
subplot(1,3,2), imshow(Ia), title('Contrast Stretching');
subplot(1,3,3), imshow(Ib), title('Insensity Level Slicing');

%% 7 ---------------------------------------------------------

I1 = imread('coins.png');
I2 = imread('pout.tif');

subplot(2,2,1), imshow(I1);
subplot(2,2,2), imshow(I2);
subplot(2,2,3), imhist(I1);
subplot(2,2,4), imhist(I2);

%% 8 ---------------------------------------------------------

I1 = imread('coins.png');
I2 = imread('pout.tif');

I1esticado = I1(:);
hist1 = zeros(1,255);
[a, ~] = size(I1esticado);
for p = 1:a
    hist1(I1esticado(p)) = hist1(I1esticado(p)) + 1;
end

 I2esticado = I2(:);
 hist2 = zeros(1,255);
 [a, b] = size(I2esticado);
 for p = 1:a
     hist2(I2esticado(p)) = hist2(I2esticado(p)) + 1;
 end

stem(hist1)
figure
stem(hist2)

%% 9 ---------------------------------------------------------

I1 = imread('coins.png');

subplot(2,2,1), imshow(I1);
subplot(2,2,2), histeq(I1, 256);

subplot(2,2,3), imhist(I1);
subplot(2,2,4), imhist(histeq(I1, 256));

%% 10 ---------------------------------------------------------

I1 = imread('coins.png');
subplot(1,3,1);
imshow(I1);
H1 = imhist(I1)';

[a, b] = size(I1);
H1n = H1 / (a * b);

cdf = cumsum(H1n);
subplot(1,3,3);
plot(cdf);

cdfCinza = uint8(cdf * 255);

subplot(1,3,2);
Ia = intlut(I1,cdfCinza);

imshow(Ia);
