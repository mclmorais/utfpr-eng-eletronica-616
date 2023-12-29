function saida_ortogonal = coupleFilterOrtogonal(y, Fs, N)

h0 = [-ones(1,Fs/2) ones(1,Fs/2)];
h1 = ones(1,Fs);

t_amostra=[];
for a=1:1:N
  t_amostra = [t_amostra a*Fs];
end

%Filtro para bit 1
r1=conv(y,h1)/Fs;
r1_amostra=r1(t_amostra);

%Filtro para bit 0
r0=conv(y,h0)/Fs;
r0_amostra=r0(t_amostra);


saida_ortogonal = [];
for a=1:1:length(r0_amostra)
  if(r1_amostra(a) > r0_amostra(a))
    saida_ortogonal = [saida_ortogonal, 1];
  else
    saida_ortogonal = [saida_ortogonal, 0];
  end
end