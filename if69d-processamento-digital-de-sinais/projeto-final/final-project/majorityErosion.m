function result = majorityErosion(bw, kernelSize)

bw = logical(bw);

[h, w] = size(bw);

result = zeros(h, w);
for row = 1:(h-kernelSize-1)
    for col = 1:(w-kernelSize-1)
        block = bw(row:row+(kernelSize-1), col:col+(kernelSize-1));
        sumb = sum(block(:));
        if(sumb <= kernelSize && sumb > 0)
            result(row, col) = 1;
        end
    end
end
