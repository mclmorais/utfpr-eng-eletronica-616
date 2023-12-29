library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.spaceInvadersConstants.all;

entity spaceInvaders is
    port (
        clk, rst : in std_logic;
        start    : in std_logic;
        inPlayer1Left, inPlayer1Right, inPlayer1Shot : in std_logic;
        inPlayer2Left, inPlayer2Right, inPlayer2Shot : in std_logic;
        buzzer, debug1, debug2: out std_logic;
        VGA_HS, VGA_VS             : out STD_LOGIC;
        VGA_R, VGA_B, VGA_G        : out STD_LOGIC_VECTOR(3 downto 0)

    );
end spaceInvaders;

architecture aSpaceInvaders of spaceInvaders is

    --signal DESCONECTADO : std_logic;
    signal enemyCollisions              : std_logic_vector(N_ENEMIES-1 downto 0);
    signal playerCollisions             : std_logic_vector(N_PLAYERS-1 downto 0);
    signal enemyProjectilesCollisions   : std_logic_vector(N_ENEMY_PROJECTILES-1 downto 0);
    signal player1ProjectilesCollisions  : std_logic_vector(N_PLAYER_PROJECTILES-1 downto 0);
    signal player2ProjectilesCollisions  : std_logic_vector(N_PLAYER_PROJECTILES-1 downto 0);

    signal enemyPositionsSignal                : enemyPositions;
    signal playerPositionsSignal          : playerPositions;
    signal player1ProjectilePositions     : playerProjectilePositions;
    signal player2ProjectilePositions     : playerProjectilePositions;
    signal player1ProjectileState       : std_logic_vector(N_PLAYER_PROJECTILES - 1 downto 0);
    signal player2ProjectileState       : std_logic_vector(N_PLAYER_PROJECTILES - 1 downto 0);
    signal enemyProjectilePositionsSignal      : enemyProjectilePositions;

    signal enemiesRunning                : std_logic_vector(N_ENEMIES-1 downto 0);
    
    signal tickMoveEnemies               : std_logic;
    signal tickMovePlayer                : std_logic;
    signal tickMoveEnemyProjectiles      : std_logic;
    signal tickMovePlayerProjectiles     : std_logic;
    signal gameState, levelRunning       : std_logic;

    signal sLevel                  : integer;

    signal player1shot, player1left, player1right : std_logic;
    signal player2shot, player2left, player2right : std_logic;
    signal player1position, player2position : position;

    signal debouncedStart               : std_logic;

    signal gameOver, enemyWins, playerLoses : std_logic;

    signal player1Lives, player2Lives : integer range 0 to 3;
    signal noActiveEnemies : std_logic;
    signal enemyFire       : std_logic;
    signal canEnemyFire    : std_logic;
    signal enemyFirePosition  : position;

    signal player1Fired : std_logic;
    signal player2Fired : std_logic;
    signal player1Control, player2Control: std_logic_vector(2 downto 0);

    component collisionController is
        
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
    end component collisionController;

    component enemiesController is
        port(
            clk, reset          : in std_logic;
            tickMove            : in std_logic;
            start               : in std_logic;
            collisions          : in std_logic_vector(N_ENEMIES-1 downto 0);
            level               : in integer;
            canFire             : in std_logic;
            enemiesRunning      : out std_logic_vector(N_ENEMIES-1 downto 0);
            enemiesWin          : out std_logic;
            positions           : out enemyPositions;
            projectilePosition  : out position;
            projectileFire      : out std_logic;
            noEnemies           : out std_logic
    );
    end component enemiesController;

    component controle is
        port(		--(esquerda,	direita,	tiro)
            controle1           : in std_logic_vector(2 downto 0);   --PORTAS: AA15; AA14; AB13
            controle2           : in std_logic_vector(2 downto 0);   --PORTAS: AB10; AB8; AB5
            action_player1      : out std_logic_vector(2 downto 0);
            action_player2      : out std_logic_vector(2 downto 0)
        );
    end component controle;

    component VGA is
        port (
            CLOCK_50, RESET            : in STD_LOGIC;
            VGA_HS, VGA_VS             : out STD_LOGIC;
            VGA_R, VGA_B, VGA_G        : out STD_LOGIC_VECTOR(3 downto 0);
            enemies                    : in enemyPositions;
            enemiesRunning             : in STD_LOGIC_VECTOR(N_ENEMIES - 1 downto 0);
            players                    : in playerPositions;
            player1Lives, player2Lives : in integer range 0 to 3;
            enemyProjectiles           : in enemyProjectilePositions;
            player1Projectile          : in position;
            player2Projectile          : in position;
            player1ProjectileState     : in std_logic;
            player2ProjectileState     : in std_logic
            
        );
    end component VGA;

    component soundManager is
        generic (
            CLOCK         : integer := 50000000;  -- Controla Duraçao dos bips
            DURTIRO       : integer := 20000000;  -- 400ms
            DURMORTE      : integer := 10000000;  -- 200ms
            DURINICIOJOGO : integer := 20000000); -- 400ms

        port (
            clk, reset      : in std_logic;
            soundTiro       : in std_logic;
            soundMorte      : in std_logic;
            soundInicioJogo : in std_logic;
            buzzer          : out std_logic);
    end component soundManager;

    component tickGenerator is
        generic (
            CLOCK            : integer := 50000000;
            TICKINIMIGO      : integer := 8;  -- 100 ms
            TICKJOGADOR      : integer := 6;  -- 50 ms
            TICKTIROINIMIGO  : integer := 4;  -- 20 ms
            TICKTIROJOGADOR  : integer := 2;  -- 10 ms
            DEC_RATE_INIMIGO : integer := 1); -- Taxa de decremento da velocidade do inimigo

        
	port ( clk, reset, start : in std_logic;
			 tick_inimigo, tick_jogador, tick_tiro_inimigo, tick_tiro_jogador : out std_logic;
			 acabou_inimigos: in std_logic;
			 jogadores_perderam: in std_logic;
			 currentLevel : out integer range 0 to 1000;
			 gameState : out std_logic;
			 levelRunning: out std_logic);
    end component;

    component player is
    port(clk 		: in std_logic;							-- FPGA clock
         reset 		: in std_logic;							-- Module Reset
         start		: in std_logic;  						-- Start -> reset Lifes
         hit		: in std_logic;  						-- Player hit by alien shot signal	 
         inleft		: in std_logic;  						-- Move inleft input
         inright	: in std_logic;  						-- Move inright input
         shot		: in std_logic;  						-- Shoting input
         tick		: in std_logic;  						-- Player position update clock
         shotEN		: in std_logic;							-- wire to player_shots state output
         fired		: out std_logic; 						-- Processed shot to Shots module
         nLifes		: out integer range 0 to MAX_N_LIFES;	-- Number of lifes signal to Display Driver
         player_pos	: out position); 						-- Player position to Display Driver
    end component player;

    
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

    component debounce2 is
        PORT(
            button : in std_logic;
            clk : in std_logic;
            debounced_out : out std_logic
        );
    end component;

