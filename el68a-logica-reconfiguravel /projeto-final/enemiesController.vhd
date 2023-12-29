library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.spaceInvadersConstants.all;

entity enemiesController is
    port(
        clk, reset                  : in std_logic;
        tickMove                    : in std_logic;
        start                       : in std_logic;
        collisions                  : in std_logic_vector(N_ENEMIES-1 downto 0);
        level                       : in integer;
        canFire                     : in std_logic;
        enemiesRunning              : out std_logic_vector(N_ENEMIES-1 downto 0);
        enemiesWin                  : out std_logic;
        positions                   : out enemyPositions;
        projectilePosition          : out position;
        projectileFire              : out std_logic;
        noEnemies                   : out std_logic
    );
end entity enemiesController;

architecture aEnemiesController of enemiesController is

    signal movingState                 : std_logic_vector(3 downto 0);
    signal tickMoveBefore, startBefore : std_logic;
    signal positionsSignal : enemyPositions;
    type move_type is (LEFT, RIGHT, LEFT_DOWN, RIGHT_DOWN);
    signal enemiesMove : move_type;
    signal enemiesRunningSignal : std_logic_vector(N_ENEMIES-1 downto 0);
    signal enemiesWinSignal : std_logic;
    signal enemiesProjectilesChosen: integer range 0 to N_ENEMIES-1; 
    signal level_s : integer;
    begin
    process(clk)
    variable row, column : integer;
    begin
        if(level > N_PLAYERS/(SCREEN_WIDTH - 4)) then
            level_s <= N_PLAYERS/(SCREEN_WIDTH - 4);
        else
            level_s <= level;
        end if;
        if(reset = '0') then
            positionsSignal <= (others=>(others=>0));
            enemiesMove <= RIGHT;
            enemiesWinSignal <= '0';
            movingState <= "0000";
            noEnemies <= '0';
        else
            if(rising_edge(clk)) then
                startBefore <= start;
                tickMoveBefore <= tickMove;
                if(start = '1') then --and startBefore = '0') then  -- this indicates the game starter and execute only one time
                    row := 0;                               -- 2D array to initialize the enemies positions
                    column := 2;
                    --enemiesRunningSignal <= (others => '1');        -- Enemies alive
                    enemiesMove <= RIGHT;
                    movingState <= "1000";
                    enemiesWinSignal <= '0';
                    noEnemies <= '0';
                    for i in (N_ENEMIES-1)  downto 0 loop
                        positionsSignal(i) <= (column, row);
                        column := column + 1;
                        if(i <= ((SCREEN_WIDTH - 4) + ((SCREEN_WIDTH - 4)*level) - 1)) then
                            enemiesRunningSignal(i) <= '1';
                        else
                            enemiesRunningSignal(i) <= '0';
                        end if;
                        if(column >= SCREEN_WIDTH-2) then               -- give 2 spaces in the right side
                            column := 2;
                            row := row + 1;
                        end if;
                    end loop;
                --end if;
                else
                --Start the move process
                    if(enemiesWinSignal = '0') then -- the game only starts after load the positions
                        if(positionsSignal((N_ENEMIES-1) - (SCREEN_WIDTH - 1 - 4))(1) = (SCREEN_WIDTH - 1) - 1 and enemiesMove = RIGHT) then
                            enemiesMove <= LEFT_DOWN;
                        elsif(positionsSignal(N_ENEMIES-1)(1) = 1 and enemiesMove = LEFT) then  -- position (1,Y) two boxes before the wall
                            enemiesMove <= RIGHT_DOWN;
                        end if;
                        for i in N_ENEMIES-1 downto 0 loop
                            if(enemiesMove = RIGHT) then
                                movingState <= "0001";
                                positionsSignal(i)(1) <= positionsSignal(i)(1)+1;
                            elsif (enemiesMove = LEFT) then
                                positionsSignal(i)(1) <= positionsSignal(i)(1)-1;
                                movingState <= "0010";
                            elsif(enemiesMove = RIGHT_DOWN) then
                                positionsSignal(i)(1) <= positionsSignal(i)(1)+1;
                                positionsSignal(i)(0) <= positionsSignal(i)(0)+1;
                                movingState <= "0011";
                            elsif (enemiesMove = LEFT_DOWN) then
                                positionsSignal(i)(1) <= positionsSignal(i)(1)-1;
                                positionsSignal(i)(0) <= positionsSignal(i)(0)+1;
                                movingState <= "0100";
                            end if;
                            if (positionsSignal(i)(0) >= (HEIGHT - 1) and enemiesRunningSignal(i) = '1') then
                                enemiesWinSignal <= '1';
                            end if ;
                        end loop;

                        if(enemiesMove = RIGHT_DOWN) then
                            enemiesMove <= RIGHT;
                        elsif(enemiesMove = LEFT_DOWN) then
                            enemiesMove <= LEFT;
                        end if;
                    end if;
                    -- start the collision test
                    for i in N_ENEMIES-1 downto 0 loop
                        if(collisions(i) = '1') then
                            enemiesRunningSignal(i) <= '0';
                        end if;
                    end loop;
                    if(to_integer(unsigned(enemiesRunningSignal)) = 0 and startBefore = '1') then
                        noEnemies <= '1';
                    else
                        noEnemies <= '0';
                    end if;
                end if;
            end if;
        end if;

        positions <= positionsSignal;
        enemiesRunning <= enemiesRunningSignal;
        enemiesWin <= enemiesWinSignal;
    end process;

randonProjectiles : process(clk)
begin
    if(rising_edge(clk)) then
        
        if(enemiesProjectilesChosen < N_ENEMIES-1) then
            enemiesProjectilesChosen <= enemiesProjectilesChosen + 1;
        else
            enemiesProjectilesChosen <= 0;
        end if;
        if(canFire = '1') then
            if(enemiesRunningSignal(enemiesProjectilesChosen) = '1' and tickMove = '1' and tickMoveBefore = '0' and startBefore = '1') then
                projectilePosition <= positionsSignal(enemiesProjectilesChosen);
                projectileFire <= '1';
            end if;
        else
            projectileFire <= '0';
        end if;
    end if;
end process ; -- randonProjectiles

end aEnemiesController ; -- aenemiesController