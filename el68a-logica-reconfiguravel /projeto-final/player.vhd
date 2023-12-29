library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.spaceInvadersConstants.all;

-- instanciar N_PLAYERS units da entidade player

entity player is
	port(clk 		: in std_logic;								-- FPGA clock
		 reset 		: in std_logic;								-- Module Reset
		 start		: in std_logic;  								-- Start -> reset Lifes
		 hit			: in std_logic;  								-- Player hit by alien shot signal	 
		 inleft		: in std_logic;  								-- Move inleft input
		 inright	: in std_logic;  								-- Move inright input
		 shot			: in std_logic;  	 							-- Shoting input
		 tick			: in std_logic;  								-- Player position update clock
		 shotEN		: in std_logic;												-- wire to player_shots state output
		 fired		: out std_logic; 											-- Processed shot to Shots module
		 nLifes		: out integer range 0 to MAX_N_LIFES;	-- Number of lifes signal to Display Driver
		 player_pos	: out position); 										-- Player position to Display Driver
end entity;


architecture player of player is

	--
	-- Debouncing block module 
	--
	component debounce is
		port(	clk 		: in std_logic;
				reset 	: in std_logic;
				input		: in std_logic;
				delay 	: in integer range 0 to CLOCK_HZ;
				output	: out std_logic);
	end component debounce;

	-- debounced inputs:
	signal sInputShot : std_logic;
	signal sInputLeft : std_logic;
	signal sInputRight : std_logic;

	-- position memory registers
	signal sDataInputPositionReg : position;
	signal sDataOutputPositionReg : position;

	-- lifes memory registers
	signal sDataInputLifesReg : integer range 0 to MAX_N_LIFES := 0;
	signal sDataOutputLifesReg : integer range 0 to MAX_N_LIFES := 0;

	-- edge detector on tick signal
	signal sOldTick : std_logic;

	-- edge detector on Hit signal
	signal sOldHit : std_logic;

begin
	--
	--	Input Debouncing
	--
	--shotBT: debounce port map (clk => clk, reset => reset, input => shot, output => sInputShot, delay => DEBOUNCE_DELAY);
	--leftBT: debounce port map (clk => clk, reset => reset, input => inleft, output => sInputLeft, delay => DEBOUNCE_DELAY);
	--rightBT: debounce port map (clk => clk, reset => reset, input => inright, output => sInputRight, delay => DEBOUNCE_DELAY);
	
	sInputShot <= not shot;
	sInputLeft <= not inleft;
	sInputRight <= not inright;



	--
	--	X axis movement
	--
	sDataInputPositionReg(0) <= 	(sDataOutputPositionReg(0) + 1) when (((sInputLeft = '0')  and (sInputRight = '1')) and (sDataOutputPositionReg(0) < SCREEN_WIDTH-1)) else
											(sDataOutputPositionReg(0) - 1) when (((sInputLeft = '1')  and (sInputRight = '0')) and (sDataOutputPositionReg(0) > 0)) else
											(sDataOutputPositionReg(0));
	
	--
	-- Position Register
	--
	process(clk, tick, reset, sOldTick, sDataInputPositionReg)
	begin
		-- reset the position register
		if(reset = '0') then
			sDataOutputPositionReg(0) <= 0;

		-- update the position register at each rising edge on the tick
		elsif(rising_edge(clk)) then

				sDataOutputPositionReg <= sDataInputPositionReg;

		end if;
	end process;


	--
	-- Number of Lifes register
	--
	process(clk, hit, start, reset, sOldHit, sDataInputLifesReg)
	begin
		-- reset the number of lifes
		if((reset = '0') or (start = '0')) then
			sDataOutputLifesReg <= MAX_N_LIFES;

		-- Flip Flop update
		elsif(rising_edge(clk)) then
			sOldHit <= hit;
			sDataOutputLifesReg <= sDataInputLifesReg;
		end if;
	end process;

	--
	-- Number of Lifes logic
	--
	process(sDataOutputLifesReg, sOldHit, hit)
	begin
		-- If still any life to decrement
		if(sDataOutputLifesReg > 0) then
			if((sOldHit = '0') and (hit = '1')) then
				sDataInputLifesReg <= sDataOutputLifesReg - 1;

			else
				sDataInputLifesReg <= sDataOutputLifesReg;

			end if;
		-- otherwise just hold the zero until reset
		else
			sDataInputLifesReg <= 0;
		end if;
	end process;

	--
	--	Output routing
	--
	fired <= (sInputShot and (not(shotEN)));			-- player shot firing command
	nLifes <= sDataOutputLifesReg;						-- player number of lifes
	player_pos(1) <= sDataOutputPositionReg(0);		-- x position
	player_pos(0) <= HEIGHT - 1;								-- y position

end architecture;