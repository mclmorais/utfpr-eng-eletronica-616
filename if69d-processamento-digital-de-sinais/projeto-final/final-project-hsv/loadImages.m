files = dir('./input/*.png');
images = [];
for i = 1:length(files)
    images(i) = imread(strcat([files(i).folder, '/', files(i).name]));
end