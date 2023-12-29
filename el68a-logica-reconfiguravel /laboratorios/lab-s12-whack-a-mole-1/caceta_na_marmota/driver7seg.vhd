library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.seven_seg_pkg.all;

entity driver7seg is
  generic (
    N7SegPrimario : integer := 2;
    N7SegSecundario : integer := 2
  );
  port (w
    estado                : in std_logic;
    clk                   : in std_logic;
    rst                   : in std_logic;
    entradaTempo          : in integer range 0 to ((10 ** N7SegPrimario) - 1);
    entradaPontosMaximos  : in integer range 0 to ((10 ** N7SegPrimario) - 1);
    entradaPontosAtuais   : in integer range 0 to ((10 ** N7SegSecundario) - 1);
    saidaPrimaria         : out seven_segment_output(N7SegPrimario downto 0);
    saidaSecundaria       : out seven_segment_output(N7SegPrimario downto 0)
  );
end entity driver7seg;

architecture aDriver7Seg of driver7seg is
		saidaSecundaria(0) <= seven_seg_numbers(entradaPontosAtuais mod 10);
		seg_gen: for i in 1 to N7SegSecundario-1 generate
      saidaSecundaria(i) <= seven_seg_numbers(entradaPontosAtuais / (10 ** i) mod 10);
    end generate;

    saidaPrimaria(0) <= seven_seg_numbers(entradaTempo mod 10) when estado = '1' else seven_seg_numbers(entradaPontosMaximos mod 10);
		seg_gen: for i in 1 to N7SegPrimario-1 generate
      saidaPrimaria(i) <= seven_seg_numbers(entradaTempo / (10 ** i) mod 10) when  estado = '1' else seven_seg_numbers(entradaPontosMaximos / (10 ** i) mod 10)
    end generate;
begin
  
  
  
end architecture aDriver7Seg;