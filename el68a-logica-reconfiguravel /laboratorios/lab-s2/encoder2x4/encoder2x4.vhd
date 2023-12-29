library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity encoder2x4 is
    port(
        signalInput : in std_logic_vector(3 downto 0);
        binaryOutput : out std_logic_vector(1 downto 0)
    );
end entity encoder2x4;

architecture aEncoder2x4 of encoder2x4 is
    signal decoderInput : std_logic_vector(3 downto 0);
begin
    
    binaryOutput <= "00" when signalInput = "0001" else
                    "01" when signalInput = "0010" else
                    "10" when signalInput = "0100" else
                    "11" when signalInput = "1000" else
                    "00";    
    
end architecture aEncoder2x4;
