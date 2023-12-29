library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity switches_to_binary is
  port (
    inputs  : in std_logic_vector(9 downto 0);
    outputs : out unsigned(9 downto 0);
    display_outputs : out std_logic_vector(6 downto 0)
  );
end entity switches_to_binary;

architecture a_switches_to_binary of switches_to_binary is
  type int_array is array(0 to 9) of integer;
  signal integral : int_array;
  signal s_outputs : unsigned(9 downto 0);
begin
    integral(0) <= 1 when inputs(0) = '1' else 0;
    for_gen: for i in 1 to 9 generate
      integral(i) <= integral(i-1) + 1 when inputs(i) = '1' else integral(i-1);
    end generate;
  outputs <= to_unsigned(integral(9), 10);

  display_outputs <= "1000000" when integral(9) = 0 else
                     "1111001" when integral(9) = 1 else
                     "0100100" when integral(9) = 2 else
                     "0110000" when integral(9) = 3 else
                     "0011001" when integral(9) = 4 else
                     "0010010" when integral(9) = 5 else
                     "0000010" when integral(9) = 6 else
                     "1111000" when integral(9) = 7 else
                     "0000000" when integral(9) = 8 else
                     "0010000" when integral(9) = 9 else
                     "0001000" when integral(9) = 10 else
                     "0000000";

end architecture a_switches_to_binary;