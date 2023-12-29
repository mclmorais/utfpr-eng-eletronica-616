function y = CreateAnalogueArray(arrayInicial,bit0Definition, bit1Definition)
y = [];
for a= 1 : length(arrayInicial)
    if(arrayInicial(a)>0)
        y=[y bit1Definition];
    else
        y=[y bit0Definition];
    end
end