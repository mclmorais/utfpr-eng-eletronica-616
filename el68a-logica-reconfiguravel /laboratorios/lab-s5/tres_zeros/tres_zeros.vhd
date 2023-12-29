library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tres_zeros is
  generic(N : integer := 10);
  port (
    switches_input : in std_logic_vector(N-1 downto 0);
    led_output     : out std_logic
  );
end entity tres_zeros;

architecture a_tres_zeros of tres_zeros is
  signal detected : std_logic_vector(N-3 downto 0);
begin

  adder_for: for i in N-3 downto 0 generate
    detected(i) <= (not switches_input(i) and not switches_input(i+1)) and not switches_input(i+2);
  end generate;

    led_output <= '1' when unsigned(detected) > 0 else '0';
end architecture;