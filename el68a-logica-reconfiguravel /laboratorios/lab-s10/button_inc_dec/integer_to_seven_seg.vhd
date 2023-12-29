library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.seven_seg_pkg.all;

entity integer_to_seven_seg is
    generic (
        N7Seg : integer
    );
    port (
        clk         : in std_logic;
        integer_in  : in integer;
        out_seg     : out seven_segment_output(N7Seg-1 downto 0)
    );
end entity integer_to_seven_seg;

architecture a_integer_to_seven_seg of integer_to_seven_seg is
    signal separate_numbers :  seven_segment_output(N7Seg-1 downto 0);
begin
    
    process(clk, integer_in)
        variable calculated_value : integer;
        variable digit_output : integer;-- range 15 downto 0;
    begin
        calculated_value := integer_in;
        for i in N7Seg-1 downto 0 loop
            digit_output := calculated_value / (10 ** i);
            calculated_value := calculated_value - (digit_output * (10 ** i));
            case digit_output is
                when 0 =>
                    separate_numbers(i) <= "1000000";
                when 1 =>
                    separate_numbers(i) <= "1111001"; -- 1
                when 2 =>
                    separate_numbers(i) <= "0100100"; -- 2
                when 3 =>
                    separate_numbers(i) <= "0110000"; -- 3
                when 4 =>
                    separate_numbers(i) <= "0011001"; -- 4
                when 5 =>
                    separate_numbers(i) <= "0010010"; -- 5
                when 6 =>
                    separate_numbers(i) <= "0000010"; -- 6
                when 7 =>
                    separate_numbers(i) <= "1111000"; -- 7
                when 8 =>
                    separate_numbers(i) <= "0000000"; -- 8
                when 9 =>
                    separate_numbers(i) <= "0010000"; -- 9
                when 10 =>
                    separate_numbers(i) <= "0001000"; -- A
                when 11 =>
                    separate_numbers(i) <= "0000011"; -- B
                when 12 =>
                    separate_numbers(i) <= "1000110"; -- C
                when 13 =>
                    separate_numbers(i) <= "0100001"; -- D
                when 14 =>
                    separate_numbers(i) <= "0000110"; -- E
                when 15 =>
                    separate_numbers(i) <= "0001110";  -- F
                when others =>
                    separate_numbers(i) <= "1010101";  -- ? Erro
            end case;
        end loop;
    end process;

    out_seg <= separate_numbers;
end architecture a_integer_to_seven_seg;