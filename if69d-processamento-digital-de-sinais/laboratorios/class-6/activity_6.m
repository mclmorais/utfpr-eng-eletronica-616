%% 1

Hx = 1/3 * ones(1, 3);
Hy = Hx';

Hxy = 1/9 * ones(3,3);

g = imread('Lenna256g.png');
[h, w] = size(g);

% padding opcional
gp = zeros(h+2, w+2);
gp(2:h+1, 2:w+1) = g;


f = Hxy(:);


gxy = zeros(h+2, w+2);

tic
 for y = 1:h-2
     for x = 1:w-2
         region = g(y:y+2, x:x+2);
         region = region(:);
         
         acc = 0;
         for z = 1:9
            acc = acc + region(z) *  f(z);
         end
         
         gxy(y, x) = acc;
     end
 end
 toc
 
 subplot(1,3,1), imshow(g)
 subplot(1,3,2), imshow(uint8(gxy))
 
gx = zeros(h+2, w+2);
gy = zeros(h+2, w+2);

 tic
 for y = 1:h-2
     for x = 1:w-2
         region = g(y, x:x+2);
         
         acc = 0;
         for z = 1:3
            acc = acc + region(z) *  Hx(z);
         end
         
         gx(y, x) = acc;
     end
 end
 
  for y = 1:h-2
     for x = 1:w-2
         region = gx(y:y+2, x);
         
         acc = 0;
         for z = 1:3
            acc = acc + region(z) *  Hy(z);
         end
         
         gy(y, x) = acc;
     end
 end
 toc
 
subplot(1,3,3), imshow(uint8(gy))

%% 2 - nao precisa fazer
%% 3

boxFilter = @(g, size) double(imfilter(g, 1/(size^2) * ones(size,size)));

g = imread('Lenna256g_ng20.png');
gc = imcrop(g);

imVart = var(double(gc(:)));

imVarl = nlfilter(double(g), [5 5], @(region)var(region(:)));

imMed = double(imfilter(g, 1/25 * ones(5,5)));

im = (1 - imVart./imVarl).*double(g) + (imVart./imVarl).*imMed;

subplot(1,3,1), imshow(g);
subplot(1,3,2), imshow(uint8(im));
subplot(1,3,3), imshow(uint8(boxFilter(g, 3)))

%% 4
clc
g = imread('Lenna256g_ng20.png');
boxFilter = @(g, size) double(imfilter(g, 1/(size^2) * ones(size,size)));


gMed = double(g(46:62, 208:230));
gMed3 = boxFilter(g, 3);
gMed3 = gMed3(46:62, 208:230);
gMed7 = boxFilter(g, 7);
gmed7 = gMed7(46:62, 208:230);

med = mean(gMed(:));
med3 = mean(gMed3(:));
med7 = mean(gMed7(:));

gStd = double(g(162:182, 238:248));
gStd3 = boxFilter(g, 3);
gStd3 = gStd3(162:182, 238:248);
gStd7 = boxFilter(g, 7);
gStd7 = gStd7(162:182, 238:248);

stdev = std(gStd(:));
stdev3 = std(gStd3(:));
stdev7 = std(gStd7(:));




snr = med/stdev;
snr3 = med3/stdev3;
snr7 = med7/stdev7;

imf3 = boxFilter(g, 3);
imf7 = boxFilter(g, 7);

subplot(1,3,1), imshow(uint8(g)), title(snr);
subplot(1,3,2), imshow(uint8(imf3)), title(snr3);
subplot(1,3,3), imshow(uint8(imf7)), title(snr7);






