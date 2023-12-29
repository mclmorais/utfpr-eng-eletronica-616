function result = erosionStep(bw_image, kernelSize, comparison_image)

% bw_image = ~bw_image;
[h, w] = size(bw_image);

preview = im2double(cat(3, bw_image, bw_image, bw_image));
result = imbinarize(zeros(h, w));

range = @(pos) pos : pos + kernelSize - 1;
step = 0;

show_preview_always = 0;
show_preview_hit = 0;
show_comparison_hit = 0;
for row = 1 : h - kernelSize - 1
  for col = 1 : w - kernelSize - 1
    step = step + 1;
    block = bw_image(range(row), range(col));
    sumb = sum(block(:));
    condition = erosionMajorityProcess(block, kernelSize);
    if(condition)
        result(row + floor(kernelSize/2), col + floor(kernelSize/2)) = 1;
    end
    
    if(show_preview_always || (show_preview_hit && condition) || (show_comparison_hit && comparison_image(row + floor(kernelSize/2), col + floor(kernelSize/2)) == 1) )
        preview_with_indicator = preview;
        preview_with_indicator(range(row), range(col), :) = cat(3, ones(kernelSize), zeros(kernelSize), zeros(kernelSize));
        subplot(3, 2, 1), imshow(preview_with_indicator);
        subplot(3, 2, 2), imshow(comparison_image);
        subplot(3, 2, 3), imshow(block, 'InitialMagnification', 800), title(strcat('Step', num2str(step)));
        subplot(3, 2, 4), imshow(comparison_image(range(row), range(col)), 'InitialMagnification', 800), title(strcat('Comparison', num2str(step)));
        subplot(3, 2, 5), imshow(result), title(strcat('Sum:'))
        result_with_indicator = im2double(cat(3, result, result, result));
        result_with_indicator(row : row + kernelSize - 1, col : col + kernelSize - 1,:) = cat(3, zeros(kernelSize), ones(kernelSize), zeros(kernelSize));
        subplot(3, 2, 6), imshow(result_with_indicator), title(strcat('Sum:', num2str(sumb)))
        pause;
    end

  end
end