--    component driver7seg is
--    generic (
--        N7SegPrimario : integer := 2;
--        N7SegSecundario : integer := 2
--    );
--    port (
--        estado                : in std_logic;
--        clk                   : in std_logic;
--        rst                   : in std_logic;
--        entradaTempo          : in integer range 0 to ((10 ** N7SegPrimario) - 1);
--        entradaPontosMaximos  : in integer range 0 to ((10 ** N7SegPrimario) - 1);
--        entradaPontosAtuais   : in integer range 0 to ((10 ** N7SegSecundario) - 1);
--        saidaPrimaria         : out seven_segment_output(N7SegPrimario-1 downto 0);
--        saidaSecundaria       : out seven_segment_output(N7SegPrimario-1 downto 0)
--    );
--    end component driver7seg;

    component TIROS_INIMIGOS is
    port (
        clk, reset                   : in std_logic;-- clock do tiro e reset global
        start                        : in std_logic;
        Enemy_shot                   : in std_logic; --flag atirou
        position_enemy_shot_IN       : in position;
        OUT_need_new_projectile      : out std_logic;
        OUT_EnemyProjectilepositions : out enemyProjectilePositions);
    end component TIROS_INIMIGOS;


    component PlayerProjectiles is
    port (
        clk, rst                        : in std_logic;
        fire							: in std_logic;
        inPlayerProjectileCollision	    : in std_logic;
        inPlayerPositions               : in position;
		start						    : in std_logic;
        state							: out std_logic_vector(N_PLAYER_PROJECTILES-1 downto 0); 
        moveProjectile					: in std_logic;
        positions						: out playerProjectilePositions	
    );
    end component PlayerProjectiles;

