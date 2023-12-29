----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Diogo Knop
-- 
-- Create Date: 12.05.2019 20:32:16
-- Design Name: 
-- Module Name: size_control - arc_size_control
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

entity size_control is
    generic(output_size: integer := 8);
    Port (  increase: in std_logic;
            decrease: in std_logic;
            output_vector: out std_logic_vector(0 to output_size-1);
            clk: in std_logic
  );
end size_control;

architecture arc_size_control of size_control is

    signal increase_s_in, increase_s_out : std_logic;
    signal decrease_s_in, decrease_s_out : std_logic;

    signal zeros_vector: std_logic_vector(0 to output_size-1) := (others => '0');
    signal ones_vector: std_logic_vector(0 to output_size-1) := (others => '1');

    component debounce is
        generic( n_inputs: integer := 1;
                 debounce_ms: integer := 100;
                 clock_value: integer := 100000000
        );
        port( clk: in std_logic;
              button_in: in std_logic_vector(0 to n_inputs-1);
              pulse_out: out std_logic_vector(0 to n_inputs-1)
        );
      end component debounce;
begin
    increase_debounce: component debounce
    port map(
        button_in(0)=>increase_s_in,
        pulse_out(0)=>increase_s_out,
        clk=>clk
    );
    decrease_debounce: component debounce
    port map(
        button_in(0)=>decrease_s_in,
        pulse_out(0)=>decrease_s_out,
        clk=>clk
    );

process(clk)

    variable size: integer := 1;
    variable size_changed: std_logic := '0';

begin
    increase_s_in <= increase;
    decrease_s_in <= decrease;
    if(rising_edge(clk)) then
        if ((increase_s_out = '1') and (size < output_size-1) and size_changed = '0') then
            size := size+1;
            size_changed := '1';
        end if;
        if ((decrease_s_out = '1') and (size > 1) and size_changed = '0') then
            size := size-1;
            size_changed := '1';
        end if;
        if((increase_s_out = '0') and (decrease_s_out = '0')) then
            size_changed := '0';
        end if;
        for I in 0 to (output_size-1) loop
            if (I < size) then
                output_vector(I) <= '1';
            else
                output_vector(I) <= '0';
            end if;
        end loop;
    end if;
end process ; -- identifier

end arc_size_control;