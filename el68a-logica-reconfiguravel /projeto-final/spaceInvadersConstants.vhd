library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package spaceInvadersConstants is
    constant N_ENEMIES              : integer range 0 to 127  := 12;
    constant N_PLAYERS              : integer range 0 to 127  := 2;
    constant N_ENEMY_PROJECTILES    : integer range 0 to 127  := 4;
    constant N_PLAYER_PROJECTILES   : integer range 0 to 127  := 2;
    constant SCREEN_WIDTH           : integer := 16;
    constant HEIGHT                 : integer := 12;
    constant MAX_N_LIFES            : integer := 3;
    constant CLOCK_HZ            : integer := 50e6;
    constant DEBOUNCE_DELAY            : integer := 5e6;

    type position is array(1 downto 0) of integer range SCREEN_WIDTH-1 downto -1;    --position(1) = X position(0) = Y
    type enemyPositions is array(N_ENEMIES-1 downto 0) of position;
    type playerPositions is array(N_PLAYERS-1 downto 0) of position;
    type enemyProjectilePositions is array(N_ENEMY_PROJECTILES-1 downto 0) of position;
    type playerProjectilePositions is array(N_PLAYER_PROJECTILES-1 downto 0) of position;
end package spaceInvadersConstants;
