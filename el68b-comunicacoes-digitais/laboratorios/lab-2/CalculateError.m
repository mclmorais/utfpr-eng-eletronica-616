function erro = CalculateError(arrayInicial, resultado)

acertos = 0;
for i = 1 : length(resultado)
   if(resultado(i) == arrayInicial(i))
       acertos = acertos + 1;
   end
end

erro = (1 - (acertos / length(resultado))) * 100;