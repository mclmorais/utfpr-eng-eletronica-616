library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity led_rotation is
  generic (
    LEDS_N  	: integer := 10;
	 CLOCK_HZ	: integer := 50000000;
	 TIME_MS		: integer := 500
  );
  port (
    clk        : in std_logic;
    led_output : out std_logic_vector(0 to LEDS_N-1)
  );
end entity led_rotation;

architecture a_led_rotation of led_rotation is
signal ledoutput_s : std_logic_vector(0 to LEDS_N-1);
constant cycles_s : integer := (TIME_MS)*(CLOCK_HZ/1000);
begin

process(clk, ledoutput_s)
variable i : integer :=0;
variable clk_count : integer :=0;
  begin        

    if rising_edge(clk) then
      if clk_count >= cycles_s then
        ledoutput_s <= (others => '0');
        ledoutput_s(i) <= '1';
        -- ledoutput_s <= (i => '1', others  => '0');
        i := (i + 1) mod LEDS_N;
        clk_count := 0;
      end if;
      clk_count := clk_count + 1;
    end if;
    led_output <= ledoutput_s;
  end process;
  
end architecture a_led_rotation;