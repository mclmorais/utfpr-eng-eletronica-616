library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
entity marmota_controller is
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
end entity;

architecture a_marmota_controller of marmota_controller is
	signal num_random           : std_logic_vector(NUM_HOLES - 1 downto 0) := (0 => '1', others => '0');
	constant numero_cte         : std_logic_vector(0 to NUM_HOLES - 1)     := "0000010010";
	signal count_time           : integer                                  := 0;
begin

	-- geracao de marmotas aleatorio
	process (clk, reset, num_random)
		variable feedback : std_logic;
	begin
		feedback := num_random(0);
		for i in 1 to NUM_HOLES - 1 loop
			feedback := feedback xor (num_random(i) and numero_cte(i));
		end loop;
		if (reset = '0' or estado = '0') then
			num_random <= (0 => '1', others => '0');
		elsif (rising_edge(clk)) then
			if troca_marmotas = '1' then
				num_random <= feedback & num_random(NUM_HOLES - 1 downto 1);
			end if;
        end if;
	end process;

	--marcacao de pontos
	process (clk, reset)
        variable point_detected : std_logic := '0';
        variable pressedHoles : std_logic_vector(NUM_HOLES - 1 downto 0) := (others => '1');
    begin
		-- if reset = '1' then
		-- 	point_detected	:= '0';
		-- end if;
        if (rising_edge(clk)) then
            
            if troca_marmotas = '1' then
                    pressedHoles :=  (others => '1');
            end if;

            point_detected := '0';
            
			for i in 0 to NUM_HOLES - 1 loop
				if (num_random(i) = '1' and marretadas(i) = '1' and pressedHoles(i) = '1') then --Compara elemento a elemento para marcacao do ponto
                    point_detected := '1';
                    pressedHoles(i) := '0';
				end if;
            end loop;
            
            holes        <= num_random and pressedHoles; -- Acende os leds correspondentes                    
        else
            pressedHoles := pressedHoles;
        end if;
		marcar_ponto <= point_detected;
	end process;

	--  and 
end architecture;