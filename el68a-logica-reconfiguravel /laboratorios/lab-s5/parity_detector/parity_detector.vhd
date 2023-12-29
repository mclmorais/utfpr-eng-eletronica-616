library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity parity_detector is
GENERIC ( N : INTEGER := 10 );
	port (
		input 	: in std_logic_vector(N-2 downto 0);
		output 	: out std_logic_vector(N-1 downto 0);
		sel_even	: in std_logic -- even when release, odd when pressed
	);
end parity_detector;

architecture arcparity_detector of parity_detector is
	signal xor_array 	: std_logic_vector(N-3 downto 0);
	signal bit_parity : std_logic;
begin
	xor_array(0) <= input(0) xor input(1);
	F1: for I in 1 to N-3 generate
		xor_array(I) <= xor_array(I-1) xor input(I+1);
	end generate;
	bit_parity <= sel_even xnor xor_array(N-3);
	output <= bit_parity & input(N-2 downto 0);
end arcparity_detector;