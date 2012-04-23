library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.dcpu16_constants.all;

entity dcpu16_control_unit is
port ( 	Clk, Reset : in std_logic;
		opcode : in std_logic_vector(OPCODE_WIDTH-1 downto 0);
		nonbasic_opcode : in std_logic_vector(NONBASIC_OPCODE_WIDTH-1 downto 0);
		rega, regb : in std_logic_vector(5 downto 0);
		comparison_result : in std_logic;
	    ld_ir : out std_logic;
		ld_address : out std_logic;
		ld_operand : out std_logic_vector(1 downto 0);
		alu_a_in_sel, alu_b_in_sel : out std_logic_vector(ALU_SEL_WIDTH-1 downto 0);
		alu_op : out std_logic_vector(ALU_OP_WIDTH-1 downto 0);
		alu_start : out std_logic;
		rega_sel, regb_sel : out std_logic_vector(REG_SEL_WIDTH-1 downto 0);
		pc_in_sel: out std_logic_vector(PC_IN_SEL_WIDTH-1 downto 0);
		sp_in_sel: out std_logic_vector(SP_IN_SEL_WIDTH-1 downto 0);
		ovfl_in_sel : out std_logic_vector(OVFL_IN_SEL_WIDTH-1 downto 0);
		mem_write : out std_logic;
		mem_sel_rd, mem_sel_wr : out std_logic_vector(MEM_SEL_WIDTH-1 downto 0);
		rega_in_sel : out std_logic_vector(REGA_IN_SEL_WIDTH-1 downto 0);
		mem_wr_sel : out std_logic_vector(MEM_WR_SEL_WIDTH-1 downto 0);
		rega_write : out std_logic
	 );
end entity;

architecture behaviour of dcpu16_control_unit is
	type control_unit_state_type is (IDLE, FETCH, DECODE, GET_OPA_ADDR, GET_OPB_ADDR, READOPA, READOPB, EXECUTE, WRITEBACK);
	signal state : control_unit_state_type := IDLE;
	signal skip_instruction : std_logic := '0';
	signal clear_skip : std_logic := '0';
