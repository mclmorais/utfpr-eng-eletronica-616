%gamble_mega [script]

%================================================= USER
% Sua aposta de 6 números em ordem crescente
aposta = [7 13 36 42 53 57];
%============================================= END USER

%Se variável 'sorteios' já existir no Workspace,
%não é necesário ler novamente.
if (~exist('sorteios', 'var'))
    sorteios = getMega; %lê megasena.csv
end

%Busca sorteio mais próximo
[sortMaisProx dist] = queryMega(aposta, sorteios)
%ver também queryMegaVec

%Mostra resultado
disp(['Sua aposta:           ' num2str(aposta)])
disp(['Sorteio mais próximo na queryMega: ' num2str(sortMaisProx),...
    ' (d=' num2str(dist) ')'])

[sortMaisProx dist] = queryMegaVec(aposta, sorteios)
%ver também queryMegaVec

%Mostra resultado
disp(['Sua aposta:           ' num2str(aposta)])
disp(['Sorteio mais próximo na queryMegaVec: ' num2str(sortMaisProx),...
    ' (d=' num2str(dist) ')'])

%Busca sorteio mais próximo
[sortMaisProx dist] = queryMegaHits(aposta, sorteios)
%ver também queryMegaVec

%Mostra resultado
disp(['Sua aposta:           ' num2str(aposta)])
disp(['Sorteio mais próximo na queryMegaHits: ' num2str(sortMaisProx),...
    ' (d=' num2str(dist) ')'])