function [smp dcb] = queryMega(aps, allMs)
%[smp dcb] = queryMega(aps, allMs) calcula a dist�ncia city-block
%(diferen�a absoluta) entre a aposta 'aps' e todos os sorteios em 'allMs'.
%Retorna o sorteio que apresentou a menor dit�ncia em 'smp'
%e a dist�ncia em 'cb'.
%Veja tamb�m:  gamble_mega, getMega.

%Verifica se aps cont�m 6 n�meros
if (length(aps) ~= 6)
    error('Aposte 6 n�meros.')
end

%Cada sorteio em ordem crescente
allMsSorted = sort(allMs, 2);

%Numero de sorteios
ns = size(allMsSorted, 1); %numero de linhas

%Distancia city-block entre a aposta 'aps' e
%cada sorteio em 'AllMsSorted'
d = zeros(ns,1); %aloca vetor para distancias

% for i = 1:ns
%     for j = 1:6
%         for k = 1:6
%             menores(k) = aps(j) - allMsSorted(1,k);
%         end
%         menor(j) = min(menores(k));
%     end
%     d(i) = sum( abs(aps - allMsSorted(i,:)));
% end
aps = repmat(aps, ns, 1);
d =  sum(ismember(allMsSorted, aps), 2);

%Dist�ncias em ordem crescente e os �ndices
[dSorted idx] = sort(d,'descend');
%Os �ndices em 'idx' correspondem � ordena��o de 'd'.
%Portanto, o primeiro �ndice em 'idx' corresponde ao
%sorteio mais pr�ximo em 'allMsSorted'
smp = allMsSorted(idx(1),:);
dcb = dSorted(1);