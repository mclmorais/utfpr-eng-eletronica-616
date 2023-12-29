bw = [ 1 0 0 0 0 1
 0 0 1 1 0 0
 0 0 1 0 0 0
 0 1 1 1 1 0
 0 1 1 1 0 0
 0 0 0 0 0 0];

bw = logical(bw);

subplot(1,2,1), imshow(bw, 'InitialMagnification', 8000)

kernel = [1 0; 1 1];

result = zeros(6);
for row = 1:5
    for col = 1:5
        block = bw(row:row+1, col:col+1);
        result(row, col) = isequal(block & kernel, kernel);
    end
end
subplot(1,2,2), imshow(result)