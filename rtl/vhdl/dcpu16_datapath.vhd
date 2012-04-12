library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library work;
use work.dcpu16_constants.all;

entity dcpu16_datapath is
port (
	Clk, Reset : in std_logic;
	
	-- Memory Interface signals
	mem_data : in std_logic_vector(MEM_WIDTH-1 downto 0);
	mem_rd_addr_out : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0); 
	mem_wr_addr_out : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0); 
	mem_wr_data : out std_logic_vector(MEM_ADDR_WIDTH-1 downto 0);
	mem_wr_out : out std_logic;
	
	-- Signals from/to Control Unit
	opcode : out std_logic_vector(OPCODE_WIDTH-1 downto 0);
	rega, regb : out std_logic_vector(5 downto 0);
	comparison_result : out std_logic;
	ld_ir : in std_logic;
	ld_address : in std_logic;
	ld_operand : in std_logic_vector(1 downto 0);
	alu_a_in_sel, alu_b_in_sel : in std_logic_vector(ALU_SEL_WIDTH-1 downto 0);
	alu_op : in std_logic_vector(ALU_OP_WIDTH-1 downto 0);
	alu_start : in std_logic;
	rega_sel, regb_sel : in std_logic_vector(REG_SEL_WIDTH-1 downto 0);
	pc_in_sel: in std_logic_vector(PC_IN_SEL_WIDTH-1 downto 0);
	sp_in_sel: in std_logic_vector(SP_IN_SEL_WIDTH-1 downto 0);
	ovfl_in_sel : in std_logic_vector(OVFL_IN_SEL_WIDTH-1 downto 0);
	mem_write : in std_logic;
	mem_sel_rd, mem_sel_wr : in std_logic_vector(MEM_SEL_WIDTH-1 downto 0);
	rega_in_sel : in std_logic_vector(REGA_IN_SEL_WIDTH-1 downto 0);
	rega_write : in std_logic	
);
end entity;

architecture behaviour of dcpu16_datapath is
	signal rega_int, regb_int : std_logic_vector(5 downto 0);
	signal rega_val, regb_val, rega_in : std_logic_vector(15 downto 0);
	signal alu_a, alu_b, alu_ovfl, alu_result : std_logic_vector(15 downto 0);
	signal mem_rd_addr, mem_wr_addr, address_reg, instruction_reg, PC, SP : std_logic_vector(15 downto 0);
	signal operand_reg_a, operand_reg_b : std_logic_vector(15 downto 0);
