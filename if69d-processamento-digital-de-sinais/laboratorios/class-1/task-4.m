clear, close all
clc
%Aloca uma cell array
myCell = cell(1,3);
%Cell do lado esquerdo do '='
myCell{1} = magic(5);
myCell{2} = magic(4);
myCell{3} = magic(3);

%Display
% whos myCell
% disp('myCell{1} = '), disp(myCell{1})
% disp('myCell{2} = '), disp(myCell{2})
% disp('myCell{3} = '), disp(myCell{3})

for i = 1:3
   sum(myCell{i}, 2) 
end
% disp('myCell{4} = '), disp(myCell{4})
% disp(' ')
% disp('Cell array � vers�til!')
% disp('Armazena dados de qualquer')
% disp('classe e tamanho.')
% disp('Aperta uma tecla a� pra continuar.')
% disp('=================================')
% pause
% %Cell do lado esquerdo do '='
% myCell{1} = 1000;
% myCell{2}(5) = 9;
% myCell{3}(2,3) = 50;
% myCell{4}(end-1:end) = [];
% 
% %Display
% disp('myCell{1} = '), disp(myCell{1})
% disp('myCell{2} = '), disp(myCell{2})
% disp('myCell{3} = '), disp(myCell{3})
% disp('myCell{4} = '), disp(myCell{4})
% disp(' ')
% disp('Vc alterou o conte�do das cells do cell array.')
% disp('Aperta uma tecla a� pra continuar.')
% disp('=================================')
% pause
% %Cell do lado direito do '='
% %'()' retorna uma cell do cell array
% d = myCell(3);
% %Display
% whos d
% disp('Fazendo d = myCell(3), ''d'' � uma cell')
% disp('Aperta uma tecla a� pra continuar.')
% disp('=================================')
% pause
% %Cell do lado direito do '='
% %'{}' retorna o conte�do de uma cell do cell array
% e = myCell{3};
% %Display
% whos e
% disp('Fazendo e = myCell{3}, ''e'' � o conte�do da cell')
% disp('Aperta uma tecla a� pra continuar.')
% disp('=================================')
% pause
% cellplot(myCell)
% disp('A fun��o cellplot mostra a organiza��o do cell array')
% disp('Acabou')
