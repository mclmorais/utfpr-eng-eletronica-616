function [med , dp] = estatComponente(comp, tipoc)
%cad = clienteMaiorMov(clientLoc, mes)
%Fun��o que varre as estruturas em clienteLoc e
%devolve em cad o cadastro do cliente com maior
%movimenta��o no m�s especificado pelo
%par�metro de entrada mes.
%Exemplo: c = clienteMaiorMov(cliente, 3);
%Veja tamb�m: script que cria o vetor de %estruturas 'cliente'.
%O n�mero de clientes � o n�mero de estruturas
%do vetor de estruturas
horas = [comp.horas];
horas = horas([comp.tipo] == tipoc);

med = sum(horas)/length(horas);

dp = std(horas);
