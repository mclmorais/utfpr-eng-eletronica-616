-- Testbench created online at:
--   www.doulos.com/knowhow/perl/testbench_creation/
-- Copyright Doulos Ltd
-- SD, 03 November 2002

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity size_control_tb is
end;

architecture bench of size_control_tb is

  component size_control is
    generic(output_size: integer := 8);
    Port (  increase: in std_logic;
            decrease: in std_logic;
            output_vector: out std_logic_vector(0 to output_size-1);
            clk: in std_logic
  );
end component;

  signal increase: std_logic;
  signal decrease: std_logic;
  signal output_vector: std_logic_vector(0 to 8-1);
  signal clk: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: size_control 
  port map ( increase      => increase,
            decrease      => decrease,
            output_vector => output_vector,
            clk           => clk );

  stimulus: process
  begin
  
    -- Put initialisation code here
    increase <= '0';
    decrease <= '0';
    wait for 10 ns;
    -- Put test bench stimulus code here
    increase <= '0';
    decrease <= '0';
    wait for 10 ns;

    increase <= '0';
    decrease <= '0';
    wait for 10 ns;
    
    increase <= '1';
    decrease <= '0';
    wait for 10 ns;
    increase <= '1';
    decrease <= '0';
    wait for 10 ns;
    increase <= '1';
    decrease <= '0';
    wait for 10 ns;
    increase <= '1';
    decrease <= '0';
    wait for 10 ns;
    increase <= '1';
    decrease <= '0';
    wait for 10 ns;
    increase <= '1';
    decrease <= '0';
    wait for 10 ns;
    increase <= '1';
    decrease <= '0';
    wait for 10 ns;
    increase <= '1';
    decrease <= '0';
    wait for 10 ns;
    increase <= '1';
    decrease <= '0';
    wait for 10 ns;
    increase <= '1';
    decrease <= '0';
    wait for 10 ns;
    increase <= '1';
    decrease <= '0';
    wait for 10 ns;
    increase <= '1';
    decrease <= '0';
    wait for 10 ns;
    increase <= '0';
    decrease <= '1';
    wait for 10 ns;
    increase <= '0';
    decrease <= '1';
    wait for 10 ns;
    increase <= '0';
    decrease <= '1';
    wait for 10 ns;
    increase <= '0';
    decrease <= '1';
    wait for 10 ns;
    increase <= '0';
    decrease <= '1';
    wait for 10 ns;
    increase <= '1';
    decrease <= '1';
    wait for 10 ns;
    increase <= '1';
    decrease <= '1';
    wait for 10 ns;
    increase <= '1';
    decrease <= '1';
    wait for 10 ns;
    increase <= '0';
    decrease <= '0';
    wait for 10 ns;
    increase <= '0';
    decrease <= '0';
    wait for 10 ns;
    increase <= '0';
    decrease <= '0';
    wait for 10 ns;
    increase <= '0';
    decrease <= '0';
    wait for 10 ns;
    increase <= '1';
    decrease <= '1';
    wait for 10 ns;
    increase <= '0';
    decrease <= '1';
    wait for 10 ns;
    increase <= '0';
    decrease <= '1';
    wait for 10 ns;
    increase <= '0';
    decrease <= '1';
    wait for 10 ns;
    increase <= '0';
    decrease <= '1';
    wait for 10 ns;
    increase <= '0';
    decrease <= '1';
    wait for 10 ns;
    increase <= '0';
    decrease <= '1';
    wait for 10 ns;

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;