begin
	rega <= rega_int;
	regb <= regb_int;
	rega_int <= instruction_reg(9 downto 4);
	regb_int <= instruction_reg(15 downto 10);
	opcode <= instruction_reg(3 downto 0);
	mem_rd_addr_out <= mem_rd_addr;
	mem_wr_addr_out <= mem_wr_addr;
	mem_wr_out <= mem_write;
	mem_wr_data <= rega_in;
	
	regfile0: entity work.dcpu16_reg_file
	port map (
		Clk => Clk,
		Reset => Reset,
		rega => rega_int, 
		regb => regb_int,
		rega_val => rega_val,
		regb_val => regb_val,
		rega_sel => rega_sel,
		regb_sel => regb_sel,
		pc_in_sel => pc_in_sel,
		sp_in_sel => sp_in_sel,
		alu_ovfl => alu_ovfl,
		ovfl_in_sel => ovfl_in_sel,
		rega_in_sel => rega_in_sel,
		rega_in => rega_in,
		rega_write => rega_write, 
		PC => PC,
		SP => SP
	);
	
	alu0: entity work.dcpu16_alu 
	port map (
		Clk => Clk,
		Reset => Reset,
		alu_a => alu_a,
		alu_b => alu_b,
		alu_op => alu_op,
		alu_start => alu_start,
		alu_ovfl => alu_ovfl,
		alu_result => alu_result,
		comparison_result => comparison_result
	);
	
	InstructionRegister: process(Clk)
	begin
		if rising_edge(Clk) then
			if Reset = '1' then
				instruction_reg <= (others => '0');
			elsif ld_ir = '1' then
				instruction_reg <= mem_data;
			end if;
		end if;
	end process;
	
	AddressRegister: process(Clk)
	begin
		if rising_edge(Clk) then
			if Reset = '1' then
				address_reg <= (others => '0');
			elsif ld_address = '1' then
				address_reg <= mem_rd_addr;
			end if;
		end if;	
	end process;
	
	OperandRegisters: process(Clk)
	begin
		if rising_edge(Clk) then
			if Reset = '1' then
				operand_reg_a <= (others => '0');
				operand_reg_b <= (others => '0');
			elsif ld_operand(0) = '1' then
				operand_reg_a <= mem_data;
			elsif ld_operand(1) = '1' then
				operand_reg_b <= mem_data;
			end if;
		end if;	
	end process;
	
	MemSelMux: process(mem_sel_rd, PC, rega_val, regb_val, mem_data, address_reg)
	begin
		case mem_sel_rd is
			when MEM_SEL_PC =>
				mem_rd_addr <= PC;
			when MEM_SEL_REGA =>
				mem_rd_addr <= rega_val;
			when MEM_SEL_REGB =>
				mem_rd_addr <= regb_val;
			when MEM_SEL_REGA_SUB_1 =>
				mem_rd_addr <= rega_val - std_logic_vector(to_unsigned(1,16));
			when MEM_SEL_REGB_SUB_1 =>
				mem_rd_addr <= regb_val - std_logic_vector(to_unsigned(1,16));
			when MEM_SEL_NXT_WORD_ADD_REGA =>
				mem_rd_addr <= mem_data + rega_val;
			when MEM_SEL_NXT_WORD_ADD_REGB => 
				mem_rd_addr <= mem_data + regb_val;
			when MEM_SEL_NXT_WORD =>
				mem_rd_addr <= mem_data;
			when MEM_SEL_PC_ADD_1 =>
				mem_rd_addr <= PC + std_logic_vector(to_unsigned(1,16));
			when MEM_SEL_ADDRESS_A =>
				mem_rd_addr <= address_reg;
			when others =>
				null;
		end case;	
	end process;
	
	MemWriteSelMux: process(mem_sel_wr, PC, rega_val, regb_val, mem_data, address_reg)
	begin
		case mem_sel_wr is
			when MEM_SEL_PC =>
				mem_wr_addr <= PC;
			when MEM_SEL_REGA =>
				mem_wr_addr <= rega_val;
			when MEM_SEL_REGB =>
				mem_wr_addr <= regb_val;
			when MEM_SEL_REGA_SUB_1 =>
				mem_wr_addr <= rega_val - std_logic_vector(to_unsigned(1,16));
			when MEM_SEL_REGB_SUB_1 =>
				mem_wr_addr <= regb_val - std_logic_vector(to_unsigned(1,16));
			when MEM_SEL_NXT_WORD_ADD_REGA =>
				mem_wr_addr <= mem_data + rega_val;
			when MEM_SEL_NXT_WORD_ADD_REGB => 
				mem_wr_addr <= mem_data + regb_val;
			when MEM_SEL_NXT_WORD =>
				mem_wr_addr <= mem_data;
			when MEM_SEL_PC_ADD_1 =>
				mem_wr_addr <= PC + std_logic_vector(to_unsigned(1,16));
			when MEM_SEL_ADDRESS_A =>
				mem_wr_addr <= address_reg;
			when others =>
				null;
		end case;	
	end process;	
	
	ALU_A_Mux: process(alu_a_in_sel, rega_val, operand_reg_a)
	begin
		case alu_a_in_sel is
			when ALU_SEL_REG =>
				alu_a <= rega_val;
			when ALU_SEL_OPERAND =>
				alu_a <= operand_reg_a;
			when others =>
				null;
		end case;
	end process;
	
	ALU_B_Mux: process(alu_b_in_sel, regb_val, operand_reg_b, mem_data)
	begin
		case alu_b_in_sel is
			when ALU_SEL_REG =>
				alu_b <= regb_val;
			when ALU_SEL_OPERAND =>
				alu_b <= operand_reg_b;
			when ALU_SEL_MEM_DATA =>
				alu_b <= mem_data;
			when others =>
				null;
		end case;
	end process;	
	
	Reg_A_In_Mux: process(rega_in_sel, alu_result, regb_val, operand_reg_b)
	begin
		case rega_in_sel is
			when REGA_IN_SEL_ALU =>
				rega_in <= alu_result;
			when REGA_IN_SEL_REGB =>
				rega_in <= regb_val;
			when REGA_IN_SEL_OPERAND =>
				rega_in <= operand_reg_b;
			when others =>
				null;
		end case;
	end process;

end architecture behaviour;