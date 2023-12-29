library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity booleanOperator is
	port (
		inputA : in std_logic;
		inputB : in std_logic;
		inputC : in std_logic;
		ledOut : out std_logic_vector(7 downto 0)
	);
end booleanOperator;

architecture aBooleanOperator of booleanOperator is
signal ledOutS : std_logic_vector(7 downto 0) := "00000000";
begin
	--and
	ledOutS(0) <= inputA and inputB and inputC;
	--or
	ledOutS(1) <= inputA or inputB or inputC;
	--buffer
	ledOutS(2) <= inputA or inputB or inputC;
	--nand
	ledOutS(3) <= not(inputA and inputB and inputC);
	--nor
	ledOutS(4) <= not(inputA or inputB or inputC);
	--not
	ledOutS(5) <= (not inputA) or (not inputB) or (not inputC);
	--xor
	ledOutS(6) <= inputA xor inputB xor inputC;--(inputA and inputB and inputC) or (inputA and not inputB and not inputC) or ( not inputA and inputB and not inputC) or ( not inputA and not inputB and inputC);
	--xnor
	ledOutS(7) <= not(inputA xor inputB xor inputC);
	
	ledOut <= ledOutS;
	
end aBooleanOperator;