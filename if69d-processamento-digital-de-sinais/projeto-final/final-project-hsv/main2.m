clear; clc;

saveStepsToFile = true;
files = dir('./input/*.png');

v = VideoWriter('output_canny_8.avi');
open(v);

superPreviousLines = struct([]);
previousLines = struct([]);

timing = [];
range = 1:length(files);
disp(num2str(length(range)))
for i = range
    tic
    disp(num2str(i))
    
    currentImage = imread(strcat([files(i).folder, '/', files(i).name]));
    currentIterationLines = detectPowerLine(currentImage, saveStepsToFile);
    lines = [currentIterationLines, previousLines, superPreviousLines];
    
    for k = 1:length(lines)
        currentImage = insertShape(currentImage, 'line', [lines(k).point1 lines(k).point2], 'LineWidth', 3, 'color', 'Red');
    end
    
    if(saveStepsToFile); imwrite(currentImage, './steps/5_hough.png'); end
    writeVideo(v, currentImage);

    clear currentImage;
    
    superPreviousLines = previousLines;
    previousLines = currentIterationLines;
    clear lines;
    timing = [timing, toc];
    toc
end

plot(1:length(timing), timing);
close(v);
