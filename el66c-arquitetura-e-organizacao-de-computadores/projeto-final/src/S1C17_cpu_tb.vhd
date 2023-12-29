--************************************************************
-- S1C17 CENTRAL PROCESSING UNIT TEST BENCH
-- EQUIPE 6 - MARCELO E JOAO
-- Unidade que inicializa sinais externos de clock e reset para funcionamento
-- da CPU.
--************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_tb is
end cpu_tb;

architecture a_cpu_tb of cpu_tb is

    component cpu is
        port(
            clk : in std_logic;
            rst : in std_logic
        );
    end component cpu;

    signal clock_s : std_logic := '0';
    signal reset_s : std_logic := '0';


begin

    uut : cpu 
        port map(
            clk => clock_s,
            rst => reset_s
        );

    process
    begin
        clock_s <= '0';
        wait for 50 ns;
        clock_s <= '1';
        wait for 50 ns;
    end process;

    process
    begin
        reset_s <= '0';
        wait for 10 ns;
        reset_s <= '1';
        wait for 10 ns;
        reset_s <= '0';
        wait;
    end process;

end a_cpu_tb ; -- a_cpu_tb