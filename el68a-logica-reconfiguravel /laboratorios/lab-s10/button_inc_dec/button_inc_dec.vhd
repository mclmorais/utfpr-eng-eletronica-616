library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


library work;
use work.seven_seg_pkg.all;

entity button_inc_dec is
    generic(
        N7seg : integer := 4
    );
    port (
        button_inc      : in  std_logic;
        button_dec      : in  std_logic;
        clk             : in  std_logic;
        rst             : in  std_logic;
        value_output    : out integer
    );
end entity button_inc_dec;

architecture a_button_inc_dec of button_inc_dec is
    signal debounced_inc : std_logic;
    signal debounced_dec : std_logic;

  component debounce is
      generic( n_inputs: integer := 2;
                debounce_ms: integer := 100;
                clock_value: integer := 50000000
      );
      port( clk: in std_logic;
            button_in: in std_logic_vector(0 to n_inputs-1);
            pulse_out: out std_logic_vector(0 to n_inputs-1)
      );
    end component debounce;

begin

    instance_debounce : component debounce
    port map (
        clk => clk,
        button_in(0) => button_inc,
        pulse_out(0) => debounced_inc,
        button_in(1) => button_dec,
        pulse_out(1) => debounced_dec
    );  

    -- instance_integer_to_seven_seg : component integer_to_seven_seg
    -- port map (
    --     clk => clk,
    --     integer_in => count,
    --     out_seg => display_out
    -- );
    process(clk, rst)
        variable already_pressed : boolean := true;
        variable increase, decrease : boolean := false;
        variable counter : integer := 0;
    begin
        if rst = '0' then
            if rising_edge(clk) then
                -- Sets increase/decrease flag depending on button press
                if not already_pressed then
                    if debounced_inc = '1' then
                        counter := counter + 1;
                        already_pressed := true;
                    elsif debounced_dec = '1' then
                        counter := counter - 1;
                        already_pressed := true;
                    else
                        already_pressed := false;
                    end if; 
                else
                    if debounced_inc = '0' and debounced_dec = '0' then
                        already_pressed := false;
                    end if;
                end if;
                
                value_output <= counter;
            end if;
        else
            counter := 0;
        end if;
    end process;

    -- seg_gen : for i in 0 to N7Seg - 1 generate
    --     display_out(i) <= seven_seg_numbers(count(i));
    -- end generate seg_gen;
    
end architecture a_button_inc_dec;
