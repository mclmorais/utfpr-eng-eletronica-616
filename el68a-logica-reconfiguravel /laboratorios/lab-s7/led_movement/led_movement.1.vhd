library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity led_movement is
    generic(
        CLOCK_VALUE         : integer := 50000000;
        MOVEMENT_PERIOD     : integer := 200;
	    N              		 : integer := 10
    );
    port (
        clk                 : in    std_logic;
        led_outputs         : out   std_logic_vector(N-1 downto 0)
    );

end entity led_movement;


architecture a_led_movement of led_movement is
  
begin
  
    process(clk)
        variable L              : integer := 5;
        variable initial_setup  : boolean := true;
        variable count          : integer := 0;
        variable h              : integer := L - 1;
        variable period_cycles  : integer := MOVEMENT_PERIOD * ((CLOCK_VALUE / 1000));
        variable change_L       : integer := 0;
    begin
        if rising_edge(clk) then

            -- Sets up initial LEDs' position
            if initial_setup then
                led_outputs <= std_logic_vector(to_unsigned(( (2 ** L) - 1 ), N));
                initial_setup := false;
            end if;

            -- Updates LEDs' position
            count := count + 1;
            if count > period_cycles then
                led_outputs((h + 1) mod N) <= '1';
                led_outputs((h - L + 1) mod N) <= '0';
                h := (h + 1) mod N;
                count := 0;
                change_L := change_L + 1;
            end if;

            if L_changed then
                
            end if;

            
            if change_L > 30 then
                L := 2;
            end if;
            if change_L > 60 then
                L := 7;
                change_L := 0;
            end if;
        end if;
    end process;
  
  
end architecture a_led_movement;