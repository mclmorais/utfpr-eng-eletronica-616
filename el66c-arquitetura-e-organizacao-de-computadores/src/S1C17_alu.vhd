--************************************************************
-- S1C17 ALU
-- EQUIPE 6 - MARCELO E JOAO
-- Unidade lógica aritmética com operações de soma, subtração e divisão,
-- além de comparação em flags Zero e Carry. Utiliza valores aritméticos de 24 
-- bits.
--************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity s1c17_alu is
    port (
        op          : in unsigned(1 downto 0);
        in_a, in_b  : in unsigned(23 downto 0);
        zf, cf      : out std_logic;
        out_value   : out unsigned(23 downto 0)
    );
end s1c17_alu;

architecture a_s1c17_alu of s1c17_alu is

    --O sinal aritmetico possui 1 bit a mais para avaliacao do flag
    signal arith_s : signed(24 downto 0) := "0000000000000000000000000";
    signal in_a_s, in_b_s : signed(24 downto 0);

    begin

        in_a_s <= resize(signed(in_a), 25);
        in_b_s <= resize(signed(in_b), 25);

        arith_s <=  in_a_s + in_b_s    when op="00" else
                    in_a_s - in_b_s    when op="01" else
                    in_a_s / in_b_s    when op="11" else
                    "0000000000000000000000000";


        -- flag <= '1' when (op = "10") and (in_A >= in_B) else
        --         '0';
        
        --Determinacao da flag de carry (bit extra)
        cf <= arith_s(24);

        zf <=   '1' when arith_s = (arith_s'range => '0') 
                    else
		        '0';

        out_value <= unsigned(arith_s(23 downto 0));

end a_s1c17_alu;