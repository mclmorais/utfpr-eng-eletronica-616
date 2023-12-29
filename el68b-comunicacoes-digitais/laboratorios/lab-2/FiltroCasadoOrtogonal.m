% Inicialização
close all
clear all
clc

% Declarações de Tempo
Fs=100;
Ts=1;

% Declaração de Bits
bit1=ones(1,Fs);
bit0=[ones(1,Fs/2) -ones(1,Fs/2)];

y=[bit1 bit0 bit1 bit0 bit1];
t=0:1/Fs:5-1/Fs;

% Plot dos Bits
plot(t,y)
xlabel('tempo (s)');
axis([0 5 -2 2])

% Plot da resposta ao impulso dos filtros
figure
subplot(1, 2, 1);
h1 = ones(1,Fs);
h0 = [-ones(1,Fs/2) ones(1,Fs/2)];
t=0:1/Fs:1-1/Fs;
plot(t,h1);
subplot(1, 2, 2);
plot(t,h0);
xlabel('tempo (s)');
ylabel('h(t)');
axis([0 1 -2 2])

figure
% Saida do filtro para convolução com bit 1
subplot(1,2,1)
r1=conv(y,h1)/Fs;
fim=length(r1);
t=0:1/Fs:fim/Fs-1/Fs;
plot(t,r1);

t_amostra=[Fs 2*Fs 3*Fs 4*Fs 5*Fs];
r1_amostra=r1(t_amostra);
t_amostra=t_amostra/Fs-1/Fs;
hold
stem(t_amostra,r1_amostra,'r')

xlabel('tempo (s)');
legend('Saída do Filtro Bit 1');
axis([0 5 -2 2])

% Saida do filtro para convolução com bit 0
subplot(1,2,2)
r0=conv(y,h0)/Fs;
fim=length(r0);
t=0:1/Fs:fim/Fs-1/Fs;
plot(t,r0);

t_amostra=[Fs 2*Fs 3*Fs 4*Fs 5*Fs];
r0_amostra=r0(t_amostra);
t_amostra=t_amostra/Fs-1/Fs;
hold
stem(t_amostra,r0_amostra,'r')
xlabel('tempo (s)');
legend('Saída do Filtro Bit 0');
axis([0 5 -2 2])

saida_ortogonal = [];
for a=1:1:length(r0_amostra)
  if(r1_amostra(a) > r0_amostra(a))
    saida_ortogonal = [saida_ortogonal, 1];
  else
    saida_ortogonal = [saida_ortogonal, 0];
  end
end


figure
fim=length(y);
ruido=randn(1,fim)*sqrt(20);
y=y+ruido;

t=0:1/Fs:5-1/Fs;
plot(t,y)
xlabel('tempo (s)');
axis([0 5 -12 12])

figure
r1=conv(y,h1)/Fs;
fim=length(r1);
t=0:1/Fs:fim/Fs-1/Fs;
plot(t,r1);
t_amostra=[Fs 2*Fs 3*Fs 4*Fs 5*Fs];
r0_amostra=r1(t_amostra);
t_amostra=t_amostra/Fs-1/Fs;
hold
stem(t_amostra,r0_amostra,'r')
xlabel('tempo (s)');
legend('Sa?da do Filtro','Sa?da Amostrada');


