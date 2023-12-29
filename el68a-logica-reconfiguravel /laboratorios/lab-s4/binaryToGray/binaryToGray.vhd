library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binaryToGray is
	port (
		grayToBinary: in std_logic;
		inputs 	: in std_logic_vector(9 downto 0);
		outputs	: out std_logic_vector(9 downto 0)
	);
end binaryToGray;

architecture arcbinaryToGray of binaryToGray is
signal outputs_s : std_logic_vector(9 downto 0);
begin
	outputs_s(9) <= inputs(9);
	link_for: 
	for I in 8 downto 0 generate
			outputs_s(I) <= inputs(I+1) xor inputs(I) when grayToBinary = '1' else --binary to gray when button is released
								 outputs_s(I+1) xor inputs(I); --gray to binary when button is pressed
	end generate link_for;
	outputs <= outputs_s;
end arcbinaryToGray;