ghdl --clean
ghdl --remove

ghdl -a "S1C17_register.vhd"
ghdl -e S1C17_register

ghdl -a "s1c17_status_register.vhd"
ghdl -e s1c17_status_register

ghdl -a "s1c17_rom.vhd"
ghdl -e s1c17_rom

ghdl -a "s1c17_ram.vhd"
ghdl -e ram

ghdl -a "s1c17_register_file.vhd"
ghdl -e s1c17_register_file

ghdl -a "s1c17_control_unit.vhd"
ghdl -e s1c17_control_unit

ghdl -a "s1c17_alu.vhd"
ghdl -e s1c17_alu

ghdl -a "s1c17_cpu.vhd"
ghdl -e cpu

ghdl -a "s1c17_cpu_tb.vhd"
ghdl -e cpu_tb