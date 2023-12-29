function y = adaptThStd(x)
% x: bloco da imagem (subimagem)
% y: bloco processado
% std baixo -> é fundo
if(std2(x)) < 1
% Sai um bloco de uns
y = ones(size(x,1),size(x,2));
% std alto -> é texto
else
% Aplica Otsu no bloco
y = im2bw(x, graythresh(x));
end