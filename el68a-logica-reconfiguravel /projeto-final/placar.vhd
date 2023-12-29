library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.spaceInvadersConstants.all;
use work.seven_seg_pkg.all;

entity placar is
	port(
		  clk:   			in std_logic;
		  reset: 			in std_logic;
		  inimigoMorreu:  in std_logic; -- Indica colisão com o inimigo.
		  passouFase: 		in std_logic;
--		  score: 			out integer;
		  score: 		   out seven_segment_output(3 downto 0)
	);
end entity;

architecture arch of placar is
	component driver7seg is
						generic (
									N7SegPrimario : integer := 4
						);
						port (
								clk                   : in std_logic;
								reset                 : in std_logic;
								score                 : in integer range 0 to ((10 ** N7SegPrimario) - 1);
								saidaPrimaria         : out seven_segment_output(N7SegPrimario-1 downto 0)
						);
	end component;
	
	signal score_value: integer;
	begin
	
		driver: driver7seg port map(clk => clk, reset => reset, score => score_value, saidaPrimaria => score);
		
		process(clk, reset, inimigoMorreu, passouFase)
			begin
			if reset = '0' then
				score_value <= 0;
			else
				if clk'event and clk = '1' then
					if inimigoMorreu = '1' then
						score_value <= score_value + 1;
					elsif passouFase = '1' then
						score_value <= score_value + 100;
					end if;
				end if;
			end if;
		end process;
			
end architecture;