--************************************************************
-- S1C17 PROCESS STATUS REGISTER
-- EQUIPE 6 - MARCELO E JOAO
-- TODO: Registrador de (originalmente) 8 bits que guarda 
-- variaveis de status interno do processador.
-- nesta entidade, apenas as flags de carry e zero foram
-- implementadas.
--************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity s1c17_status_register is
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        wen          : in  std_logic;
        c_in, z_in   : in  std_logic;
        c_out, z_out : out std_logic
    );
end s1c17_status_register;


architecture a_status_register of s1c17_status_register is

    signal c_s, z_s : std_logic;

begin
    process (clk, rst, wen)
    begin
        --Se reset estiver ativo, manda '0' na saida
        if rst = '1' then
            c_s <= '0';
            z_s <= '0';
        --Se houver um pulso de clock quando este registrador estiver ativo,
        --escreve o dado da entrada na saida
        elsif wen = '1' then
            if rising_edge(clk) then
                c_s <= c_in;
                z_s <= z_in;
            end if;
        end if;

    end process;

    c_out <= c_s;
    z_out <= z_s;

end a_status_register;