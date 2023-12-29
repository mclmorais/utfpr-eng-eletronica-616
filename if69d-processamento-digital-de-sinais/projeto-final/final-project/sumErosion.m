bw = [ 1 0 0 0 0 1
 0 0 1 1 0 0
 0 0 1 0 0 0
 0 1 1 1 1 0
 0 1 1 1 0 0
 0 0 0 0 0 0];

bw = logical(bw);

subplot(1,3,1), imshow(bw, 'InitialMagnification', 8000)

kernel = [1 1; 1 1];

result = zeros(6);
for row = 1:5
    for col = 1:5
        block = bw(row:row+1, col:col+1);
        blockResult = block .* ones(2);
        result(row, col) = sum(blockResult(:));
    end
end
subplot(1,3,2), imshow(mat2gray(result))

filteredResult = zeros(6);
filteredResult(result <= 2) = 1;

subplot(1,3,3), imshow(filteredResult);
