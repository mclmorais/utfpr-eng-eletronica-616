library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity button_debounce is
  generic (
    CLOCK_HZ    : integer := 50000000;
    DEBOUNCE_MS : integer := 1000
  );
  port (
    button_in : in  std_logic;
    led_out   : out std_logic;
    clk       : in std_logic;
    debouncing_out : out std_logic;
    debounced_out : out std_logic
  );
end entity button_debounce;

architecture a_button_debounce of button_debounce is
  constant c_cycles : integer := DEBOUNCE_MS * (CLOCK_HZ / 1000);
  signal   s_led_out  : std_logic;
  signal clk_count : integer := 0;
    signal debouncing : boolean := false;
  signal debounced  : boolean := false;

begin
  
        debounced_out <= '1' when debounced else '0';
        debouncing_out <= '1' when debouncing else '0';
process(clk, button_in)



    begin
        if rising_edge(clk) then
            if button_in = '0' and not debounced then
                debouncing <= true;
            elsif debounced and button_in = '1' then
                debounced <= false;
            elsif debouncing then
                if clk_count < c_cycles then
                    s_led_out <= '1';
                    clk_count <= clk_count + 1;
                else
                    s_led_out <= not button_in;
                    clk_count <= 0;
                    debouncing <= false;
                    debounced <= true;
                end if;

            end if;


    end if;

-- begin
--   if  rising_edge(clk) then
--     if(debouncing and clk_count < c_cycles) then
--       s_led_out <= '1';
--       clk_count <= clk_count + 1;
--     else 
--       debouncing := false;
--       s_led_out <= button_in;
--       clk_count <= 0;
--     end if;
--   end if;  

--   if(rising_edge(button_in)) then
--     debouncing := true;
--   end if;
--   
end process;

led_out <= s_led_out;
  
  
end architecture a_button_debounce;
