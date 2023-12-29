library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package seven_seg_pkg is
    type seven_segment_output is array(integer range <>) of std_logic_vector(6 downto 0);
end package seven_seg_pkg;
