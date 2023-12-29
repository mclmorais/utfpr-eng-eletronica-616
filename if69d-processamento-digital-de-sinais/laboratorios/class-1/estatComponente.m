function [med , dp] = estatComponente(comp, tipoc)
%cad = clienteMaiorMov(clientLoc, mes)
%Função que varre as estruturas em clienteLoc e
%devolve em cad o cadastro do cliente com maior
%movimentação no mês especificado pelo
%parâmetro de entrada mes.
%Exemplo: c = clienteMaiorMov(cliente, 3);
%Veja também: script que cria o vetor de %estruturas 'cliente'.
%O número de clientes é o número de estruturas
%do vetor de estruturas
horas = [comp.horas];
horas = horas([comp.tipo] == tipoc);

med = sum(horas)/length(horas);

dp = std(horas);
