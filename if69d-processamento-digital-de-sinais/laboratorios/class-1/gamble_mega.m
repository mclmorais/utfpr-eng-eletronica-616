%gamble_mega [script]

%================================================= USER
% Sua aposta de 6 n�meros em ordem crescente
aposta = [7 13 36 42 53 57];
%============================================= END USER

%Se vari�vel 'sorteios' j� existir no Workspace,
%n�o � neces�rio ler novamente.
if (~exist('sorteios', 'var'))
    sorteios = getMega; %l� megasena.csv
end

%Busca sorteio mais pr�ximo
[sortMaisProx dist] = queryMega(aposta, sorteios)
%ver tamb�m queryMegaVec

%Mostra resultado
disp(['Sua aposta:           ' num2str(aposta)])
disp(['Sorteio mais pr�ximo na queryMega: ' num2str(sortMaisProx),...
    ' (d=' num2str(dist) ')'])

[sortMaisProx dist] = queryMegaVec(aposta, sorteios)
%ver tamb�m queryMegaVec

%Mostra resultado
disp(['Sua aposta:           ' num2str(aposta)])
disp(['Sorteio mais pr�ximo na queryMegaVec: ' num2str(sortMaisProx),...
    ' (d=' num2str(dist) ')'])

%Busca sorteio mais pr�ximo
[sortMaisProx dist] = queryMegaHits(aposta, sorteios)
%ver tamb�m queryMegaVec

%Mostra resultado
disp(['Sua aposta:           ' num2str(aposta)])
disp(['Sorteio mais pr�ximo na queryMegaHits: ' num2str(sortMaisProx),...
    ' (d=' num2str(dist) ')'])