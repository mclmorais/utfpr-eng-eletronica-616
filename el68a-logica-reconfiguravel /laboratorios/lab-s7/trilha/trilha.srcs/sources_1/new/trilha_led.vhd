----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Diogo Knop
-- 
-- Create Date: 11.05.2019 23:23:35
-- Design Name: 
-- Module Name: trilha_led - arc_trilha_led
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

entity trilha_led is
    generic(output_size: INTEGER := 8);

    Port (  speed_control_in:  in std_logic_vector(0 to 2);
            tail_size:      in std_logic_vector(0 to 1);
            clockwise:      in std_logic;
            clk:            in std_logic;
            leds_output:    out std_logic_vector(0 to output_size-1)
    );
end trilha_led;

architecture arc_trilha_led of trilha_led is
  signal leds_output_buffer_s: std_logic_vector(0 to output_size-1);
  signal speed_control_s: std_logic;

component size_control is
    generic(output_size: integer := 8);
    Port (  increase: in std_logic;
            decrease: in std_logic;
            output_vector: out std_logic_vector(0 to output_size-1);
            clk: in std_logic
    );
end component size_control;
  
component motion_control is
    generic(output_size: integer := 8);
    Port (move_in : in std_logic;
          clk : in std_logic;
          clockwise_in : in std_logic;
          input_vector: in std_logic_vector(0 to output_size-1);
          output_leds:  out std_logic_vector(0 to output_size-1)
    );
end component motion_control;

component speed_control is
    generic( n_inputs: integer := 3;
            clock_value: integer := 100000000
    ); 
    Port (  speed_buttons: in std_logic_vector(0 to n_inputs-1);
            speed_output: out std_logic;
            clk: in std_logic    
    );
end component speed_control;

begin
    SP_CONTROL: component speed_control
    port map(
        speed_buttons=>speed_control_in,
        speed_output=>speed_control_s,
        clk=>clk
    );
    
    SZ_CONTROL: component size_control
    port map(
        increase=>tail_size(0),
        decrease=>tail_size(1),
        output_vector=>leds_output_buffer_s,
        clk=>clk
    );
    
    MTN_CONTROL: component motion_control
    port map(
        clockwise_in=>clockwise,
        move_in=>speed_control_s,
        output_leds=>leds_output,
        input_vector=>leds_output_buffer_s,
        clk=>clk
    );
    
--process(clk)
--    begin
--    if(rising_edge(clk)) then
--        --leds_output <= leds_output_buffer_s;
--    end if;
--    end process ; -- identifier
end arc_trilha_led;