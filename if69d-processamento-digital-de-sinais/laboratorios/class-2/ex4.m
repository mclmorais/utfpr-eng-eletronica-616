% g é da classe uint8
% o valor mínimo de g é 0
% o valor máximo de g é 255
% g1 é da classe double
% os valores mínimos e máximos de g1 são 0 e 255 (manteve os valores
% anteriores)
% imshow(g1) não mostra imagem -> pois está no formato double porém os
% valores não respeitam a range [0 .. 1]
% os valores mínimos e máximmos de g2 são 0 e 1
% g3 é da classe double
% os valores mínimos e máximos em g3 são 0 e 1
% img2double precisa de dados em uint8 para conseguir transformar na escala
% entre 0 e 1, enquanto o mat2gray consegue fazer a conversão dos valores
% corretamente. Além disso, mat2gray
% im2double -> não muda a imagem, só divide por 255
% mat2gray ->  




