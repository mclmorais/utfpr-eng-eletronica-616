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
  type nibble_array is array(N-1 downto 0) of integer;
  signal adder : nibble_array;
  signal detected : std_logic_vector(0 to N-1);
begin

  adder(0) <= 1 when switches_input(0) = '0' else 0; --unsigned(switches_input(0)); 
  detected(0) <= '0';
  
  adder_for: for i in 1 to N-1 generate
    adder(i) <= adder(i-1) + 1 when switches_input(i) = '0' else 0;
    detected(i) <= '1' when adder(i) > 3 else '0';
  end generate;

    led_output <= '1' when unsigned(detected) > 0 else '0';
end architecture;