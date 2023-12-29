%Exemplo Antipodal
close all
clc

Fs=100;
Ts=1;

erroAntipodal = [];
erroOrtogonal = [];
numeroDeBits = 500;

noiseStep = 0.5;

for nivelRuido = 1:noiseStep:100

    bit1=ones(1,Fs);
    bit0=-ones(1,Fs);

    %disp('Antipodal')

    arrayInicial = randi([0 1], numeroDeBits, 1)';
    y = CreateAnalogueArray(arrayInicial, bit0, bit1);


    t=0:1/Fs:numeroDeBits-1/Fs;

    fim=length(y);
    ruido=randn(1,fim)*sqrt(nivelRuido);%Potencia do ruido=100
    y=y+ruido;


    somador=0;

    resultado = BinaryDetector(y, Fs, 0);

    erroAntipodal = [erroAntipodal, CalculateError(arrayInicial, resultado)];

    %Exemplo Ortogonal


    %disp('Ortogonal')
    bit1=ones(1,Fs);
    bit0=[ones(1,Fs/2) -ones(1,Fs/2)];
    y = CreateAnalogueArray(arrayInicial, bit0, bit1);

    fim=length(y);
    ruido=randn(1,fim)*sqrt(nivelRuido); %Potencia do ruido=100
    y=y+ruido;

    resultado = BinaryDetector(y, Fs, 0.5);

    erroOrtogonal = [erroOrtogonal, CalculateError(arrayInicial, resultado)];

    yRx = CreateAnalogueArray(resultado, bit0, bit1);
end
concat = [erroAntipodal, erroOrtogonal];
maxError = floor(max(concat));

figure
hold on
x = 1:noiseStep:100;
plot(x, erroAntipodal)
ylabel('erro (%)');
xlabel('ruido (%)');
axis([0 100 0 maxError])
x = 1:noiseStep:100;
plot(x, erroOrtogonal)
ylabel('erro (%)');
xlabel('ruido (%)');
axis([0 100 0 maxError])
legend("Antipodal", "Ortogonal");

hold off

