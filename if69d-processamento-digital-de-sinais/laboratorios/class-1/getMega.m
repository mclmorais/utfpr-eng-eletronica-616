function [ms] = getMega(csvFile)
%[ms] = getMega(csvFile) l� o arquivo .CSV 'csvFile' com todos os sorteios
%da megasena e retorna os valores em uma matriz m-por-n, onde n � o n�mero de
%sorteios e n=6. 'csvFile' default = 'megasena.csv'.
%Veja tamb�m: gamble_mega, queryMega.

if (nargin < 1)
    csvFile = 'megasena.csv';
end

ms = csvread(csvFile);