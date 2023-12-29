%y = f(x)
t = 0:1:20; %eixo x do gráfico
C = 250;
a = 60;
b = 0.6;
p = C./(1 + (a*exp(-b*t)));
plot(t, p, 'r-.', 'LineWidth', 2);
hold on %mantém a útima curva plotada
C = 250;
a = 60;
b = 0.4;
p = C./(1 + (a*exp(-b*t)));
plot(t, p, 'g-*', 'LineWidth', 2);
hold off %desabilita o hold
%Legenda
legend('0.6', '0.4', 1)
%1:canto sup. dir. 2:canto sup. esq.
%3:canto inf. esq. 4:canto inf. dir.
%limites dos eixos: axis([xmin xmax ymin ymax])
axis([0 20 0 max(p)+10]);
%Espaçamento entre os "ticks"
set(gca,'XTick',0:1:20);
%Label dos "ticks"
set(gca,'XTickLabel',0:1:20);
grid on;
xlabel('t'); %label do eixo X
ylabel('P(t)'); %label do eixo y
title('Gráficos 2D'); %título
