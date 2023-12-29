----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2019 18:25:37
-- Design Name: 
-- Module Name: speed_control_tb - arc_speed_control_tb
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity speed_control_tb is
--  Port ( );
end speed_control_tb;

architecture arc_speed_control_tb of speed_control_tb is

  component speed_control
      Generic( n_inputs: integer := 3;
              clock_value: integer := 100000000
      ); 
      Port (  speed_buttons: in std_logic_vector(0 to n_inputs-1);
              speed_output: out std_logic;
              clk: in std_logic    
      );
  end component;

  signal speed_buttons: std_logic_vector(0 to 3-1);
  signal speed_output: std_logic;
  signal clk: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: speed_control port map ( speed_buttons => speed_buttons,
                                   speed_output  => speed_output,
                                   clk           => clk );

  stimulus: process
  begin
  
    -- Put initialisation code here


    -- Put test bench stimulus code here

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


end arc_speed_control_tb;
