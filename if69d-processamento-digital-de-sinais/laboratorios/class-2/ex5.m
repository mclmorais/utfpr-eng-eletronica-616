image = imread('pout.tif');

subplot(1,2,1);
imshow(image);
subplot(1,2,2);
imshow(image(81:124, 86:143));
