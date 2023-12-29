--	tickGenerator
--
-- Author: Adriano Ricardo de Abreu Gamba
--
-- Date: 07/2019
--
-- Federal University of Technology - Paraná
-- Discipline: Reconfigurable Logic - 2019-1
-- 
--	Description: generate sound based on the in signals.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity soundManager is
	generic ( CLOCK 				: integer := 50000000;	-- Controla Duraçao dos bips
				 DURTIRO				: integer := 20000000;	-- 400ms
				 DURMORTE			: integer := 10000000;	-- 200ms
				 DURINICIOJOGO		: integer := 20000000);	-- 400ms
				 
	port ( clk, reset : in std_logic;
			 soundTiro	: in std_logic;
			 soundMorte	: in std_logic;
			 soundInicioJogo	: in std_logic;
			 buzzer	: out std_logic);
end entity;

architecture soundManager of soundManager is
	signal cntBuzzer: integer range 0 to CLOCK := 0;
	signal currentSound_s : std_logic := '0';
	type state is (READY, EXECUTINGTIRO, EXECUTINGMORTE, EXECUTINGINICIOJOGO);
	signal pr_state, nx_state : state;
	
begin
	
	--
	-- Executa o som correspondente ao evento
	--	
	
	-- Lower section of FSM:
	process (clk, reset) 
	begin 
		if reset = '0' then           
			pr_state <= READY;
		elsif rising_edge(clk) then
			pr_state <= nx_state;
		end if;
	end process;
	
	-- Timer
	process (clk, reset) 
	begin 
		if (reset = '0') then   
			cntBuzzer <= 0;
		elsif rising_edge(clk) then
			if pr_state /= nx_state then
				cntBuzzer <= 0;
			elsif cntBuzzer /= CLOCK then
				cntBuzzer <= cntBuzzer + 1;
			end if;
		end if;
	end process;
	
	-- Upper Section of FSM:
	process (pr_state, cntBuzzer, soundTiro, soundMorte, soundInicioJogo)
	begin
		case pr_state is
			when READY => 
				currentSound_s <= '0';
				if soundMorte = '1' then 
					nx_state <= EXECUTINGMORTE;
				elsif soundTiro = '1' then
					nx_state <= ExeCUTINGTIRO;
				elsif soundinicioJogo = '1' then
					nx_state <= EXECUTINGINICIOJOGO;
				else
					nx_state <= READY;
				end if; 
	 
			when EXECUTINGTIRO => 
				currentSound_s <= '1';		
				if cntBuzzer >= DURTIRO then 
					nx_state <= READY;
				elsif soundMorte = '1' then
					nx_state <= EXECUTINGMORTE;
				else
					nx_state <= EXECUTINGTIRO;
				end if; 
	 
			when EXECUTINGMORTE => 
				currentSound_s <= '1';
				if cntBuzzer >= DURMORTE then 
					nx_state <= READY;
				else
					nx_state <= EXECUTINGMORTE;
				end if;
				
			when EXECUTINGINICIOJOGO=> 
				currentSound_s <= '1';
				if cntBuzzer = DURINICIOJOGO then 
					nx_state <= READY;
				else
					nx_state <= EXECUTINGINICIOJOGO;
				end if;
				
		end case; 
	end process;
	
	buzzer <= currentSound_s;
	
end architecture;