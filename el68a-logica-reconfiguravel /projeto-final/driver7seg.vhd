library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.seven_seg_pkg.all;

entity driver7seg is
  generic (
    N7SegPrimario : integer := 4
  );
  port (
    clk                   : in std_logic;
    reset                 : in std_logic;
    score                 : in integer range 0 to ((10 ** N7SegPrimario) - 1);
    saidaPrimaria         : out seven_segment_output(N7SegPrimario-1 downto 0)
  );
end entity driver7seg;

architecture aDriver7Seg of driver7seg is
begin

    saidaPrimaria(0) <= seven_seg_numbers(score mod 10);
		seg_gen: for i in 1 to N7SegPrimario-1 generate
      saidaPrimaria(i) <= seven_seg_numbers(score / (10 ** i) mod 10);
    end generate;

end architecture aDriver7Seg;
