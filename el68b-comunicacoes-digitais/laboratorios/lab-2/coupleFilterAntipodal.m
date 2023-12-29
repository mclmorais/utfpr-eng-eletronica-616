function saida_antipodal = coupleFilterAntipodal(y, Fs,N)
h=ones(1,Fs);
  
r=conv(y,h)/Fs;
t_amostra=[];
for a=1:1:N
  t_amostra = [t_amostra a*Fs];
end
r_amostra=r(t_amostra);

saida_antipodal=[];
for a = r_amostra
  if(a > 0)
    saida_antipodal = [saida_antipodal, 1];
  else
    saida_antipodal = [saida_antipodal, 0];
  end
end
