library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.spaceInvadersConstants.all;

entity debounce is
	port(	clk 		: in std_logic;
			reset 	: in std_logic;
			input		: in std_logic;
			delay 	: in integer range 0 to CLOCK_HZ;
			output	: out std_logic);
end entity;

architecture debounce of debounce is
	
	-- finite state machine with four states: fsm_low, fsm_rising, fsm_high, fsm_falling
	type fsm is (fsm_rising, fsm_falling, fsm_high, fsm_low);

	-- fsm_rising or fsm_falling edge detection on the input signal synchronized to the clock
	signal sOldInput : std_logic;

	-- delay counter for the debounce by time
	signal sCounterOld : integer range 0 to CLOCK_HZ;
	signal sCounterNew : integer range 0 to CLOCK_HZ;

	-- finite state machine Flip-Flop
	signal sControlNew : fsm;
	signal sControlOld : fsm;
begin

	--
	-- Debounce Flip-Flops
	--
	process (sCounterNew, sControlNew, input, reset, clk) is
	begin
		-- reset logic
		if (reset = '0') then
			sControlOld <= fsm_low;-- when input = '0' else fsm_high;
			sCounterOld <= 0;

		-- clock tick -> FF data update
		elsif (rising_edge(clk)) then
			sOldInput <= input;
			sControlOld <= sControlNew;
			sCounterOld <= sCounterNew;
		end if;
	end process;

	--
	-- Debounce logic
	--
	process (sCounterOld, sControlOld, sOldInput, input, delay)
	begin
		-- FSM transition logic
		case (sControlOld) is
			-- LOW state
			when fsm_low =>
				-- outputs update
				sCounterNew <= 0;
				output <= '0';

				-- FSM update
				if ((sOldInput = '0') and (input = '1')) then
					sControlNew <= fsm_rising;

				else
					sControlNew <= fsm_low;

				end if;

			-- RISING state
			when fsm_rising =>
				-- outputs update	
				sCounterNew <= sCounterOld + 1;
				output <= '0';

				-- FSM update
			 	if(sCounterOld > delay) then
			 		if((sOldInput = '1') and (input = '1')) then
						sControlNew <= fsm_high;

					else
						sControlNew <= fsm_low;

					end if;

				else
					sControlNew <= fsm_rising;

				end if;

			-- FALLING state
			when fsm_falling =>
				-- outputs update
				sCounterNew <= sCounterOld + 1;
				output <= '1';

				-- FSM update
				if(sCounterOld > delay) then
				 	if ((sOldInput = '0') and (input = '0')) then
						sControlNew <= fsm_low;
					
					else
						sControlNew <= fsm_high;

					end if;

				else
					sControlNew <= fsm_falling;

				end if;

			-- HIGH state
			when fsm_high =>
			-- outputs update
				sCounterNew <= 0;
				output <= '1';

				-- FSM update
				if ((sOldInput = '1') and (input = '0')) then
					sControlNew <= fsm_falling;

				else
					sControlNew  <= fsm_high;

				end if;	
		end case;
	end process;

end architecture debounce;