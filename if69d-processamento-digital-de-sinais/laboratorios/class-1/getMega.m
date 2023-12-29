function [ms] = getMega(csvFile)
%[ms] = getMega(csvFile) lê o arquivo .CSV 'csvFile' com todos os sorteios
%da megasena e retorna os valores em uma matriz m-por-n, onde n é o número de
%sorteios e n=6. 'csvFile' default = 'megasena.csv'.
%Veja também: gamble_mega, queryMega.

if (nargin < 1)
    csvFile = 'megasena.csv';
end

ms = csvread(csvFile);