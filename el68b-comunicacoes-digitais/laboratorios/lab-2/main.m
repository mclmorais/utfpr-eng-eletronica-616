%Exemplo Antipodal
close all
clc
clear all

Fs=100;
Ts=1;

noiseStep = 0.5;
erroAntipodalDKMF = zeros(1, 100/noiseStep);
erroAntipodalFiltroCasado = zeros(1, 100/noiseStep);
erroOrtogonalDKMF = zeros(1, 100/noiseStep);
erroOrtogonalFiltroCasado = zeros(1, 100/noiseStep);
erroOrtogonalPPM = zeros(1, 100/noiseStep);
numeroDeBits = 1000;


% Cria array de bits
arrayInicial = randi([0 1], numeroDeBits, 1)';

% Cria onda analogica de bits
ondaAntipodal = CreateAnalogueArray(arrayInicial, -ones(1,Fs), ones(1,Fs));

ondaOrtogonal = CreateAnalogueArray(arrayInicial, [ones(1,Fs/2) -ones(1,Fs/2)], ones(1,Fs));

ondaPPM = CreateAnalogueArray(arrayInicial, [ones(1,Fs/2) -ones(1,Fs/2)], [-ones(1,Fs/2) ones(1,Fs/2)]);


t=0:1/Fs:numeroDeBits-1/Fs;

figure
x = noiseStep:noiseStep:100;
ylabel('erro (%)');
xlabel('ruido (%)');
axis([0 100 0 50])

for nivelRuido = 1:noiseStep:100

  
    ruido = randn(1, length(ondaAntipodal)) * sqrt(nivelRuido);

    % Antipodal    

    % Soma ruido na onda de bits
    y = ondaAntipodal + ruido;

    resultadoDKMF = BinaryDetector(y, Fs, 0);
    resultadoFiltroCasado = coupleFilterAntipodal(y, Fs, numeroDeBits);
    
    erroAntipodalDKMF(nivelRuido/noiseStep) = CalculateError(arrayInicial, resultadoDKMF);
    erroAntipodalFiltroCasado(nivelRuido/noiseStep) = CalculateError(arrayInicial, resultadoFiltroCasado);



    %Ortogonal

    % Soma ruido na onda de bits
    y = ondaOrtogonal + ruido;

    resultadoDKMF = BinaryDetector(y, Fs, 0.7);
    resultadoFiltroCasado = coupleFilterOrtogonal(y, Fs, numeroDeBits);

    erroOrtogonalDKMF(nivelRuido/noiseStep) = CalculateError(arrayInicial, resultadoDKMF);
    erroOrtogonalFiltroCasado(nivelRuido/noiseStep) = CalculateError(arrayInicial, resultadoFiltroCasado);


    y = ondaPPM + ruido;
    
    resultadoFiltroCasado = coupleFilterOrtogonalPPM(y, Fs, numeroDeBits);
    erroOrtogonalPPM(nivelRuido/noiseStep) = CalculateError(arrayInicial, resultadoFiltroCasado);

    plot(x, erroAntipodalDKMF);
    hold on
    plot(x, erroAntipodalFiltroCasado);
    hold off
    hold on
    plot(x, erroOrtogonalDKMF);
    hold off
    hold on
    plot(x, erroOrtogonalFiltroCasado);
    hold off
    hold on
    plot(x, erroOrtogonalPPM);
    hold off
    legend("Antipodal DKMF", "Antipodal Filtro Casado", "Ortogonal DKMF", "Ortogonal Filtro Casado","PPM Filtro Casado");

    drawnow;

end


