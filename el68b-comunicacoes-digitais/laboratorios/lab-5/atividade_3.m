close all;
clear all;
clc

%%
%%M-QAM:
M = [4 16 64];
C = [];
for index = 1:length(M)
    range = -(sqrt(M(index))-1):2:(sqrt(M(index))-1);
    for l = range
        for m = range
           C = [C l+1j*m]; 
        end
    end
end
%%
%%M-QAM:
M = [4 16 64];
C = [];
for index = 1:length(M)
    for l = -(sqrt(M(index))-1):2:(sqrt(M(index))-1)
        for m = -(sqrt(M(index))-1):2:(sqrt(M(index))-1)
           C = [C l+1j*m]; 
        end
    end
end


QAM4 = C(1:M(1));
QAM16 = C(M(1)+1:M(1)+M(2));
QAM64 = C(M(1)+M(2)+1:end);

scatterplot(QAM4);
title('4-QAM Sem Ruído');

scatterplot(QAM16);
title('16-QAM Sem Ruído');

scatterplot(QAM64);
title('64-QAM Sem Ruído');

%%
%%M-PSK:
M = [2 4 8 16];
C = [];
for index = 1:length(M)
    for l = 1:M(index)
        C = [C exp((1j*2*pi*l)/M(index))]; 
    end
end

PSK2 = C(1:M(1));
PSK4 = C(M(1)+1:M(1)+M(2));
PSK8 = C(M(1)+M(2)+1:M(1)+M(2)+M(3));
PSK16 = C(M(1)+M(2)+M(3)+1:end);

scatterplot(PSK2);
title('BPSK Sem Ruído');


scatterplot(PSK4);
title('QPSK Sem Ruído');


scatterplot(PSK8);
title('8-PSK Sem Ruído');


scatterplot(PSK16);
title('16-PSK Sem Ruído');
%%
BS2 = randint(8,1,2);
BS4 = randint(32,1,4);
BS8 = randint(128,1,8);
BS16 = randint(512,1,16);
BS64 = randint(8192,1,64);

Pot = .0025;

ruido2 = randn(size(BS2)).*sqrt(Pot)+1j.*randn(size(BS2)).*sqrt(Pot);
ruido4 = randn(size(BS4)).*sqrt(Pot)+1j.*randn(size(BS4)).*sqrt(Pot);
ruido8 = randn(size(BS8)).*sqrt(Pot)+1j.*randn(size(BS8)).*sqrt(Pot);
ruido16 = randn(size(BS16)).*sqrt(Pot)+1j.*randn(size(BS16)).*sqrt(Pot);
ruido64 = randn(size(BS64)).*sqrt(Pot)+1j.*randn(size(BS64)).*sqrt(Pot);
%%
scatterplot((PSK2(BS2+1))'+ruido2);
title('BPSK Com Ruído');

scatterplot((PSK4(BS4+1))'+ruido4);
title('QPSK Com Ruído');

scatterplot(PSK8(BS8+1)'+ruido8);
title('8-PSK Com Ruído');

scatterplot(PSK16(BS16+1)'+ruido16);
title('16-PSK Com Ruído');
%%
scatterplot((QAM4(BS4+1))'+ruido4);
title('4-QAM Com Ruído');

scatterplot((QAM16(BS16+1))'+ruido16);
title('16-QAM Com Ruído');

scatterplot((QAM64(BS64+1))'+ruido64);
title('64-QAM Com Ruído');