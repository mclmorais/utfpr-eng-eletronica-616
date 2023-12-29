library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

PACKAGE MY IS
type rom_type10 is array (0 to 9) of std_logic_vector(9 downto 0);
type rom_type8 is array (0 to 7) of std_logic_vector(7 downto 0);
CONSTANT enemySprite: rom_type10 := (
	"0000000000",
	"0000000000",
	"0010000100",
	"0001001000",
	"0011111100",
	"0110110110",
	"1111111111",
	"1011111101",
	"1010000101",
	"0001001000"
);
CONSTANT playerSprite: rom_type10 := (
	"0000110000",
	"0000110000",
	"0001111000",
	"0111111110",
	"0111111110",
	"1111111111",
	"1111111111",
	"0000000000",
	"0000000000",
	"0000000000"
);
CONSTANT projectileSprite: rom_type10 := (
	"0000000000",
	"0000000000",
	"0000000000",
	"0000110000",
	"0000110000",
	"0000110000",
	"0000110000",
	"0000000000",
	"0000000000",
	"0000000000"
);
CONSTANT heartSprite: rom_type8 := (
	"01101100", -- 0  ** **
	"11111110", -- 1 *******
	"11111110", -- 2 *******
	"11111110", -- 3 *******
	"11111110", -- 4 *******
	"01111100", -- 5  *****
	"00111000", -- 6   ***
	"00010000"  -- 7    *
);
PROCEDURE SQ(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;SIGNAL RGB:OUT STD_LOGIC_VECTOR(3 downto 0);SIGNAL DRAW: OUT STD_LOGIC);
END MY;

PACKAGE BODY MY IS
PROCEDURE SQ(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;SIGNAL RGB:OUT STD_LOGIC_VECTOR(3 downto 0);SIGNAL DRAW: OUT STD_LOGIC) IS
BEGIN
 IF(Xcur>Xpos AND Xcur<(Xpos+100) AND Ycur>Ypos AND Ycur<(Ypos+100))THEN
	 RGB<="1111";
	 DRAW<='1';
	 ELSE
	 DRAW<='0';
 END IF;
 
END SQ;
END MY;