signal player1IsAlive, player2IsAlive: std_logic;

signal clklento : std_logic := '0';

begin
    debug1 <= levelRunning;
    debug2 <= enemiesRunning(0);
	stDb: debounce2 port map (clk => clk, button => start, debounced_out => debouncedStart);


    player1IsAlive <=   '1' when player1Lives > 0 else
                        '0';
    player2IsAlive <=   '1' when player2Lives > 0 else
                        '0';

    gameOver <= enemyWins or ((not player1IsAlive) and (not player2IsAlive)); 

    process(clk)
        variable counter : integer := 0;
    begin
        if(rising_edge(clk)) then
            counter := counter + 1;
        
            if(counter > 10_000_000) then
                clklento <= not clklento;
                counter := 0;
            end if;
        end if;
    end process;


    iVGA : component VGA
        port map(
            CLOCK_50                    => clk,
            RESET                       => rst,
            VGA_HS                      => VGA_HS,
            VGA_VS                      => VGA_VS,
            VGA_R                       => VGA_R,
            VGA_B                       => VGA_B,
            VGA_G                       => VGA_G,
            enemies                     => enemyPositionsSignal,
            enemiesRunning              => enemiesRunning,
            players                     => playerPositionsSignal,
            player1Lives                => player1Lives,
            player2Lives                => player2Lives,
            enemyProjectiles            => enemyProjectilePositionsSignal,
            player1Projectile           => player1ProjectilePositions(0),
            player2Projectile           => player2ProjectilePositions(0),
            player1ProjectileState      => player1ProjectileState(0),
            player2ProjectileState      => player2ProjectileState(0)
        );


    iCollisionController : component collisionController
        port map(
            clk                             => clklento,
            rst                             => rst,
            inEnemyStatus                   => enemiesRunning,
            inEnemyPositions                => enemyPositionsSignal,
            inPlayerPositions               => playerPositionsSignal,
            inPlayer1ProjectilePositions     => player1ProjectilePositions,
            inPlayer2ProjectilePositions     => player2ProjectilePositions,
            inEnemyProjectilePositions      => enemyProjectilePositionsSignal,
            outEnemyCollisions              => enemyCollisions,
            outPlayerCollisions             => playerCollisions,
            outEnemyProjectileCollisions    => enemyProjectilesCollisions,
            outPlayer1ProjectileCollisions   => player1ProjectilesCollisions,
            outPlayer2ProjectileCollisions   => player2ProjectilesCollisions
        );
    
    iEnemiesController : component enemiesController
        port map(
            clk             => clklento,
            reset             => rst,
            tickMove        => clklento,
            start           => not debouncedStart,--levelRunning,
            collisions      => enemyCollisions,
            level           => sLevel,
            canFire         => canEnemyFire,
            enemiesRunning  => enemiesRunning,
            enemiesWin      => enemyWins,
            positions       => enemyPositionsSignal,
            noEnemies       => noActiveEnemies,
            projectilePosition  => enemyFirePosition,
            projectileFire  =>  enemyFire
        );

    iControle : component controle
        port map(
            controle1       => (inPlayer1Left & inPlayer1Right & inPlayer1Shot),    
            controle2		=> (inPlayer2Left & inPlayer2Right & inPlayer2Shot),    
            action_player1  => player1Control,
            action_player2  => player2Control
        );

    iSoundManager : component soundManager
        port map(
            clk             => clklento,
            reset             => rst,
            soundTiro       => player1Fired or player2Fired,
            soundMorte      => gameOver, 
            soundInicioJogo => start,
            buzzer          => buzzer
        );
    
    iTickgenerator : component tickGenerator
        port map(
            clk                => clklento,
            reset               => rst,
            start => debouncedStart,
            tick_inimigo        => tickMoveEnemies,
            tick_jogador        => tickMovePlayer,
            tick_tiro_inimigo   => tickMoveEnemyProjectiles,
            tick_tiro_jogador   => tickMovePlayerProjectiles,
            acabou_inimigos     => noActiveEnemies,
            jogadores_perderam  => gameOver,
            currentLevel        => sLevel,
            gameState           => gameState,
            levelRunning        => levelRunning
        );

        iPlayer1 : component player
            port map(
                clk        => tickMovePlayer,
                reset       => rst,
                start		=> debouncedStart,
                hit		    => playerCollisions(0),
                inleft		=> player1Control(2),
                inright	    => player1Control(1),
                shot		=> player1Control(0),
                tick		=> tickMovePlayer,
                shotEN		=> player1ProjectileState(0),
                fired		=> player1Fired,
                nLifes		=> player1Lives,
                player_pos	=> playerPositionsSignal(0)
            );

        iPlayer2 : component player
            port map(
                clk        => tickMovePlayer,
                reset       => rst,
                start		=> debouncedStart,
                hit		    => playerCollisions(1),
                inleft		=> player2Control(0),
                inright	    => player2Control(1),
                shot		=> player2Control(2),
                tick		=> tickMovePlayer,
                shotEN		=> player2ProjectileState(0),
                fired		=> player2Fired,
                nLifes		=> player2Lives,
                player_pos	=> playerPositionsSignal(1)
            );
        
        iplayerProjectile1 : component PlayerProjectiles
            port map(
                clk => clklento,
                rst => rst,                       
                fire                            => player1Fired,					
                inPlayerProjectileCollision	    =>  player1ProjectilesCollisions(0),
                inPlayerPositions               =>  playerPositionsSignal(0),
                start => debouncedStart,
                state							=>  player1ProjectileState,
                moveProjectile					=>  tickMovePlayerProjectiles,
                positions						=>  player1ProjectilePositions
            );

        iplayerProjectile2 : component PlayerProjectiles
            port map(
                clk => clklento,
                rst => rst,                       
                fire                            => player2Fired,					
                inPlayerProjectileCollision	    =>  player2ProjectilesCollisions(0),
                inPlayerPositions               =>  playerPositionsSignal(1),
                start => debouncedStart,
                state							=>  player2ProjectileState,
                moveProjectile					=>  tickMovePlayerProjectiles,
                positions						=>  player2ProjectilePositions
            );
        

        --iDriver7Seg : component driver7Seg
          --  port map(
            --    estado               => gameState,
        --        clk                  => clk,
         --       rst                  => rst,
         --       entradaTempo         => DESCONECTADO,
         --       entradaPontosMaximos => DESCONECTADO,
         --       entradaPontosAtuais  => DESCONECTADO,
         --       saidaPrimaria        => DESCONECTADO,
         --       saidaSecundaria      => DESCONECTADO
          --  );

        iTirosInimigos : component TIROS_INIMIGOS
            port map(
                clk                          => tickMoveEnemyProjectiles,
                reset                        => rst,
                start                        => debouncedStart,
                Enemy_shot                   => enemyFire,
                position_enemy_shot_IN       => enemyFirePosition,
                OUT_need_new_projectile      => canEnemyFire,
                OUT_EnemyProjectilepositions => enemyProjectilePositionsSignal
            );



end architecture aSpaceInvaders;