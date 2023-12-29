library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity corte_madeira is
  port (
    inputA  : in std_logic;
    inputB  : in std_logic;
    inputC  : in std_logic;
    inputD  : in std_logic;
    outputL : out std_logic;
    outputT : out std_logic;
    outputF : out std_logic;
    outputR : out std_logic
  );
end entity corte_madeira;

architecture a_corte_madeira of corte_madeira is

  signal emergency_shutdown : std_logic;

begin

  emergency_shutdown <= (inputC and inputD) or (inputB and inputD);



  outputL <= not emergency_shutdown and inputA;
  outputT <= not emergency_shutdown and (inputA and inputB);
  outputF <= not emergency_shutdown and inputC;
  outputR <= not emergency_shutdown and inputD;

  
  -- Versão com emergency_shutdown booleano:

  -- emergency_shutdown <= true when ((inputC and inputD) or (inputB and inputC)) = '1' else false;
  -- outputL <= '0' when emergency_shutdown else inputA;
  -- outputT <= '0' when emergency_shutdown else (inputA and inputB);
  -- outputF <= '0' when emergency_shutdown else inputC;
  -- outputR <= '0' when emergency_shutdown else inputD;

end architecture a_corte_madeira;
