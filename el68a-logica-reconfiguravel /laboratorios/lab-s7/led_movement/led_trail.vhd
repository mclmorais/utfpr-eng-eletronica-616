library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity led_trail is
    generic(
        N : integer := 10;
        CLOCK_VALUE         : integer := 50000000;
        MOVEMENT_PERIOD     : integer := 3000
    );
    port (
        clk                 : in    std_logic;
        led_outputs         : out   std_logic_vector(N-1 downto 0)
    );
end entity led_trail;

architecture a_led_trail of led_trail is

	signal L : integer := 0;

    component led_movement is
    generic(
        CLOCK_VALUE         : integer := 50000000;
        MOVEMENT_PERIOD     : integer := 200;
	    N              		 : integer := 10
    );
    port (
        clk                 : in    std_logic;
        led_outputs         : out   std_logic_vector(N-1 downto 0);
        trail_length	    : in 	integer
    );
    end component led_movement;
begin


    c_led_movs : component led_movement
    port map(
        clk => clk,
        led_outputs => led_outputs,
        trail_length => L
    );
process(clk, L)
variable count          : integer := 0;
constant period_cycles  : integer := MOVEMENT_PERIOD * ((CLOCK_VALUE / 1000));
begin
    if rising_edge(clk) then
        count := count + 1;
        if count > period_cycles then
            L <= (L + 1) mod N;
            count := 0;
        end if;
    end if;
end process;

    
end architecture a_led_trail;