library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity switchDetector is
	port (
		switchIn : in unsigned(9 downto 0);
		ledOut	: out unsigned(9 downto 0)
	);
end switchDetector;

architecture arcSwitchDetector of switchDetector is
begin
	ledOut <= switchIn(9 downto 0);

end arcSwitchDetector;