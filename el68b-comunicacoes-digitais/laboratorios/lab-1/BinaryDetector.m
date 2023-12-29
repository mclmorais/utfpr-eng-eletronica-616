function resultado = BinaryDetector(y, Fs, setPoint)

somador = 0;
resultado = [];
for i=1:length(y)
    
    if(y(i) > 0) 
        valor = 1; 
    else 
        valor = -1 ;
    end
    
    somador=somador+valor;
    if(mod(i,Fs)==0)
        if(somador > setPoint)
            resultado = [resultado, 1];
            %push(resultado,[1]);
        else
            resultado = [resultado, 0];
            %push(resultado,[0]);
        end
        somador=0;
    end 
end