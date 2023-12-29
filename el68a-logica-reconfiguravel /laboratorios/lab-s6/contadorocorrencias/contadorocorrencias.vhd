-----------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-----------------------------------------------------------
package seven_segment_types is
    type seven_seg_number is array (0 to 15) of std_logic_vector(6 downto 0);
    constant seven_seg_numbers : seven_seg_number := (
        "1000000", -- 0
        "1111001", -- 1
        "0100100", -- 2
        "0110000", -- 3
        "0011001", -- 4
        "0010010", -- 5
        "0000010", -- 6
        "1111000", -- 7
        "0000000", -- 8
        "0010000", -- 9
        "0001000", -- A
        "0000011", -- B
        "1000110", -- C
        "0100001", -- D
        "0000110", -- E
        "0001110"  -- F
    );
    type seven_segment_output is array(integer range <>) of std_logic_vector(6 downto 0);
end package seven_segment_types;

use work.seven_segment_types.all;
-----------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
-----------------------------------------------------------
entity detecocorrencias is
  generic(
		N     : integer := 7;
		P     : integer := 3;
		N7Seg : integer := 4;
		valorpadrao: std_logic_vector := "101"
  );
  port (
    vetorbusca      : in std_logic_vector(0 to N-1);
	 display_outputs : out seven_segment_output(N7Seg-1 downto 0) 
	 ocorrencia     : out std_logic
  );
end entity detecocorrencias;
-----------------------------------------------------------
architecture a_detecocorrencias of detecocorrencias is
  type int_array is array(0 to N-P) of integer;
  signal adder : int_array; 
  --signal detected : std_logic_vector(0 to N-1);
  constant padrao : std_logic_vector(0 to P-1) := valorpadrao;
begin

  adder(0) <= 1 when padrao = vetorbusca(0 to P-1) else 0;
		
  adder_for: for i in 1 to N-P generate
  adder(i) <= adder(i-1)+1 when padrao = vetorbusca(i to i+P-1) else
				  adder(i-1);
  end generate;
		-- Mostra resultado no display 7 segmentos
		display_outputs(0) <= seven_seg_numbers(adder(N-P) mod 10);
		seg_gen: for i in 1 to N7Seg-1 generate
      display_outputs(i) <= seven_seg_numbers(adder(N-P) / (10 * i) mod 10);
    end generate;

  ocorrencia <= '1' when adder(N-P) > 0 else '0';
end architecture;
-----------------------------------------------------------