----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.05.2019 16:16:21
-- Design Name: 
-- Module Name: debounce - arc_debounce
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

entity debounce is
  generic( n_inputs: integer := 1;
           debounce_ms: integer := 100;
           clock_value: integer := 500000000);
  Port ( clk: in std_logic;
         button_in: in std_logic_vector(0 to n_inputs-1);
         pulse_out: out std_logic_vector(0 to n_inputs-1));
end debounce;

architecture arc_debounce of debounce is
type INT_ARRAY  is array (integer range <>) of integer;
signal count_array: INT_ARRAY(0 to n_inputs);
signal pulse_out_s: std_logic_vector(0 to n_inputs-1);

begin
process(clk)
    begin
    if(rising_edge(clk)) then
        for I in 0 to (n_inputs-1) loop
            if(button_in(I) /= pulse_out_s(I)) then
                if(count_array(I) <= (debounce_ms*(clock_value/1000))) then
                    count_array(I) <= count_array(I)+1;
                end if;
            else
                count_array(I) <= 0;
            end if;
            if(count_array(I) >= (debounce_ms*(clock_value/1000))) then
                pulse_out_s(I) <= button_in(I);
            end if;
        end loop;
        pulse_out <= pulse_out_s;
    end if;  
end process;

end arc_debounce;
