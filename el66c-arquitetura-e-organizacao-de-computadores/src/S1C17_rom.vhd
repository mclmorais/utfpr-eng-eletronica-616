--************************************************************
-- S1C17 READ ONLY MEMORY
-- EQUIPE 6 - MARCELO E JOAO
-- TODO: ROM de 256 bytes contendo código de teste utilizado para
-- visualizaCAo do funcionamento da ISA S1C17. A ROM é excepcionalmente
-- endereCada de 2 em 2 bytes para maior facilidade de visualizaCAo e de testes.
--************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity s1c17_rom is
    port(
        clk      : in  std_logic;
        addr     : in  unsigned(23 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity s1c17_rom;

architecture a_s1c17_rom of s1c17_rom is

    type memory is array(0 to 127) of unsigned(15 downto 0);
    constant content : memory := (
        --Carrega Constantes
        1 =>  "1001101010000001", --ld  r5 1
        2 =>  "1001100010100001", --ld  r1 33
        --Carrega R2 (comeca em 0) no endereco R2 (comeca em 0)
        4 =>  "0010010100010010", --ld  [r2] r2
        --R2++
        5 =>  "0011100101000101", --add r2 r5
        --Volta para loop em 4 enquanto r2 < r1
        6 =>  "0011010101000001", --cmp r2 r1
        9 =>  "0000100001111001", --jrlt -7
        --Carrega 2 (primo atual) em R0
        12 => "1001100000000010", --ld  r0 2
        --Carrega 0 (iterador) em R2
        13 => "1001100100000011", --ld  r2 3

        --COMECO DO FOR
        --Pula loop se i >= 33 (fica se i < 33)
        16 => "0011010101000001", --cmp r2 r1
        19 => "0000011000100100", --jpgt FIM FOR
        --Carrega RAM[i] em R4
        22 => "0010001000010010", --ld r4 [r2]

        --COMECO DO WHILE
        25 => "0011011001000101", --cmp r4 r7

        28 => "0000100000001010", --brle FIM WHILE (+10)

        31 => "0011101001010000", --sub r4 r0

        34 => "1001101100011001", --ld  r6, 25

        37 => "0000000101001110", --jpa COMECO WHILE
        --FIM DO WHILE

        --COMECO ZERA RAM SE NAO PRIMO
        40 => "0011011001000111", --cmp r4 r7

        43 => "0000111100000100", --jrne PULA PROXIMA (+4)
        46 => "0010011110010010", --ld [r2] r7 (RAM[i] = 0)
        --FIM ZERA RAM SE NAO PRIMO

        --i++
        49 => "0011100101000101", --add r2 r5

        51 => "1001101100010000", --ld  r6, 16

        54 => "0000000101001110", --jpa COMECO FOR

        --FIM DO FOR


        57 => "1001000000000010", --cmp r0, 2

        60 => "0000111100000111", --jrne ate cmp r2 3

        63 => "1001100000000011", -- ld r0, 3
        64 => "1001100100000100", --ld r2 4

        66 => "0000000101001110", --jpa COMECO FOR

        69 => "1001000000000011", --cmp r0, 3

        72 => "0000111100000111", --jrne ate fim

        75 => "1001100000000101", -- ld r0, 5
        76 => "1001100100000110", --ld r2 6

        78 => "0000000101001110", --jpa COMECO FOR

        --FIM ITERACAO TOTAL

        81 => "1001100100000000", --ld r2 0

        84 => "0010000110010010", -- ld r3, [r2]

        87 =>  "0011100101000101", --add r2 r5

        90 => "1001000100100001", --cmp r2, 33

        93 => "0000100001110101", --jrlt -->84

        96 => "1001001110000000", --cmp r7 0

        99 => "0000111001111101", --jeq -3



        others => (others => '0')
    );

    signal data_out_s : unsigned(15 downto 0) := "0000000000000000";
    
begin

    data_out_s <= content(to_integer(resize(addr,7)));

    data_out <= data_out_s;

end a_s1c17_rom;