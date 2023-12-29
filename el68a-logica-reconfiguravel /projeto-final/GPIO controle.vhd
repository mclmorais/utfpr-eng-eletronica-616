Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
------------
entity CONTROLE is
	port(		--(esquerda,	direita,	tiro)
		controle1: 				IN std_logic_vector 	(2 downto 0);  --PORTAS: AA15; AA14; AB13
		controle2:				IN std_logic_vector 	(2 downto 0);	--PORTAS: AB10; AB8;	AB5
		action_player1: 		OUT std_logic_vector (2 downto 0);
		action_player2: 		OUT std_logic_vector (2 downto 0));
end entity;
------------
architecture CONTROLE  of CONTROLE is
	begin
		action_player1 <= not controle1;
		action_player2 <= not controle2;
		
end architecture;