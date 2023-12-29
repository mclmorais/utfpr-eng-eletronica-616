library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ControladorMarretas is
	generic( NUM_HOLES : integer := 10;
					CLOCK_RATE : integer := 50_000_000);
				
	port	( 	clk : in std_logic;
				marretada: out std_logic_vector((NUM_HOLES-1) downto 0);
				marreta : in std_logic_vector((NUM_HOLES-1) downto 0)); --Chaves
end entity;

architecture aControladorMarretas of ControladorMarretas is
	-- Sinais da Marreta
	signal marretada1 : std_logic_vector(NUM_HOLES-1 downto 0);
	signal marretaAnterior : std_logic_vector(NUM_HOLES-1 downto 0);
	
begin
	
	--
	-- Entrada Marreta
	--
	process (clk) is
	begin
		if rising_edge(clk) then	
			marretada1 <= marreta and (not marretaAnterior);
			marretaAnterior <= marreta;	
		end if;
	end process;

	marretada <= marretada1;
	

end architecture;