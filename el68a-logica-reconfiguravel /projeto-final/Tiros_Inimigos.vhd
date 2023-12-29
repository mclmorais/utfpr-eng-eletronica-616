library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.spaceInvadersConstants.all;

ENTITY TIROS_INIMIGOS is
	PORT (
		clk, reset:		 		in std_logic;-- clock do tiro e reset global
		start:					in std_logic;
		Enemy_shot:	  			in std_logic; --flag atirou
		position_enemy_shot_IN: 		in position; 
		OUT_need_new_projectile:		out std_logic;
		OUT_EnemyProjectilepositions:	out enemyProjectilePositions);		
END TIROS_INIMIGOS;

ARCHITECTURE TIROS_INIMIGOS of TIROS_INIMIGOS is  
	SIGNAL Need_projectile : std_logic;
	SIGNAL projectile_positions : enemyProjectilePositions;
	SIGNAL game_ON: std_logic;
BEGIN
    PROCESS(clk)
	 variable limitador : integer range 0 to 1; -- limita em 1 tiro por clock
    BEGIN
		IF(reset = '0') then
				OUT_need_new_projectile <= '0';
				OUT_EnemyProjectilepositions<= (others=>(others=>-1)); -- posiçao (-1,-1) para o tiro nao ser exibido em tela
            game_ON <= '0';
		ELSE	 
			IF(rising_edge(clk)) THEN	-- quando o jogo esta ativo			
				IF(start='1' and game_ON='0') THEN--executa uma vez para setar valores
					game_ON <= '1';
					projectile_positions <= (others=>(others=>-1));
				END IF;
				
				IF(game_ON = '1') THEN	
					------TIRO AVANÇA DE POSIÇÃO--------------------
					FOR i IN N_ENEMY_PROJECTILES-1 downto 0 LOOP
						IF(projectile_positions(i)(0)>-1 and projectile_positions(i)(1)>-1) THEN -- nao desloca inativos
								projectile_positions(i)(0) <= projectile_positions(i)(0)+1;--deloca em Y
								
								IF(projectile_positions(i)(0)>HEIGHT) THEN -- inativa tiro
									projectile_positions(i)(0)<= -1;
									projectile_positions(i)(1)<= -1;
								END IF;
								
						END IF;
					END LOOP;
					
					------- inimigo atirou, aloca tiro ----
					IF(Enemy_shot='1')	THEN
						limitador := 0; -- garante que o tiro seja alocado em uma unica posicao
						FOR i IN N_ENEMY_PROJECTILES-1 downto 0 LOOP
							IF(projectile_positions(i)(0)=-1 and projectile_positions(i)(1)=-1 and limitador=0) THEN	--acha p
								limitador:=1;						
								projectile_positions(i)(1) <= position_enemy_shot_IN(1);	--X
								projectile_positions(i)(0) <= position_enemy_shot_IN(0)+1;	--Y		
							END IF;				
						END LOOP;
					END IF;
					
					------- Verifica se há alguma posicao de tiro vazia ----
					Need_projectile <= '0';
					FOR i IN N_ENEMY_PROJECTILES-1 downto 0 LOOP 
						IF(projectile_positions(i)(0)= -1 and projectile_positions(i)(1)= -1) THEN 
							Need_projectile <= '1';
						END IF;
					END LOOP;					
					
					OUT_need_new_projectile <= Need_projectile;
					OUT_EnemyProjectilepositions<=projectile_positions;
				
				END IF;
				
			END IF;
		END IF;
	END PROCESS;
END ARCHITECTURE TIROS_INIMIGOS;
