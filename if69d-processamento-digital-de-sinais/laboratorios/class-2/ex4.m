% g � da classe uint8
% o valor m�nimo de g � 0
% o valor m�ximo de g � 255
% g1 � da classe double
% os valores m�nimos e m�ximos de g1 s�o 0 e 255 (manteve os valores
% anteriores)
% imshow(g1) n�o mostra imagem -> pois est� no formato double por�m os
% valores n�o respeitam a range [0 .. 1]
% os valores m�nimos e m�ximmos de g2 s�o 0 e 1
% g3 � da classe double
% os valores m�nimos e m�ximos em g3 s�o 0 e 1
% img2double precisa de dados em uint8 para conseguir transformar na escala
% entre 0 e 1, enquanto o mat2gray consegue fazer a convers�o dos valores
% corretamente. Al�m disso, mat2gray
% im2double -> n�o muda a imagem, s� divide por 255
% mat2gray ->  




