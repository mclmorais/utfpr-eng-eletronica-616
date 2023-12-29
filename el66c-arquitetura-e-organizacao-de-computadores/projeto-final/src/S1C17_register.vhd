--************************************************************
-- S1C17 REGISTER
-- EQUIPE 6 - MARCELO E JOAO
-- TODO: Registrador simples de 24 bits.
--************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity s1c17_register is
  port (
    clk      : in    std_logic;
    rst      : in    std_logic;
    wen      : in    std_logic;
    data_in  : in    unsigned(23 downto 0);
    data_out : out   unsigned(23 downto 0)
  );
end s1c17_register;


architecture a_s1c17_register of s1c17_register is

    signal register_s: unsigned(23 downto 0) := "000000000000000000000000";

begin
    process (clk, rst, wen)
    begin
        --Se reset estiver ativo, manda '0' na saida
        if rst = '1' then
            register_s <= "000000000000000000000000";
        --Se houver um pulso de clock quando este registrador estiver ativo,
        --escreve o dado da entrada na saida
        elsif wen = '1' then
            if rising_edge(clk) then
                register_s <= data_in;
            end if;
        end if;

    end process;

    data_out <= register_s;

end a_s1c17_register;