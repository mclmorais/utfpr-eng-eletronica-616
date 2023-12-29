--************************************************************
-- S1C17 REGISTER FILE
-- EQUIPE 6 - MARCELO E JOAO
-- Implementacao do banco de registradores conforme arquitetura
-- S1C17:
-- Endereçamento com 3 bits
-- Registradores com 24 bits
--************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity s1c17_register_file is
    port (
        clk : in std_logic;
        rst : in std_logic;
        we3 : in std_logic;

        a1  : in unsigned(2 downto 0);
        a2  : in unsigned(2 downto 0);
        a3  : in unsigned(2 downto 0);

        wd3 : in  unsigned(23 downto 0);
        rd1 : out unsigned(23 downto 0);
        rd2 : out unsigned(23 downto 0)
    );
end entity s1c17_register_file;


architecture a_s1c17_register_file of s1c17_register_file is

    component s1c17_register is
        port (
            clk      : in    std_logic;
            rst      : in    std_logic;
            wen      : in    std_logic;
            data_in  : in    unsigned(23 downto 0);
            data_out : out   unsigned(23 downto 0)
        );
    end component;

    --Bus de todas as saidas dos registradores; Ligado em um mux para selecao
    type data_array is array (7 downto 0) of unsigned(23 downto 0);
    signal data_bus     : data_array;

    --Bus de sinais de enable dos registradores; Ligado em um mux para selecao
    signal enable_bus   : unsigned(7 downto 0);

begin

    --Muxes que selecionam dados dos registradores baseado nos sinais a1 e a2
    rd1 <= data_bus(to_integer(a1));
    rd2 <= data_bus(to_integer(a2));

    --Mux que manda 'we3' para o pino 'wen' do registrador selecionado e '0'
    --para os outros registradores
    link_enable_bus : for i in 0 to 7 generate
        enable_bus(i) <= we3 when i = to_integer(a3) else '0';
    end generate;


    register_0: s1c17_register
        port map(
            clk      => clk,
            rst      => rst,
            wen      => enable_bus(0),
            data_in  => wd3,
            data_out => data_bus(0)
        );

    register_1: s1c17_register
        port map(
            data_out  => data_bus(1),
            clk       => clk,
            rst       => rst,
            wen       => enable_bus(1),
            data_in   => wd3
        );

    register_2: s1c17_register
        port map(
            data_out  => data_bus(2),
            clk       => clk,
            rst       => rst,
            wen       => enable_bus(2),
            data_in   => wd3
        );

    register_3: s1c17_register
        port map(
            data_out  => data_bus(3),
            clk       => clk,
            rst       => rst,
            wen       => enable_bus(3),
            data_in   => wd3
        );
    
    register_4: s1c17_register
        port map(
            data_out  => data_bus(4),
            clk       => clk,
            rst       => rst,
            wen       => enable_bus(4),
            data_in   => wd3
        );

    register_5: s1c17_register
        port map(
            data_out  => data_bus(5),
            clk       => clk,
            rst       => rst,
            wen       => enable_bus(5),
            data_in   => wd3
        );

    register_6: s1c17_register
        port map(
            data_out  => data_bus(6),
            clk       => clk,
            rst       => rst,
            wen       => enable_bus(6),
            data_in   => wd3
        );

    register_7: s1c17_register
        port map(
            data_out  => data_bus(7),
            clk       => clk,
            rst       => rst,
            wen       => enable_bus(7),
            data_in   => wd3
        );


end a_s1c17_register_file;