LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ControladorEstadoTempo IS
	GENERIC (
		CLK_RATE : INTEGER := 50000000;
		TOTAL_GAME_TIME_MS : INTEGER := 40000;
		TEMPO_TROCA_MARMOTA_MIN_MS : INTEGER := 500
	);
	PORT(
		clk : IN STD_LOGIC;
		bt_inicio : IN STD_LOGIC;
		bt_rst : IN STD_LOGIC;
		troca_marmota : OUT STD_LOGIC;
		dif : OUT INTEGER;
		tempo : OUT INTEGER;
		estado : OUT STD_LOGIC
	);
END;

ARCHITECTURE a_whackamole OF ControladorEstadoTempo IS
	COMPONENT debounce
	  GENERIC(
		 counter_size  :  INTEGER := 23); --counter size (19 bits gives 10.5ms with 50MHz clock)
	  PORT(
		 clk     : IN  STD_LOGIC;
		 botao   : IN  STD_LOGIC;
		 resultado  : OUT STD_LOGIC);
	END COMPONENT debounce;
	
	constant tempo_maximo_contador_jogo : INTEGER := TOTAL_GAME_TIME_MS * (CLK_RATE / 1000);
	constant tempo_maximo_troca_marmota : INTEGER := TEMPO_TROCA_MARMOTA_MIN_MS * (CLK_RATE / 1000);
	signal inicio : STD_LOGIC;
	signal rst : STD_LOGIC;
	
	signal estado_signal : STD_LOGIC := '0';
	
	signal troca_marmota_signal : STD_LOGIC := '0';
	signal dif_signal : INTEGER := 0;
	signal fimJogo : STD_LOGIC := '0';
	signal tempo_signal : INTEGER  := TOTAL_GAME_TIME_MS / 1000;
	
	
BEGIN
	deb1:debounce
	generic map (counter_size => 23) --no semicolon here
	port map (
	clk => clk ,
	botao => bt_inicio,
	resultado => inicio);

	deb2:debounce
	generic map (counter_size => 23) --no semicolon here
	port map (
	clk => clk ,
	botao => bt_rst,
	resultado => rst);
	
	dif <= dif_signal;
	tempo <= tempo_signal;
	troca_marmota <= troca_marmota_signal;
	estado <= estado_signal;
	
	-- Controlador de estado
	PROCESS(clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF rst = '1' THEN
				estado_signal <= '0';
			END IF;
			
			IF estado_signal = '0' and inicio = '1' THEN
				estado_signal <= '1';
			END IF;
			
			IF estado_signal = '1' and fimJogo = '1' THEN
				estado_signal <= '0';
			END IF;
		END IF;
	END PROCESS;
	
	-- Controlador de tempo
	PROCESS(clk)
		variable contador_tempo_jogo : INTEGER := 0;
	BEGIN
		IF rising_edge(clk) THEN
			IF estado_signal = '1' THEN
				-- Conta o tempo
				IF contador_tempo_jogo < tempo_maximo_contador_jogo THEN
					contador_tempo_jogo := contador_tempo_jogo + 1;
				ELSIF contador_tempo_jogo >= tempo_maximo_contador_jogo THEN
					fimJogo <= '1';
				END IF;
				
				-- Decide a dificuldade
				IF	contador_tempo_jogo < tempo_maximo_contador_jogo / 4 THEN
					dif_signal <= 1;
				ELSIF contador_tempo_jogo < tempo_maximo_contador_jogo / 2 THEN
					dif_signal <= 2;
				ELSIF contador_tempo_jogo < 3 * (tempo_maximo_contador_jogo / 4) THEN
					dif_signal <= 3;
				ELSE
					dif_signal <= 4;
				END IF;
				
				-- Troca marmota
				IF contador_tempo_jogo mod (tempo_maximo_troca_marmota * (5 - dif_signal)) = 0 THEN
					troca_marmota_signal <= '1';
				ELSE 
					troca_marmota_signal <= '0';
				END IF;
				
				-- Tempo em segundos
				IF contador_tempo_jogo mod CLK_RATE = 0 THEN
					tempo_signal <= tempo_signal - 1;
				END IF;
			ELSE
				contador_tempo_jogo := 0;
				troca_marmota_signal <= '0';
				fimJogo <= '0';
				tempo_signal <= TOTAL_GAME_TIME_MS / 1000;
			END IF;
		END IF;
	END PROCESS;
END;