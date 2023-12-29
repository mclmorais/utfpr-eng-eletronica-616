library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.spaceInvadersConstants.all;

entity playerProjectiles is
    port (
      clk, rst                          : in std_logic;
	   fire				    	  	          : in std_logic;
	   inPlayerProjectileCollision       : in std_logic;
      inPlayerPositions                 : in position;
		start						             : in std_logic;	  
		moveProjectile			             : in std_logic;
		state					                : out std_logic_vector(N_PLAYER_PROJECTILES-1 downto 0); 
		positions						       : out playerProjectilePositions		  

    );
end entity playerProjectiles;

architecture aPlayersProjectiles of playerProjectiles is
    
	 signal positionSignal : playerProjectilePositions;
	 signal stateSignal : std_logic_vector(N_PLAYER_PROJECTILES-1 downto 0);
	 signal moveProjectileA : std_logic; -- last state used to detect rising edge
	 signal fireA : std_logic; -- last state used to detect rising edge
	 signal startA : std_logic;
	 begin
    process(clk)
    begin
		if(rst = '0') then
			positionSignal <= (others=>(others=>0));
			state <= (others =>'0');
			stateSignal <= (others =>'0');
		else
			if rising_edge(clk) then
				startA <= start;
				fireA <= fire;
				if(startA = '1' and start = '0') then
					state <= (others =>'0');
					stateSignal <= (others =>'0');
				end if;
				moveProjectileA <= moveProjectile;
				for i in N_PLAYER_PROJECTILES-1 downto 0 loop
					if((stateSignal(i) = '1') and (moveProjectileA = '0') and (moveProjectile = '1') and positionSignal(i)(1) > 1 and inPlayerProjectileCollision = '0') then -- move the projectiles
						positionSignal(i)(0) <= positionSignal(i)(0) - 1;
					elsif(positionSignal(i)(1) = 0 or inPlayerProjectileCollision = '1') then	-- detect the projectiles reach end
						stateSignal(i) <= '0';
						positionSignal(i)(1) <= 0;
					elsif(stateSignal(i) = '0' and fireA = '0' and fire = '1') then
						stateSignal(i) <= '1';
						positionSignal(i)(0) <= inPlayerPositions(0);
						positionSignal(i)(1) <= inPlayerPositions(1);
					end if;
				end loop;
		  end if;
	   end if;
		positions <= positionSignal;
		state <= stateSignal;
    end process;
end architecture aPlayersProjectiles;