begin
	transition: process(Clk)
	begin
		if rising_edge(Clk) then
			if Reset = '1' then
				state <= IDLE;
			else
				case state is
					when IDLE =>
						state <= FETCH;
					when FETCH =>
						clear_skip <= '0';
						state <= DECODE;			
					when DECODE =>
						if skip_instruction = '0' then
							state <= GET_OPA_ADDR;
						else
							clear_skip <= '1';
							state <= IDLE;
						end if;
					when GET_OPA_ADDR =>
						state <= READOPA;
					when READOPA =>
						state <= GET_OPB_ADDR;
					when GET_OPB_ADDR =>
						state <= READOPB;
					when READOPB =>
						state <= EXECUTE;
					when EXECUTE =>
						state <= WRITEBACK;
					when WRITEBACK =>
						state <= FETCH;
				end case;
			end if;
		end if;	
	end process;

	control: process(state, Reset, opcode, rega, regb, comparison_result)
		variable mem_operand, read_mem_twice : std_logic_vector(1 downto 0) := "00";
		variable branch_instr : std_logic := '0';
		variable next_instr_pc_sel : std_logic_vector(PC_IN_SEL_WIDTH-1 downto 0) := PC_IN_PC;
		variable next_instr_pc_mem_wr_sel : std_logic_vector(MEM_WR_SEL_WIDTH-1 downto 0) := MEM_WR_SEL_PC;
		variable rega_write_ex, pc_write : std_logic := '0';
		variable sp_in_sel_ex : std_logic_vector(SP_IN_SEL_WIDTH-1 downto 0);
		variable mem_sel_a : std_logic_vector(3 downto 0);
		variable mem_sel_b : std_logic_vector(3 downto 0);
	begin
			case state is 
				when IDLE =>
					--state <= FETCH;
					ld_ir <= '0';
					ld_operand <= "00";
					ld_address <= '0';
					rega_write <= '0';
					rega_write_ex := '0';
					skip_instruction <= '0';
					alu_start <= '0';
					mem_write <= '0';
					pc_in_sel <= PC_IN_PC;
					sp_in_sel <= SP_IN_SP;
					sp_in_sel_ex := SP_IN_SP;
					branch_instr := '0';
					pc_write := '0';
					mem_sel_rd <= MEM_SEL_PC;
					mem_sel_wr <= MEM_SEL_ADDRESS_A;
				
				when FETCH =>
					if clear_skip = '1' then
						skip_instruction <= '0';
					end if;
				
					--state <= DECODE;
					ld_ir <= '1';
					ld_operand <= "00";
					ld_address <= '0';
					rega_write <= '0';
					rega_write_ex := '0';
					branch_instr := '0';
					pc_write := '0';
					alu_start <= '0';
					mem_write <= '0';
					pc_in_sel <= PC_IN_PC;
					mem_sel_rd <= MEM_SEL_PC;
					sp_in_sel <= SP_IN_SP;
					sp_in_sel_ex := SP_IN_SP;
					
				when DECODE =>
					--state <= GET_OPA_ADDR;
					ld_ir <= '0';
					ovfl_in_sel <= OVFL_IN_OVFL;
					mem_sel_rd <= MEM_SEL_PC;
					pc_in_sel <= PC_IN_PC;
					ld_operand <= "00";
					mem_operand := "00";
					read_mem_twice := "00";
					rega_write_ex := '0';
					branch_instr := '0';
					pc_write := '0';
					sp_in_sel <= SP_IN_SP;
					sp_in_sel_ex := SP_IN_SP;
										
					--if opcode /= NON_BASIC_OP then
						-- register 
						if rega < std_logic_vector(to_unsigned(8, 6)) then
							rega_sel <= REG_SEL;
							alu_a_in_sel <= ALU_SEL_REG;
							mem_sel_a := MEM_SEL_PC;
							rega_write_ex := '1';
						-- [register]
						elsif (rega >= std_logic_vector(to_unsigned(8, 6))) and (rega <= std_logic_vector(to_unsigned(15, 6))) then
							rega_sel <= REG_PTR_SEL;
							mem_sel_a := MEM_SEL_REGA;
							alu_a_in_sel <= ALU_SEL_OPERAND;
							mem_operand(0) := '1';
						-- [next word + register]
						elsif (rega >= std_logic_vector(to_unsigned(16, 6))) and (rega <= std_logic_vector(to_unsigned(23, 6))) then
							rega_sel <= REG_NXT_WORD_REG_PTR;
							mem_sel_a := MEM_SEL_NXT_WORD_ADD_REGA;
							alu_a_in_sel <= ALU_SEL_OPERAND;
							mem_operand(0) := '1';
							read_mem_twice(0) := '1';
						-- POP / [SP++]
						elsif (rega = std_logic_vector(to_unsigned(24, 6))) then
							rega_sel <= REG_SP_SEL;
							sp_in_sel_ex := SP_IN_SP_ADD_1;
							mem_sel_a := MEM_SEL_REGA;
							alu_a_in_sel <= ALU_SEL_OPERAND;
							mem_operand(0) := '1';
						-- PEEK / [SP]
						elsif (rega = std_logic_vector(to_unsigned(25, 6))) then
							rega_sel <= REG_SP_SEL;
							mem_sel_a := MEM_SEL_REGA;
							alu_a_in_sel <= ALU_SEL_OPERAND;
							mem_operand(0) := '1';				
						-- PUSH / [--SP]
						elsif (rega = std_logic_vector(to_unsigned(26, 6))) then
							rega_sel <= REG_SP_SEL;
							sp_in_sel <= SP_IN_SP_SUB_1;
							mem_sel_a := MEM_SEL_REGA_SUB_1;
							alu_a_in_sel <= ALU_SEL_OPERAND;
							mem_operand(0) := '1';
						-- SP
						elsif (rega = std_logic_vector(to_unsigned(27, 6))) then
							rega_sel <= REG_SP_SEL;
							sp_in_sel_ex := SP_IN_REGA;
							alu_a_in_sel <= ALU_SEL_REG;
							mem_sel_a := MEM_SEL_PC;
							rega_write_ex := '1';
						-- PC
						elsif (rega = std_logic_vector(to_unsigned(28, 6))) then
							rega_sel <= REG_PC_SEL;
							pc_in_sel <= PC_IN_REGA;
							alu_a_in_sel <= ALU_SEL_REG;
							mem_sel_a := MEM_SEL_PC;
							rega_write_ex := '1';
							pc_write := '1';
						-- O
						elsif (rega = std_logic_vector(to_unsigned(29, 6))) then
							rega_sel <= REG_OVFL_SEL;
							ovfl_in_sel <= OVFL_IN_REGA;
							alu_a_in_sel <= ALU_SEL_REG;
							mem_sel_a := MEM_SEL_PC;
							rega_write_ex := '1';
						-- [next word]
						elsif (rega = std_logic_vector(to_unsigned(30, 6))) then
							mem_sel_a := MEM_SEL_NXT_WORD;
							alu_a_in_sel <= ALU_SEL_OPERAND;
							mem_operand(0) := '1';	
							read_mem_twice(0) := '1';
						-- trying to assign a literal --> skip to next instruction
						elsif (rega > std_logic_vector(to_unsigned(30, 6))) then
							null;
							--pc_in_sel <= PC_IN_PC_ADD_1;
							--state <= FETCH;
						end if;

						-- register 
						if regb < std_logic_vector(to_unsigned(8, 6)) then
							regb_sel <= REG_SEL;
							alu_b_in_sel <= ALU_SEL_REG;
							mem_sel_b := MEM_SEL_PC;
						-- [register]
						elsif (regb >= std_logic_vector(to_unsigned(8, 6))) and (regb <= std_logic_vector(to_unsigned(15, 6))) then
							regb_sel <= REG_PTR_SEL;
							mem_sel_b := MEM_SEL_REGB;
							alu_b_in_sel <= ALU_SEL_OPERAND;
							mem_operand(1) := '1';
						-- [next word + register]
						elsif (regb >= std_logic_vector(to_unsigned(16, 6))) and (regb <= std_logic_vector(to_unsigned(23, 6))) then
							regb_sel <= REG_NXT_WORD_REG_PTR;
							mem_sel_b := MEM_SEL_NXT_WORD_ADD_REGB;
							alu_b_in_sel <= ALU_SEL_MEM_DATA;--ALU_SEL_OPERAND;
							mem_operand(1) := '1';
							read_mem_twice(1) := '1';
						-- POP / [SP++]
						elsif (regb = std_logic_vector(to_unsigned(24, 6))) then
							regb_sel <= REG_SP_SEL;
							sp_in_sel_ex := SP_IN_SP_ADD_1;
							mem_sel_b := MEM_SEL_REGB;
							alu_b_in_sel <= ALU_SEL_OPERAND;
							mem_operand(1) := '1';
						-- PEEK / [SP]
						elsif (regb = std_logic_vector(to_unsigned(25, 6))) then
							regb_sel <= REG_SP_SEL;
							mem_sel_b := MEM_SEL_REGB;
							alu_b_in_sel <= ALU_SEL_OPERAND;
							mem_operand(1) := '1';						
						-- PUSH / [--SP]
						elsif (regb = std_logic_vector(to_unsigned(26, 6))) then
							regb_sel <= REG_SP_SEL;
							sp_in_sel <= SP_IN_SP_SUB_1;
							mem_sel_b := MEM_SEL_REGB;
							alu_b_in_sel <= ALU_SEL_OPERAND;
							mem_operand(1) := '1';
						-- SP
						elsif (regb = std_logic_vector(to_unsigned(27, 6))) then
							regb_sel <= REG_SP_SEL;
							alu_b_in_sel <= ALU_SEL_REG;
							mem_sel_b := MEM_SEL_PC;
						-- PC
						elsif (regb = std_logic_vector(to_unsigned(28, 6))) then
							regb_sel <= REG_PC_SEL;
							alu_b_in_sel <= ALU_SEL_REG;
							mem_sel_b := MEM_SEL_PC;
						-- O
						elsif (regb = std_logic_vector(to_unsigned(29, 6))) then
							regb_sel <= REG_OVFL_SEL;
							alu_b_in_sel <= ALU_SEL_REG;	
							mem_sel_b := MEM_SEL_PC;	
						-- [next word]
						elsif (regb = std_logic_vector(to_unsigned(30, 6))) then
							mem_sel_b := MEM_SEL_NXT_WORD;
							alu_b_in_sel <= ALU_SEL_OPERAND;
							mem_operand(1) := '1';
							read_mem_twice(1) := '1';
						-- next word (literal)
						elsif (regb = std_logic_vector(to_unsigned(31, 6))) then
							mem_sel_b := MEM_SEL_PC;
							alu_b_in_sel <= ALU_SEL_OPERAND;
							mem_operand(1) := '1';
							read_mem_twice(1) := '1';
						-- literal
						elsif (regb > std_logic_vector(to_unsigned(31, 6))) then
							regb_sel <= REG_LITERAL_SEL;
							alu_b_in_sel <= ALU_SEL_REG;
							mem_sel_b := MEM_SEL_PC;
							--mem_operand(1) := '1';
							--read_mem_twice(1) := '1';
						end if;
					--end if;
					
					if mem_operand(0) = '1' and mem_operand(1) = '1' and opcode /= NON_BASIC_OP then
						next_instr_pc_sel := PC_IN_PC_ADD_3;
						next_instr_pc_mem_wr_sel := MEM_WR_SEL_PC_ADD_3;
					elsif (mem_operand(0) = '1' or mem_operand(1) = '1') and opcode /= NON_BASIC_OP then
						next_instr_pc_sel := PC_IN_PC_ADD_2;
						next_instr_pc_mem_wr_sel := MEM_WR_SEL_PC_ADD_2;
					elsif mem_operand(1) = '1' and opcode = NON_BASIC_OP then
						next_instr_pc_sel := PC_IN_PC_ADD_2;
						next_instr_pc_mem_wr_sel := MEM_WR_SEL_PC_ADD_2;
					else
						next_instr_pc_sel := PC_IN_PC_ADD_1;
						next_instr_pc_mem_wr_sel := MEM_WR_SEL_PC_ADD_1;
					end if;
					
					if skip_instruction = '1' then					
						pc_in_sel <= next_instr_pc_sel;
					end if;
					
					if read_mem_twice(0) = '1' then
						pc_in_sel <= PC_IN_PC_ADD_1;
						mem_sel_rd <= MEM_SEL_PC_ADD_1;
					end if;
									
					case opcode is
						when NON_BASIC_OP =>
							case nonbasic_opcode is
								when JSR_OP =>
									-- push PC to stack
									rega_sel <= REG_SP_SEL;
									sp_in_sel_ex := SP_IN_SP_ADD_1;
									mem_sel_a := MEM_SEL_REGA;
									pc_write := '1';
									
									if mem_operand(1) = '1' then
										rega_in_sel <= REGA_IN_SEL_OPERAND;
									else
										rega_in_sel <= REGA_IN_SEL_REGB; 
									end if;
									
									mem_wr_sel <= next_instr_pc_mem_wr_sel;
																		
									mem_operand(0) := '1';
									read_mem_twice(0) := '0';
								when others =>
									null;
							end case;
							
						when SET_OP =>
							if mem_operand(1) = '1' then
								rega_in_sel <= REGA_IN_SEL_OPERAND;
								mem_wr_sel <= MEM_WR_SEL_OPERAND;
							else
								rega_in_sel <= REGA_IN_SEL_REGB;
								mem_wr_sel <= MEM_WR_SEL_REGB;
							end if;
							
						when ADD_OP =>
							alu_op <= ALU_OP_ADD;
							rega_in_sel <= REGA_IN_SEL_ALU;
							mem_wr_sel <= MEM_WR_SEL_ALU;
													
						when SUB_OP =>
							alu_op <= ALU_OP_SUB;
							rega_in_sel <= REGA_IN_SEL_ALU;
							mem_wr_sel <= MEM_WR_SEL_ALU;
						
						when MUL_OP =>
							alu_op <= ALU_OP_MUL;
							rega_in_sel <= REGA_IN_SEL_ALU;
							mem_wr_sel <= MEM_WR_SEL_ALU;
						
						when DIV_OP =>
							alu_op <= ALU_OP_DIV;
							rega_in_sel <= REGA_IN_SEL_ALU;
							mem_wr_sel <= MEM_WR_SEL_ALU;
							
						when MOD_OP =>
							alu_op <= ALU_OP_MOD;
							rega_in_sel <= REGA_IN_SEL_ALU;
							mem_wr_sel <= MEM_WR_SEL_ALU;
							
						when SHL_OP =>
							alu_op <= ALU_OP_SHL;
							rega_in_sel <= REGA_IN_SEL_ALU;
							mem_wr_sel <= MEM_WR_SEL_ALU;
							
						when SHR_OP =>
							alu_op <= ALU_OP_SHR;
							rega_in_sel <= REGA_IN_SEL_ALU;
							mem_wr_sel <= MEM_WR_SEL_ALU;
							
						when AND_OP =>
							alu_op <= ALU_OP_AND;
							rega_in_sel <= REGA_IN_SEL_ALU;
							mem_wr_sel <= MEM_WR_SEL_ALU;
							
						when BOR_OP =>
							alu_op <= ALU_OP_BOR;
							rega_in_sel <= REGA_IN_SEL_ALU;
							mem_wr_sel <= MEM_WR_SEL_ALU;
							
						when XOR_OP =>
							alu_op <= ALU_OP_XOR;
							rega_in_sel <= REGA_IN_SEL_ALU;
							mem_wr_sel <= MEM_WR_SEL_ALU;
							
						when IFE_OP =>
							alu_op <= ALU_OP_EQUALS;	
							branch_instr := '1';
							
						when IFN_OP =>
							alu_op <= ALU_OP_NOTEQUALS;	
							branch_instr := '1';
							
						when IFG_OP =>
							alu_op <= ALU_OP_GREATER_THAN;	
							branch_instr := '1';
							
						when IFB_OP =>
							alu_op <= ALU_OP_AND_NE_ZERO;	
							branch_instr := '1';
							
						when others =>
							null;
							
					end case;
				
				when GET_OPA_ADDR =>
					sp_in_sel <= SP_IN_SP;
					pc_in_sel <= PC_IN_PC;
					mem_sel_rd <= mem_sel_a;
					ld_address <= '1';
				
				when READOPA =>
					if opcode = NON_BASIC_OP and nonbasic_opcode = JSR_OP then
						rega_sel <= REG_PC_SEL;
						rega_write_ex := '1';
					end if;
				
					ld_address <= '0';
					ld_operand(0) <= '1';
					
					if read_mem_twice(1) = '1' then
						mem_sel_rd <= MEM_SEL_PC_ADD_1;
						pc_in_sel <= PC_IN_PC_ADD_1;
					else
						pc_in_sel <= PC_IN_PC;
						mem_sel_rd <= MEM_SEL_PC;
					end if;
		
				
				when GET_OPB_ADDR =>
					ld_operand(0) <= '0';
					mem_sel_rd <= mem_sel_b;
					pc_in_sel <= PC_IN_PC;
				
				when READOPB =>
					ld_operand(1) <= '1';

				when EXECUTE =>	
					ld_operand(1) <= '0';
					sp_in_sel <= sp_in_sel_ex;
					-- pc_in_sel <= PC_IN_PC;
					alu_start <= '1';
					pc_in_sel <= PC_IN_PC_ADD_1;					

				when WRITEBACK =>
					if pc_write = '1' then
						mem_sel_rd <= MEM_SEL_REG_A_IN;
					else			
						mem_sel_rd <= MEM_SEL_PC;
					end if;
					-- mem_sel_rd <= MEM_SEL_PC_ADD_1;
					--pc_in_sel <= PC_IN_PC_ADD_1;
					pc_in_sel <= PC_IN_PC;
					
					alu_start <= '0';	
					sp_in_sel <= SP_IN_SP;						
					rega_write <= rega_write_ex;
					
					if mem_operand(0) = '1' and branch_instr = '0' then
						mem_sel_wr <= MEM_SEL_ADDRESS_A;
						mem_write <= '1';
					else
						mem_write <= '0';
					end if;
					
					if (opcode = IFE_OP) or (opcode = IFN_OP) or (opcode = IFG_OP) or (opcode = IFB_OP) then
						if comparison_result = '0' then
							skip_instruction <= '1';
							--pc_in_sel <= PC_IN_PC_ADD_2;
							--mem_sel_rd <= MEM_SEL_PC_ADD_2;
						else
							skip_instruction <= '0';
						end if;
					end if;
								
					
			end case;	
	end process;

end architecture;
