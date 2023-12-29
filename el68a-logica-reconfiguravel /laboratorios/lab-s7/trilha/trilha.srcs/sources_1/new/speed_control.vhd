----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2019 20:32:17
-- Design Name: 
-- Module Name: speed_control - arc_speed_control
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

entity speed_control is
    Generic( n_inputs: integer := 3;
            clock_value: integer := 100000000
    ); 
    Port (  speed_buttons: in std_logic_vector(0 to n_inputs-1);
            speed_output: out std_logic;
            clk: in std_logic    
    );
end speed_control;

architecture arc_speed_control of speed_control is

signal btn_speed_in, btn_speed_out : std_logic_vector(0 to n_inputs-1);

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

    GEN_DB: 
    for I in 0 to n_inputs-1 generate
        DBX : debounce 
        port map (  clk => clk, 
                    button_in(0)=>speed_buttons(I),
                    pulse_out(0)=>btn_speed_out(I)
        );
    end generate GEN_DB;
   
    process(clk)
    
    type T_SPEEDS  is array (integer range <>) of integer;
    constant SPEEDS : T_SPEEDS(0 to n_inputs-1) := (41,100,500);
    
    variable speed_selected : integer := 0;
    variable speed_counter : integer := 0;
    begin
        if (rising_edge(clk)) then
            if (btn_speed_out = "001") then
                speed_selected := 0;
            elsif (btn_speed_out = "010") then
                speed_selected := 1;
            elsif (btn_speed_out = "100") then
                speed_selected := 2;
            end if;
            speed_counter := speed_counter + 1;
            if(speed_counter >= (SPEEDS(speed_selected)*(clock_value/1000))) then
                speed_output <= '1';
                speed_counter := 0;
            else
                speed_output <= '0';
            end if;
        end if;
    end process;

end arc_speed_control;
