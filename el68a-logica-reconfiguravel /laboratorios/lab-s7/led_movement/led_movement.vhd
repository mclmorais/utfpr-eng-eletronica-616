library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity led_movement is
    generic(
        CLOCK_VALUE         : integer := 50000000;
        MOVEMENT_PERIOD     : integer := 50;
	    N              		 : integer := 10
    );
    port (
        clk                 : in    std_logic;
        led_outputs         : out   std_logic_vector(N-1 downto 0);
        trail_length	    : in 	integer
    );

end entity led_movement;


architecture a_led_movement of led_movement is
begin  
    process(clk, trail_length)
        variable initial_setup  : boolean := true;
        variable count          : integer := 0;
        variable h              : integer := trail_length-1;
        constant period_cycles  : integer := MOVEMENT_PERIOD * ((CLOCK_VALUE / 1000));
    begin
        if rising_edge(clk) then

            -- Sets up initial LEDs' position
            if initial_setup then
                led_outputs <= std_logic_vector(to_unsigned(( (2 ** trail_length) - 1 ), N));
                initial_setup := false;
            end if;

            -- Updates LEDs' position
            count := count + 1;
            if count > MOVEMENT_PERIOD * ((CLOCK_VALUE / 1000)) then
                led_outputs((h + 1) mod N) <= '1';
                led_outputs((h - trail_length + 1) mod N) <= '0';
                h := (h + 1) mod N;
                count := 0;
            end if;
        end if;
    end process;
  
  
end architecture a_led_movement;