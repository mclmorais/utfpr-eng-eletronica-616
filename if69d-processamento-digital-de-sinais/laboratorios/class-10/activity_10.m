%% 10.1

%% 10.2

%% 10.3

clear all
close all
clc

I = imread('greens.jpg');
q1 = I(1:150,1:250,:);
q2 = I(1:150,251:500,:);
q3 = I(151:300,1:250,:);
q4 = I(151:300,251:500,:);
imshow(I)
title('Original')

figure
subplot(2,2,1)
imshow(q1)
title('Quadrante 1')
subplot(2,2,2)
imshow(q2)
title('Quadrante 2')
subplot(2,2,3)
imshow(q3)
title('Quadrante 3')
subplot(2,2,4)
imshow(q4)
title('Quadrante 4')

I1 = q1(:,:,1)-(q1(:,:,2));
I1 = imfill(I1, 'holes');
level1 = graythresh(I1);
figure
BW1 = im2bw(I1,level1);
V1 = sum(sum(BW1))
subplot(2,2,1)
imshow(uint8(double(q1).*repmat(double(BW1),[1,1,3])))
title([num2str(V1/(150*250)) '%'])

I2 = q2(:,:,1)-(q2(:,:,2));
I2 = imfill(I2, 'holes');
level2 = graythresh(I2);
BW2 = im2bw(I2,level2);
V2 = sum(sum(BW2))
subplot(2,2,2)
imshow(uint8(double(q2).*repmat(double(BW2),[1,1,3])))
title([num2str(V2/(150*250)) '%'])


I3 = q3(:,:,1)-(q3(:,:,2));
I3 = imfill(I3, 'holes');
level3 = graythresh(I3);
BW3 = im2bw(I3,level3);
V3 = sum(sum(BW3))
subplot(2,2,3)
imshow(uint8(double(q3).*repmat(double(BW3),[1,1,3])))
title([num2str(V3/(150*250)) '%'])


I4 = q4(:,:,1)-(q4(:,:,2));
I4 = imfill(I4, 'holes');
level4 = graythresh(I4);
BW4 = im2bw(I4,level4);
V4 = sum(sum(BW4))
subplot(2,2,4)
imshow(uint8(double(q4).*repmat(double(BW4),[1,1,3])))
title([num2str(V4/(150*250)) '%'])