--************************************************************
-- S1C17 CENTRAL PROCESSING UNIT
-- EQUIPE 6 - MARCELO E JOAO
-- Unidade principal que une todos os segmentos necessários para simulação da
-- isa S1C17. Na CPU são implementados banco de registradores, unidade
-- lógica aritmética, unidade de controle, program counter, registrador de
-- status, além de registradores de pipeline.
--************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu is
    port(
        clk : in std_logic;
        rst : in std_logic
    );
end cpu;

architecture a_cpu of cpu is

    component s1c17_register is
        port (
            clk      : in    std_logic;
            rst      : in    std_logic;
            wen      : in    std_logic;
            data_in  : in    unsigned(23 downto 0);
            data_out : out   unsigned(23 downto 0)
          );
    end component s1c17_register;

    component s1c17_status_register is
        port (
            clk          : in  std_logic;
            rst          : in  std_logic;
            wen          : in  std_logic;
            c_in, z_in   : in  std_logic;
            c_out, z_out : out std_logic
        );
    end component s1c17_status_register;

    component s1c17_rom is
        port(
            clk      : in  std_logic;
            addr     : in  unsigned(23 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component s1c17_rom;

    component s1c17_register_file is
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
    end component s1c17_register_file;

    component s1c17_control_unit is
    port(
        clk         : in std_logic;
        rst         : in std_logic;
        c, z        : in std_logic;
        instr_in    : in unsigned(15 downto 0);
        WEFile      : out std_logic;
        WDSrc       : out unsigned(1 downto 0);
        PCSrc       : out std_logic;
        ALUOp       : out unsigned(1 downto 0);
        PCImm       : out std_logic;
        FLUpdt      : out std_logic;
        WERam       : out std_logic;
        ALUSrc      : out std_logic
    );
    end component s1c17_control_unit;

    component s1c17_alu is
        port (
            op          : in unsigned(1 downto 0);
            in_a, in_b  : in unsigned(23 downto 0);
            zf, cf      : out std_logic;
            out_value   : out unsigned(23 downto 0)
        );
    end component s1c17_alu;

    component ram is
        port(
        clk         : in std_logic;
        endereco    : in unsigned(6 downto 0);
        wr_en       : in std_logic;
        dado_in     : in unsigned(15 downto 0);
        dado_out    : out unsigned(15 downto 0)
     );
    end component ram;

    signal  pc_in_s         : unsigned(23 downto 0);
    signal  pc_out_s        : unsigned(23 downto 0);

    signal  rom_in_s        : unsigned(23 downto 0);
    signal  rom_out_s       : unsigned(15 downto 0);

    signal  ram_addr_in_s   : unsigned(6 downto 0);
    signal  ram_wen_s       : std_logic;
    signal  ram_data_in_s   : unsigned(15 downto 0);
    signal  ram_data_out_s  : unsigned(15 downto 0);

    signal  rfd_instr_in_s      : unsigned(23 downto 0);
    signal  rfd_instr_out_s     : unsigned(23 downto 0);

    signal  file_a1_s       : unsigned( 2 downto 0);
    signal  file_a2_s       : unsigned( 2 downto 0);
    signal  file_a3_s       : unsigned( 2 downto 0);
    signal  file_wd3_s      : unsigned(23 downto 0);
    signal  file_we3_s      : std_logic;
    signal  file_rd1_s      : unsigned(23 downto 0);
    signal  file_rd2_s      : unsigned(23 downto 0);

    signal  uc_in           : unsigned(15 downto 0);

    signal  WEFile          : std_logic;
    signal  WDSrc           : unsigned(1 downto 0);
    signal  PCSrc           : std_logic;
    signal  ALUOp           : unsigned(1 downto 0);
    signal  PCImm           : std_logic;
    signal  FLUpdt          : std_logic;
    signal  WERam           : std_logic;
    signal  ALUSrc          : std_logic;
    
    signal  rde_rd1_in_s    : unsigned(23 downto 0);
    signal  rde_rd1_out_s   : unsigned(23 downto 0);
    
    signal  rde_rd2_in_s    : unsigned(23 downto 0);
    signal  rde_rd2_out_s   : unsigned(23 downto 0);

    signal  rde_imm_in_s    : unsigned (23 downto 0);
    signal  rde_imm_out_s   : unsigned (23 downto 0);

    signal  rde_a3_in_s     : unsigned (23 downto 0);
    signal  rde_a3_out_s    : unsigned (23 downto 0);

    signal  rde_ctrl_in_s   : unsigned (23 downto 0);
    signal  rde_ctrl_out_s  : unsigned (23 downto 0);

    signal  rde_ram_in_s   : unsigned (23 downto 0);
    signal  rde_ram_out_s  : unsigned (23 downto 0);

    signal  alu_a_s         : unsigned (23 downto 0);
    signal  alu_b_s         : unsigned (23 downto 0);
    signal  alu_out_s       : unsigned (23 downto 0);
    signal  alu_op_s        : unsigned (1 downto 0);
    signal  alu_cf_s        : std_logic;
    signal  alu_zf_s        : std_logic;

    signal  status_cf_in_s  : std_logic;
    signal  status_zf_in_s  : std_logic;

    signal  status_cf_out_s : std_logic;
    signal  status_zf_out_s : std_logic;

    signal  DE_WEFile       : std_logic;
    signal  DE_WDSrc        : unsigned(1 downto 0);
    signal  DE_PCSrc        : std_logic;
    signal  DE_ALUOp        : unsigned(1 downto 0);
    signal  DE_PCImm        : std_logic;
    signal  DE_FLUpdt       : std_logic;
    signal  DE_WERam        : std_logic;
    signal  DE_ALUSrc       : std_logic;


begin
    --Ligação sinais entrada PC
    pc_in_s             <=  rde_rd2_out_s   when DE_PCSrc = '1'
                                            else
                            pc_out_s + rde_imm_out_s   when DE_PCImm = '1'
                                            else
                            pc_out_s + 1;
    
    --Ligação sinais entrada ROM
    rom_in_s        <=  pc_out_s;

    --Ligação sinais entrada RAM
    ram_addr_in_s   <=  rde_rd2_out_s(6 downto 0);
    ram_wen_s       <=  DE_WERam;
    ram_data_in_s   <=  rde_rd1_out_s(15 downto 0);

    --Ligação sinais entrada Pipeline RFD
    rfd_instr_in_s  <=  X"00" & rom_out_s;

    --Ligação sinais entrada Register File
    file_a1_s       <=  rfd_instr_out_s(9 downto 7);

    file_a2_s       <=  rfd_instr_out_s(2 downto 0);

    file_a3_s       <=  rde_a3_out_s(2 downto 0);

    file_wd3_s      <=  alu_out_s       when DE_WDSrc = "01"
                                        else
                        rde_rd2_out_s   when DE_WDSrc = "10"
                                        else
                        rde_imm_out_s   when DE_WDSrc = "11"
                                        else
                        resize(ram_data_out_s, 24)   when DE_WDSrc = "00"
                        else
                        X"000000";

    file_we3_s      <=  '1'         when DE_WEFile = '1'
                                    else
                        '0';


    --Ligação sinais entrada unidade de controle 
    --TODO: colocar ligacoes diretas de carry e zero em sinais por aqui
    uc_in           <= rfd_instr_out_s(15 downto 0);

    --Ligação sinais entrada Pipeline RDE
    rde_rd1_in_s    <=  file_rd1_s;
    rde_rd2_in_s    <=  file_rd2_s;
    rde_imm_in_s    <=  unsigned(resize(signed(rfd_instr_out_s(6 downto 0)), 24));
    rde_a3_in_s     <=  resize(rfd_instr_out_s(9 downto 7), 24);
    rde_ctrl_in_s   <=  "00000000000000" & ALUSrc & WERam & FLUpdt & PCImm & WEFile & WDSrc & PCSrc & ALUOp;
    rde_ram_in_s    <=  resize(ram_data_out_s, 24);

    --Ligação sinais entrada ALU
    alu_a_s         <= rde_rd1_out_s;
    alu_b_s         <= rde_imm_out_s when DE_ALUSrc = '1' else rde_rd2_out_s;
    alu_op_s        <= DE_ALUOp;

    --Ligação sinais Status Register
    status_cf_in_s  <= alu_cf_s when DE_FLUpdt = '1' else status_cf_out_s;
    status_zf_in_s  <= alu_zf_s when DE_FLUpdt = '1' else status_zf_out_s;

    --Ligação sinais controle Decode/Execute
    DE_ALUSrc       <= rde_ctrl_out_s(9);
    DE_WERam        <= rde_ctrl_out_s(8);
    DE_FLUpdt       <= rde_ctrl_out_s(7);
    DE_PCImm        <= rde_ctrl_out_s(6);
    DE_WEFile       <= rde_ctrl_out_s(5);
    DE_WDSrc        <= rde_ctrl_out_s(4 downto 3);
    DE_PCSrc        <= rde_ctrl_out_s(2);
    DE_ALUOp        <= rde_ctrl_out_s(1 downto 0);


    program_counter: s1c17_register
        port map(
            clk         => clk,
            rst         => rst,
            wen         => '1',
            data_in     => pc_in_s,
            data_out    => pc_out_s
        );

    rom : s1c17_rom
        port map(
            clk         => clk,
            addr        => rom_in_s,
            data_out    => rom_out_s
        );

    c_ram : ram
        port map(
            clk => clk,
            endereco    => ram_addr_in_s,
            wr_en       => ram_wen_s,
            dado_in     => ram_data_in_s,
            dado_out    => ram_data_out_s
        );

    RFDInstr: s1c17_register
        port map(
            clk         => clk,
            rst         => rst,
            wen         => '1',
            data_in     => rfd_instr_in_s,
            data_out    => rfd_instr_out_s
        );

    register_file : s1c17_register_file
        port map(
            clk         => clk,
            rst         => rst,
            we3         => file_we3_s,
            a1          => file_a1_s,
            a2          => file_a2_s,
            a3          => file_a3_s,
            wd3         => file_wd3_s,
            rd1         => file_rd1_s,
            rd2         => file_rd2_s
        );

    control_unit : s1c17_control_unit
        port map(
            clk         => clk,
            rst         => rst,
            c           => status_cf_out_s,
            z           => status_zf_out_s,
            instr_in    => uc_in,
            WEFile      => WEFile,
            WDSrc       => WDSrc,
            PCSrc       => PCSrc,
            ALUOp       => ALUOp,
            PCImm       => PCImm,
            FLUpdt      => FLUpdt,
            WERam       => WERam,
            ALUSrc      => ALUSrc
        );

    RDE_rd1: s1c17_register
        port map(
            clk         => clk,
            rst         => rst,
            wen         => '1',
            data_in     => rde_rd1_in_s,
            data_out    => rde_rd1_out_s
        );

    RDE_rd2: s1c17_register
        port map(
            clk         => clk,
            rst         => rst,
            wen         => '1',
            data_in     => rde_rd2_in_s,
            data_out    => rde_rd2_out_s
        );

    RDE_imm: s1c17_register
        port map(
            clk         => clk,
            rst         => rst,
            wen         => '1',
            data_in     => rde_imm_in_s,
            data_out    => rde_imm_out_s
        );

    RDE_a3: s1c17_register
        port map(
            clk         => clk,
            rst         => rst,
            wen         => '1',
            data_in     => rde_a3_in_s,
            data_out    => rde_a3_out_s
        );

    RDE_ctrl: s1c17_register
        port map(
            clk         => clk,
            rst         => rst,
            wen         => '1',
            data_in     => rde_ctrl_in_s,
            data_out    => rde_ctrl_out_s
        );

    RDE_ram: s1c17_register
        port map(
            clk         => clk,
            rst         => rst,
            wen         => '1',
            data_in     => rde_ram_in_s,
            data_out    => rde_ram_out_s
        );



    alu : s1c17_alu
        port map (
            op          => alu_op_s,
            in_a        => alu_a_s,
            in_b        => alu_b_s,
            zf          => alu_zf_s,
            cf          => alu_cf_s,
            out_value   => alu_out_s
        );

    status_register: s1c17_status_register
        port map(
            clk         => clk,
            rst         => rst,
            wen         => '1',
            c_in        => status_cf_in_s,
            z_in        => status_zf_in_s,
            c_out       => status_cf_out_s,
            z_out       => status_zf_out_s
        );


end a_cpu;