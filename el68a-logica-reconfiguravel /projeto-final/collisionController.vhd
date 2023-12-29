library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.spaceInvadersConstants.all;

entity collisionController is
    port (
        clk, rst                        : in std_logic;
        inEnemyStatus                   : in std_logic_vector(N_ENEMIES-1 downto 0);
        inEnemyPositions                : in enemyPositions;
        inPlayerPositions               : in playerPositions;
        inPlayer1ProjectilePositions     : in playerProjectilePositions;
        inPlayer2ProjectilePositions     : in playerProjectilePositions;
        inEnemyProjectilePositions      : in enemyProjectilePositions;
        outEnemyCollisions              : out std_logic_vector(N_ENEMIES-1 downto 0);
        outPlayerCollisions             : out std_logic_vector(N_PLAYERS-1 downto 0);
        outEnemyProjectileCollisions    : out std_logic_vector(N_ENEMY_PROJECTILES-1 downto 0);
        outPlayer1ProjectileCollisions   : out std_logic_vector(N_PLAYER_PROJECTILES-1 downto 0);
        outPlayer2ProjectileCollisions   : out std_logic_vector(N_PLAYER_PROJECTILES-1 downto 0)
    );
end entity collisionController;

architecture aCollisionController of collisionController is
    
begin
    
    -- Enemy <--> Player Projectile
    process(clk)
    variable enemyCollisionsMask            : std_logic_vector(N_ENEMIES-1 downto 0);
    variable player1ProjectileCollisionsMask : std_logic_vector(N_PLAYER_PROJECTILES-1 downto 0);
    variable player2ProjectileCollisionsMask : std_logic_vector(N_PLAYER_PROJECTILES-1 downto 0);
    begin
        if rising_edge(clk) then
            enemyCollisionsMask := (others => '0');
            player1ProjectileCollisionsMask := (others => '0');
            player2ProjectileCollisionsMask := (others => '0');
            for i in N_ENEMIES-1 downto 0 loop
                for j in N_PLAYER_PROJECTILES-1 downto 0 loop
                    if inEnemyStatus(i) = '1' and (inEnemyPositions(i)(0) = inPlayer1ProjectilePositions(j)(0)) and (inEnemyPositions(i)(1) = inPlayer1ProjectilePositions(j)(1)) then
                        enemyCollisionsMask(i) := '1';
                        player1ProjectileCollisionsMask(j) := '1';
                    end if;
                    if inEnemyStatus(i) = '1' and inEnemyPositions(i)(0) = inPlayer2ProjectilePositions(j)(0) and inEnemyPositions(i)(1) = inPlayer2ProjectilePositions(j)(1) then
                        enemyCollisionsMask(i) := '1';
                        player2ProjectileCollisionsMask(j) := '1';
                    end if;
                end loop;
            end loop;
        end if;
        outEnemyCollisions <= enemyCollisionsMask;
        outPlayer1ProjectileCollisions <= player1ProjectileCollisionsMask;
        outPlayer2ProjectileCollisions <= player2ProjectileCollisionsMask;
    end process;

    -- Player <--> Enemy Projectile
    process(clk)
    variable playerCollisionsMask           : std_logic_vector(N_PLAYERS-1 downto 0);
    variable enemyProjectileCollisionsMask  : std_logic_vector(N_ENEMY_PROJECTILES-1 downto 0);
    begin
        if rising_edge(clk) then
            playerCollisionsMask := (others => '0');
            enemyProjectileCollisionsMask := (others => '0');
            for i in N_PLAYERS-1 downto 0 loop
                for j in N_ENEMY_PROJECTILES-1 downto 0 loop
                    if inPlayerPositions(i)(0) = inEnemyProjectilePositions(j)(0) and inPlayerPositions(i)(1) = inEnemyProjectilePositions(j)(1) then
                        playerCollisionsMask(i) := '1';
                        enemyProjectileCollisionsMask(j) := '1';
                    end if;
                end loop;
            end loop;
        end if;
        outPlayerCollisions <= playerCollisionsMask;
        outEnemyProjectileCollisions <= enemyProjectileCollisionsMask;
    end process;
    
        
end architecture aCollisionController;