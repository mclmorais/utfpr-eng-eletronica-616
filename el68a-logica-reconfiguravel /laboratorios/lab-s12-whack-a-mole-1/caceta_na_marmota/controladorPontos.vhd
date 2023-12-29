library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity controladorPontos is
    port (
        clk             : in std_logic;
        rst             : in std_logic;
        marcouPonto     : in std_logic;
        estado          : in std_logic;
        saidaAtual      : out integer;
        saidaMaxima     : out integer;
    );
end entity controladorPontos;

architecture aControladorPontos of controladorPontos is
  
begin

    process(clk, marcouPonto)
        variable pontuacaoAtual : integer := 0
        variable pontuacaoMaxima : integer := 0
    begin
        
        if rst = '1' then
            pontuacaoAtual := 0;
            pontuacaoMaxima := 0;
        elsif rising_edge(clk)
            if estado = '1' then
                if marcouPonto = '1' then
                    pontuacaoAtual := pontuacaoAtual + 1;
                    if pontuacaoAtual > pontuacaoMaxima then
                        pontuacaoMaxima := pontuacaoMaxima + 1;
                    end if;
                end if;
            elsif estado = '0' then
                pontuacaoAtual := 0;
            end if;
            saidaAtual <= pontuacaoAtual;
            saidaMaxima <= pontuacaoMaxima;
        end if;
    end process;

  
  
end architecture aControladorPontos;