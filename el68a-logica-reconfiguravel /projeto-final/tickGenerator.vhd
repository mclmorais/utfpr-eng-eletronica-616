--	tickGenerator
--
-- Author: Adriano Ricardo de Abreu Gamba
--
-- Date: 07/2019
--
-- Federal University of Technology - Paraná
-- Discipline: Reconfigurable Logic - 2019-1
-- 
--	Description: tickGenerator is a component of the final subject project
-- "Space Invaders". This code aims to create clock ticks to be used by other
-- project components. These generated ticks will be used as reference times 
-- to update the status of the objects in the screen, thus controlling the 
-- movement speed of these objects.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tickGenerator is
	generic ( CLOCK 				: integer := 50000000;	
				 TICKINIMIGO 			: integer := 5e6;		-- 100 ms
				 TICKJOGADOR 			: integer := 25e5; 	-- 50 ms
				 TICKTIROINIMIGO 	: integer := 1e6; 	-- 20 ms
				 TICKTIROJOGADOR 	: integer := 5e5; 	-- 10 ms
				 DEC_RATE_INIMIGO : integer := 1);  -- Taxa de decremento da velocidade do inimigo
				 
	port ( clk, reset, start : in std_logic;
			 tick_inimigo, tick_jogador, tick_tiro_inimigo, tick_tiro_jogador : out std_logic;
			 acabou_inimigos: in std_logic;
			 jogadores_perderam: in std_logic;
			 currentLevel : out integer range 0 to 1000;
			 gameState : out std_logic;
			 levelRunning: out std_logic);
end entity;

architecture tickGenerator of tickGenerator is
	signal cntTickInimigo: integer range 0 to CLOCK := 0;
	signal cntTickJogador: integer range 0 to CLOCK := 0;
	signal cntTickTiroInimigo: integer range 0 to CLOCK := 0;
	signal cntTickTiroJogador: integer range 0 to CLOCK := 0;
	signal level: integer range 0 to 1000 := 0;
	signal tickInimigoGenerated : std_logic := '0';
	signal clock2In : std_logic;
	signal clock2Out : std_logic;
	
begin
	currentLevel <= level;
	clock2In <= not (clk);

	
	--
	-- tick_inimigo generator
	-- Aqui é feita também a atualizaçao do level. A cada vez que o sinal
	-- acabou_inimigos é levado para '1', aumenta 1 level.
	-- aumentar level implica em diminuir a velocidade do inimigo port
	-- por uma taxa de DEC_RATE_INIMIGO
	--
	process (clk, reset, acabou_inimigos) is
	variable flagIncrementLevel : boolean := true;
	begin
		if reset = '0' then
			cntTickInimigo <= 0;
			tickInimigoGenerated <= '0';
			flagIncrementLevel := true;
			level <= 0;
			levelRunning <= '0';
		elsif falling_edge(clk) then
			if acabou_inimigos = '1' then
				cntTickInimigo <= 0;
				tickInimigoGenerated <= '0';
				levelRunning <= '1';
				if flagIncrementLevel = true then
					level <= level + 1;
					flagIncrementLevel := false;
				end if;
			elsif cntTickInimigo >= (TICKINIMIGO-level*DEC_RATE_INIMIGO) then
				cntTickInimigo <= 0;
				tickInimigoGenerated <= '1';
				flagIncrementLevel := true;
				levelRunning <= '1';
			else
				cntTickInimigo <= cntTickInimigo + 1;
				tickInimigoGenerated <= '0';
				levelRunning <= '1';
			end if;
		end if;	
	end process;
	tick_inimigo <= tickInimigoGenerated ;--when acabou_inimigos = '0' else
--						 '0';
	
	--
	-- tick_jogador generator
	--
	process (clk, reset, jogadores_perderam) is
	begin
		if (reset = '0') then --or jogadores_perderam = '1') then
			cntTickJogador <= 0;
			tick_jogador <= '0';
		elsif falling_edge(clk) then
			if cntTickJogador = TICKJOGADOR then
				cntTickJogador <= 0;
				tick_jogador <= '1';
			else
				cntTickJogador <= cntTickJogador + 1;
				tick_jogador <= '0';
			end if;
		end if;	
	end process;
	
	--
	-- tick_tiro_inimigo generator
	--
	process (clk, reset) is
	begin
		if reset = '0' then
			cntTickTiroInimigo <= 0;
			tick_tiro_inimigo <= '0';
		elsif falling_edge(clk) then
			if cntTickTiroInimigo = TICKTIROINIMIGO then
				cntTickTiroInimigo <= 0;
				tick_tiro_inimigo <= '1';
			else
				cntTickTiroInimigo <= cntTickTiroInimigo + 1;
				tick_tiro_inimigo <= '0';
			end if;
		end if;	
	end process;
	
	--
	-- tick_tiro_jogador generator
	--
	process (clk, reset) is
	begin
		if reset = '0' then
			cntTickTiroJogador <= 0;
			tick_tiro_jogador <= '0';
		elsif falling_edge(clk) then
			if cntTickTiroJogador = TICKTIROJOGADOR then
				cntTickTiroJogador <= 0;
				tick_tiro_jogador <= '1';
			else
				cntTickTiroJogador <= cntTickTiroJogador + 1;
				tick_tiro_jogador <= '0';
			end if;
		end if;	
	end process;

	gameState <= '0';
	
end architecture;