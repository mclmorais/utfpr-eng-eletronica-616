library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.seven_seg_pkg.all;
entity cacetaNaMarmota is
	generic (
		N7SegPrimario   : integer := 2;
		N7SegSecundario : integer := 2;
		NLeds           : integer := 10;
		NChaves         : integer := 10
	);
	port (
		clk             : in std_logic;
		rst             : in std_logic;
		botaoInicio     : in std_logic;
		entradaChaves   : in std_logic_vector(NChaves - 1 downto 0);
		saidaLeds       : out std_logic_vector(NLeds - 1 downto 0);
		saidaPrimaria   : out seven_segment_output(N7SegPrimario - 1 downto 0);
		saidaSecundaria : out seven_segment_output(N7SegPrimario - 1 downto 0)
	);
end entity cacetaNaMarmota;
architecture aCacetaNaMarmota of cacetaNaMarmota is

	component controladorPontos is
		port (
			clk         : in std_logic;
			rst         : in std_logic;
			marcouPonto : in std_logic;
			estado      : in std_logic;
			saidaAtual  : out integer;
			saidaMaxima : out integer
		);
	end component controladorPontos;

	component ControladorEstadoTempo is
		generic (
			CLK_RATE                   : integer := 50000000;
			TOTAL_GAME_TIME_MS         : integer := 40000;
			TEMPO_TROCA_MARMOTA_MIN_MS : integer := 500
		);
		port (
			clk           : in STD_LOGIC;
			bt_inicio     : in STD_LOGIC;
			bt_rst        : in STD_LOGIC;
			troca_marmota : out STD_LOGIC;
			dif           : out integer;
			tempo         : out integer;
			estado        : out STD_LOGIC
		);
	end component ControladorEstadoTempo;

	component marmota_controller is
		generic (
			NUM_HOLES : integer := 10
		);
		port (
			clk, reset     : in std_logic;
			estado				 : in std_logic;
			marretadas     : in std_logic_vector (NUM_HOLES - 1 downto 0);
			troca_marmotas : in std_logic;
			holes          : out std_logic_vector (NUM_HOLES - 1 downto 0);
			marcar_ponto   : out std_logic
		);
	end component marmota_controller;

	component ControladorMarretas is
		generic (
			NUM_HOLES  : integer := 10;
			CLOCK_RATE : integer := 50_000_000);

		port (
			clk       : in std_logic;
			marretada : out std_logic_vector((NUM_HOLES - 1) downto 0);
			marreta   : in std_logic_vector((NUM_HOLES - 1) downto 0)); --Chaves
	end component;

	component driver7seg is
		generic (
			N7SegPrimario   : integer := 2;
			N7SegSecundario : integer := 2
		);
		port (
			estado               : in std_logic;
			clk                  : in std_logic;
			rst                  : in std_logic;
			entradaTempo         : in integer range 0 to ((10 ** N7SegPrimario) - 1);
			entradaPontosMaximos : in integer range 0 to ((10 ** N7SegPrimario) - 1);
			entradaPontosAtuais  : in integer range 0 to ((10 ** N7SegSecundario) - 1);
			saidaPrimaria        : out seven_segment_output(N7SegPrimario - 1 downto 0);
			saidaSecundaria      : out seven_segment_output(N7SegPrimario - 1 downto 0)
		);
	end component driver7seg;

	component debounce is
		generic (
			counter_size : integer := 22); --counter size (19 bits gives 10.5ms with 50MHz clock)
		port (
			clk       : in STD_LOGIC;
			botao     : in STD_LOGIC;
			resultado : out STD_LOGIC);
	end component;

	component debounce2 is
		generic (
			n_inputs    : integer := 10;
			debounce_ms : integer := 5;
			clock_value : integer := 500000000);
		port (
			clk       : in std_logic;
			button_in : in std_logic_vector(0 to n_inputs - 1);
			pulse_out : out std_logic_vector(0 to n_inputs - 1));
	end component debounce2;
	signal s_estado          : std_logic;
	signal s_tempo           : integer;
	signal s_pontosAtuais    : integer;
	signal s_pontosMaximos   : integer;
	signal s_estadoMarretas  : std_logic_vector (NChaves - 1 downto 0);
	signal s_trocaMarmotas   : std_logic;
	signal s_numeroRandomico : std_logic_vector (NChaves - 1 downto 0);
	signal s_marcarPonto     : std_logic;
	signal s_dificuldade     : integer;
	signal s_inicioDebounced : std_logic;
	signal s_ChavesDebounced : std_logic_vector(NChaves - 1 downto 0);

begin
	instanciaControladorPontos : component controladorPontos
		port map(
			clk         => clk,
			rst         => rst,
			marcouPonto => s_marcarPonto,
			estado      => s_estado,
			saidaAtual  => s_pontosAtuais,
			saidaMaxima => s_pontosMaximos
		);

    instanciaControladorEstadoTempo : component ControladorEstadoTempo
        port map(
            clk           => clk,
            bt_inicio     => botaoInicio,
            bt_rst        => rst,
            troca_marmota => s_trocaMarmotas,
            dif           => s_dificuldade,
            tempo         => s_tempo,
            estado        => s_estado
        );

    instanciaControladorMarmota : component marmota_controller
        port map(
            clk            => clk,
            reset          => rst,
						estado				 => s_estado,
            marretadas     => s_estadoMarretas,
            troca_marmotas => s_trocaMarmotas,
            holes          => saidaLeds,
            marcar_ponto   => s_marcarPonto
        );

    instanciaDriver7Seg : component driver7seg
        port map(
            estado               => s_estado,

            clk                  => clk,
            rst                  => rst,
            entradaTempo         => s_tempo,
            entradaPontosMaximos => s_pontosMaximos,
            entradaPontosAtuais  => s_pontosAtuais,
            saidaPrimaria        => saidaPrimaria,
            saidaSecundaria      => saidaSecundaria
        );

    instanciaControladorMarretas : ControladorMarretas
        port map(
            clk       => clk,
            marreta   => s_ChavesDebounced,
            marretada => s_estadoMarretas
        );

    instanceDebounce : debounce
        port map(
            clk       => clk,
            botao     => botaoInicio,
            resultado => s_inicioDebounced);

    instanceDebounce2 : debounce2
        port map(
            clk       => clk,
            button_in => entradaChaves,
            pulse_out => s_ChavesDebounced);
                end architecture aCacetaNaMarmota;