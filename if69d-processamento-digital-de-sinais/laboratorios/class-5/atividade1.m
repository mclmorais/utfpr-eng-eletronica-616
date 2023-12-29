clear all;
close all;
clc;

%Exercicio 5.1

A = ones(5,5);
H = [5 5 -3; 5 0 -3; -3 -3 -3];

B = imfilter(A,H)
C = imfilter(A,H,'conv')
H2 = fliplr(flip(H)); 
C2 = imfilter(A,H2)
D = imfilter(A,H,'replicate')
E = imfilter(A,H,'full')