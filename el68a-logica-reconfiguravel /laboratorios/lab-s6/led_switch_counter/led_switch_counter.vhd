library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity led_switch_counter is
generic ( N : integer := 10 );
  port (
    inputs  : in std_logic_vector(N-1 downto 0);
    outputs : out std_logic_vector(N-1 downto 0)
  );
end entity led_switch_counter;

architecture a_led_switch_counter of led_switch_counter is
  type int_array is array(0 to N-1) of integer;
  signal adder : int_array;
begin 
    adder(0) <= 1 when inputs(0) = '1' else 0;
    for_gen: for i in 1 to N-1 generate
      adder(i) <= adder(i-1) + 1 when inputs(i) = '1' else adder(i-1);
    end generate;

    out_gen: for i in 0 to N-1 generate
      outputs(i) <= '1' when adder(N-1) > i else '0';
    end generate;

end architecture a_led_switch_counter;