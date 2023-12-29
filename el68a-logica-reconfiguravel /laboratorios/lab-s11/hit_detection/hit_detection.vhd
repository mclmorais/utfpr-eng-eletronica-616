library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity hitDetection is
    generic(NUM_POSITIONS : integer := 3);
  port (
    playerInput : in std_logic; -- Player input
    target : in integer range 0 to NUM_POSITIONS;
    currentPosition : in integer range 0 to NUM_POSITIONS;
    didScore : out std_logic;
    didMiss : out std_logic
  );
end entity hitDetection;


architecture aHitDetection of hitDetection is

begin

    -- VersÃƒÂ£o combinacional sem testar
    -- sDidScore <= '1' when playerInput = '1' and currentPosition = target else '0';
    -- sDidMiss <= '1' when playerInput = '1' and currentPosition /= target else '0';


        hitDetection : process(playerInput, currentPosition, target) is
		  begin
            if playerInput = '1' then
                if currentPosition = target then
                    didScore <= '1';
                else 
                    didMiss <= '1';
                end if;
            else
                didScore <= '0';
                didMiss <= '0';
            end if;
			end process hitDetection;
 
  
end architecture aHitDetection;
