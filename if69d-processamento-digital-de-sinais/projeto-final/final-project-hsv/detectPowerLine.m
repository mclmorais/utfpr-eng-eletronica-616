function lines = detectPowerLine(g, saveStepsToFile)
if(saveStepsToFile); imwrite(g, './steps/0_0_original.png'); end

% ------------- Sky & Vegetation Removal -------------
[h, s, v] = rgb2hsv(g);
v = v .* (s <= 0.39);
if(saveStepsToFile); imwrite(hsv2rgb(cat(3, h, s, v)), './steps/0_1_039_rgb.png'); end
v = v .* (v < 0.95);
if(saveStepsToFile); imwrite(hsv2rgb(cat(3, h, s, v)), './steps/0_2_095_rgb.png'); end

rgb = hsv2rgb(cat(3, h, s, v));

gray = rgb2gray(rgb);
if(saveStepsToFile); imwrite(gray, './steps/2_adaptative_gray.png'); end

% ------------- Edge Detection -------------

bw = edge(gray,'Canny');

if(saveStepsToFile); imwrite(bw, './steps/3_edge_detection.png'); end

% ------------- Image Opening -------------

rect = strel('line',5,90);
bw = imopen(bw, rect);

if(saveStepsToFile); imwrite(bw, './steps/4_open.png'); end

% ------------- Hough Transform Line Detection -------------

[H,T,R] = hough(bw,'RhoResolution',2, 'Theta', -20:0.1:20);
imshow(H,[],'XData',T,'YData',R,...
            'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
P  = houghpeaks(H,5,'threshold',ceil(0.05*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');
lines = houghlines(bw,T,R,P,'FillGap',25,'MinLength',30);



