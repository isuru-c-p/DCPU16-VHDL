library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.dcpu16_constants.all;

entity dcpu16_top is
port(
	Clk, Reset : in std_logic
	
	-- Memory interface signals
	--mem_write : out std_logic;
	--mem_addr : out std_logic_vector(15 downto 0);
	--mem_data : in std_logic_vector(15 downto 0)
);
end entity;

architecture behaviour of dcpu16_top is

signal mem_write : std_logic;
signal mem_addr : std_logic_vector(15 downto 0);
signal mem_data, mem_wr_data : std_logic_vector(15 downto 0);

signal opcode : std_logic_vector(OPCODE_WIDTH-1 downto 0);
signal rega, regb : std_logic_vector(5 downto 0);
signal comparison_result : std_logic;
signal ld_ir : std_logic;
signal ld_address : std_logic;
signal ld_operand : std_logic_vector(1 downto 0);
signal alu_a_in_sel, alu_b_in_sel : std_logic_vector(ALU_SEL_WIDTH-1 downto 0);
signal alu_op : std_logic_vector(ALU_OP_WIDTH-1 downto 0);
signal alu_start : std_logic;
signal rega_sel, regb_sel : std_logic_vector(REG_SEL_WIDTH-1 downto 0);
signal pc_in_sel: std_logic_vector(PC_IN_SEL_WIDTH-1 downto 0);
signal sp_in_sel: std_logic_vector(SP_IN_SEL_WIDTH-1 downto 0);
signal ovfl_in_sel : std_logic_vector(OVFL_IN_SEL_WIDTH-1 downto 0);
signal mem_write_int : std_logic;
signal mem_sel : std_logic_vector(MEM_SEL_WIDTH-1 downto 0);
signal rega_in_sel : std_logic_vector(REGA_IN_SEL_WIDTH-1 downto 0);
signal rega_write : std_logic;

begin
	memory0: entity work.memory_sim
	port map(
		Clk => Clk,
		Reset => Reset,
		WriteEn => mem_write,
		Address => mem_addr,
		Q => mem_data,
		DataIn => mem_wr_data
	);

	datapath0: entity work.dcpu16_datapath
	port map(
		Clk => Clk,
		Reset => Reset,
		mem_data => mem_data,
		mem_addr_out => mem_addr,
		mem_wr_out => mem_write,
		opcode => opcode,
		rega => rega,
		regb => regb,
		comparison_result => comparison_result,
		ld_ir => ld_ir,
		ld_address => ld_address,
		ld_operand => ld_operand,
		alu_a_in_sel => alu_a_in_sel,
		alu_b_in_sel => alu_b_in_sel,
		alu_op => alu_op,
		alu_start => alu_start,
		rega_sel => rega_sel,
		regb_sel => regb_sel,
		pc_in_sel => pc_in_sel,
		sp_in_sel => sp_in_sel,
		ovfl_in_sel => ovfl_in_sel,
		mem_write => mem_write_int,
		mem_wr_data => mem_wr_data,
		mem_sel => mem_sel,
		rega_in_sel => rega_in_sel,
		rega_write => rega_write
	);

	controlunit0: entity work.dcpu16_control_unit
	port map(
		Clk => Clk,
		Reset => Reset,
		opcode => opcode,
		rega => rega,
		regb => regb,
		comparison_result => comparison_result,
		ld_ir => ld_ir,
		ld_address => ld_address,
		ld_operand => ld_operand,
		alu_a_in_sel => alu_a_in_sel,
		alu_b_in_sel => alu_b_in_sel,
		alu_op => alu_op,
		alu_start => alu_start,
		rega_sel => rega_sel,
		regb_sel => regb_sel,
		pc_in_sel => pc_in_sel,
		sp_in_sel => sp_in_sel,
		ovfl_in_sel => ovfl_in_sel,
		mem_write => mem_write_int,
		mem_sel => mem_sel,
		rega_in_sel => rega_in_sel,
		rega_write => rega_write		
	);
	
end architecture;