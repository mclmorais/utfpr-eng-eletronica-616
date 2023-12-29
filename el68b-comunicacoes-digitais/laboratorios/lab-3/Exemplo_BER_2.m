%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INTRODUCAO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Neste exemplo N0 eh mantido fixo e a amplitude dos simbolos varia em funcaoo
% da relacao Eb/N0. Outra alternativa eh manter a amplitude dos simbolos fixa e
% variar N0 em funcao de Eb/N0.
%
% A resposta ao impulso do filtro casado eh considerada de energia unitaria
% (EMF=1)
%
% Os simbolos 's' sao gerados originalmente como +1 e -1, com energia
% unitaria portanto, e sua amplitude eh variada de acordo com o valor de Eb
% necessario para obter a razao Eb/N0 pretendida.
%
% A simulacao eh discreta, a partir dos simbolos a serem transmitidos (s)
% geramos a saida amostrada do filtro casado (y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;
clc

% CONFIGURACAO DE ESTADO INICIAL PARA AS FUNCOES RANDOMICAS
rand('state',0);
randn('state',0);

% DEFINICOES GERAIS DA SIMULACAO
bits = 15e6;        % Numero de bits a serem simulados.
M = 2;              % 2-PAM, dois simbolos possiveis na modulacao.
N0 = 1;             % N0 sera fixa em 1.
EbN0dBmax = 15;     % Valor de Eb/N0 a ser considerado na simulacao.

% GERACAO DOS VETORES DE TRANSMISSAO E DE RUIDO
b=rand(1,bits)>0.5;           % Geracao de bits 0 e 1 equiprovaveis.
n=randn(1,bits)*sqrt(N0/2);   % EMF foi suposto como 1, portanto a variancia do
                              % ruido apos o filtro casado eh N0/2 apenas.
n2=randn(1,bits)*sqrt(N0/2);  % EMF foi suposto como 1, portanto a variancia do
                              % ruido apos o filtro casado eh N0/2 apenas.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CASO ANTIPODAL 2-PAM (1 bit -> 1 simbolo)
% Eb = Es = 1 (Amplitudes +1 e -1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INICIALIZACAO
s=2*b-1;                    % Geracao do sinal de transmissao modelando 2-PAM.
ber = zeros(1,EbN0dBmax);   % Criação do vetor de BER para otimizar o codigo.

% LOOP PARA VARIACAO DA RELACAO SINAL RUIDO
for EbN0dB = 0:EbN0dBmax
    EbN0=10^(EbN0dB/10);        % Eb/N0 em escala linear.
    Eb=EbN0*N0;                 % Eb para atingir a razao Eb/N0 de interesse.
    Es=Eb*log2(M);              % Es calculado a partir de Eb, 2-PAM: Eb = Es.

    y=sqrt(Es)*1*s+n;             % MODELO DISCRETO: A amplitude do sinal
                                % transmitido é dada por sqrt(ES), 's' eh a
                                % sequencia de bits a transmitir (ja em 2-PAM) e
                                % 'n' eh o vetor de ruido amostrado.
                                % Neste caso EMF = 1.

    b_est=y>0;                  % Decisor [se y>0 -> 1 senao -> 0].
    erros=sum(b~=b_est);        % Contagem de erros com base na diferenca entre
                                % os vetores.

    ber(EbN0dB+1)= erros/bits;  % Calculo da BER.
end

% EXIBICAO GRAFICA
EbN0dB = 0:EbN0dBmax;           % Criacao do vetor do eixo horizontal (Eb/N0)
                                % para grafico simulado.
EbN0dBT = 0:EbN0dBmax;          % Criacao do vetor do eixo horizontal (Eb/N0)
                                % para grafico teorico.

EbN0T = 10.^(EbN0dBT/10);       % Linearizacao da escala log para BER teorica.
Pb = qfunc(sqrt(2*EbN0T));      % Calculo da probabilidade de erro teorica.

figure;
semilogy(EbN0dBT,Pb,'r',EbN0dB,ber,'s');
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CASO ORTOGONAL (1 bit -> 1 simbolo)
% Eb = Es = 1
% Amplitude 1: y1 = 1 / y0 = 0
% Amplitude 0: y1 = 0 / y0 = 1
% Ruido para y1 eh diferente do ruido para y2 (condição necessaria)
% Vetores de transmissão já criados
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LOOP PARA VARIACAO DA RELACAO SINAL RUIDO
for EbN0dB = 0:EbN0dBmax
    EbN0=10^(EbN0dB/10);          % Eb/N0 em escala linear.
    Eb=EbN0*N0;                   % Eb requerido para atingir a razao Eb/N0 de
                                  % interesse.
    Es=Eb*log2(M);                % Es calculado a partir de Eb.
                                  % Para modulacao binária: Es = Eb.

    y1 = (b) * sqrt(Es)*1+n;      % Geracao dos sinais ortogonais
    y0 = (~b) * sqrt(Es)*1+n2;    % Geracao dos sinais ortogonais
    b_est = y1 > y0;                % Decisor [y1>y0 -> '1' senao -> '0']
    erros=sum(b~=b_est);          % Contagem de erros com base na diferenca dos
                                  % vetores.
    ber(EbN0dB+1)= erros/bits;    % Calculo da BER.
end

EbN0dB = 0:EbN0dBmax;             % Criacao do vetor do eixo horizontal (Eb/N0)
                                  % para grafico simulado.
EbN0dBT = 0:EbN0dBmax;            % Criacao do vetor do eixo horizontal (Eb/N0)
                                  % para grafico teorico.
EbN0T = 10.^(EbN0dBT/10);         % Linearizacao da escala log para BER teorica.
Pb = qfunc(sqrt(EbN0T));          % Calculo da probabilidade de erro teorica.

hold on;
semilogy(EbN0dBT,Pb,'r',EbN0dB,ber,'s');
figure;
semilogy(EbN0dBT,Pb,'r',EbN0dB,ber,'s');
grid on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
