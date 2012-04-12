library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library work;
use work.dcpu16_constants.all;

entity dcpu16_reg_file is
port (
	Clk, Reset : in std_logic;
	rega, regb : in std_logic_vector(5 downto 0);
	rega_val, regb_val : out std_logic_vector(15 downto 0);
	rega_sel, regb_sel : in std_logic_vector(REG_SEL_WIDTH-1 downto 0);
	pc_in_sel: in std_logic_vector(PC_IN_SEL_WIDTH-1 downto 0);
	sp_in_sel: in std_logic_vector(SP_IN_SEL_WIDTH-1 downto 0);
	alu_ovfl : in std_logic_vector(15 downto 0);
	ovfl_in_sel : in std_logic_vector(OVFL_IN_SEL_WIDTH-1 downto 0);
	rega_in_sel : in std_logic_vector(REGA_IN_SEL_WIDTH-1 downto 0);
	rega_in : in std_logic_vector(15 downto 0);
	rega_write : in std_logic;
	PC, SP : out std_logic_vector(15 downto 0)
);
end entity;

architecture behaviour of dcpu16_reg_file is
	-- registers (A, B, C, X, Y, Z, I, J, SP, PC, O)
	subtype word_t is std_logic_vector(15 downto 0);
	type memory_t is array(10 downto 0) of word_t;
	signal registers : memory_t;
begin
	ReadWriteReg: process(Clk)
		variable reg_index_a, reg_index_b : integer := 0;
		variable reg_literal_b_a : std_logic_vector(1 downto 0) := "00";
		variable reg_literal_a, reg_literal_b : std_logic_vector(5 downto 0);
	begin
		if rising_edge(Clk) then
			if Reset = '1' then
				for i in 0 to 10 loop
					registers(i) <= (others => '0');
				end loop;
			else
				reg_literal_b_a := "00";
		
				case rega_sel is 
					when REG_SEL =>
						reg_index_a := to_integer(unsigned(rega));
					when REG_PTR_SEL =>
						reg_index_a := to_integer(unsigned(rega)) - 8;--rega - std_logic_vector(to_unsigned(8, 6));
					when REG_NXT_WORD_REG_PTR =>
						reg_index_a := to_integer(unsigned(rega)) - 16;-- - std_logic_vector(to_unsigned(16, 6));
					when REG_SP_SEL =>
						reg_index_a := REG_SP;--std_logic_vector(to_unsigned(8, 6));
					when REG_PC_SEL =>
						reg_index_a := REG_PC;--std_logic_vector(to_unsigned(9, 6));
					when REG_OVFL_SEL =>
						reg_index_a := REG_O;--std_logic_vector(to_unsigned(10, 6));
					when REG_LITERAL_SEL =>
						reg_literal_b_a(0) := '1';
						reg_literal_a := rega - std_logic_vector(to_unsigned(32, 6));
					when others =>
						null;
				end case;
				
				case regb_sel is 
					when REG_SEL =>
						reg_index_b := to_integer(unsigned(regb));
					when REG_PTR_SEL =>
						reg_index_b := to_integer(unsigned(regb)) - 8;--regb - std_logic_vector(to_unsigned(8, 6));
					when REG_NXT_WORD_REG_PTR =>
						reg_index_b := to_integer(unsigned(regb)) - 16;--regb - std_logic_vector(to_unsigned(16, 6));
					when REG_SP_SEL =>
						reg_index_b := REG_SP;--std_logic_vector(to_unsigned(8, 6));
					when REG_PC_SEL =>
						reg_index_b := REG_PC;--std_logic_vector(to_unsigned(9, 6));
					when REG_OVFL_SEL =>
						reg_index_b := REG_O;--std_logic_vector(to_unsigned(10, 6));					
					when REG_LITERAL_SEL =>
						reg_literal_b_a(1) := '1';
						reg_literal_b := regb - std_logic_vector(to_unsigned(32, 6));
					when others =>
						null;
				end case;
				
				if reg_index_a > 10 then
					reg_index_a := 0;
				end if;
				
				if reg_index_b > 10 then
					reg_index_b := 0;
				end if;

				if reg_literal_b_a(1) = '1' then
					regb_val <= std_logic_vector(to_unsigned(0,10)) & reg_literal_b;
				else
					regb_val <= registers(reg_index_b);
				end if;
				
				if reg_literal_b_a(0) = '1' then
					rega_val <= std_logic_vector(to_unsigned(0,10)) & reg_literal_a;
				else
					rega_val <= registers(reg_index_a);
				end if;
				
				if rega_write = '1' then
					if (reg_index_a = REG_PC) then --and (pc_in_sel = PC_IN_REGA) then
						registers(reg_index_a) <= rega_in;
					elsif (reg_index_a = REG_SP) then --and (sp_in_sel = SP_IN_REGA) then
						registers(reg_index_a) <= rega_in;
					-- disallow setting of O flag for now (spec is ambiguous)
					--elsif (reg_index_a = REG_O) and (ovfl_in_sel = OVFL_IN_REGA) then
					--	registers(reg_index_a) <= rega_in;	
					elsif (reg_index_a < REG_SP) then
						registers(reg_index_a) <= rega_in;
					end if;
				end if;

				
				case pc_in_sel is
					when PC_IN_PC_ADD_1 =>
						registers(REG_PC) <= registers(REG_PC) + std_logic_vector(to_unsigned(1,16));
					when PC_IN_PC_ADD_2 =>
						registers(REG_PC) <= registers(REG_PC) + std_logic_vector(to_unsigned(2,16));
					when others =>
						null;
				end case;
				
				case sp_in_sel is
					when SP_IN_SP_ADD_1 =>
						registers(REG_SP) <= registers(REG_SP) + std_logic_vector(to_unsigned(1,16));
					when SP_IN_SP_SUB_1 =>
						registers(REG_SP) <= registers(REG_SP) - std_logic_vector(to_unsigned(1,16));
					when others =>
						null;
				end case;
				
				if ovfl_in_sel = OVFL_IN_ALU then 
					registers(REG_O) <= alu_ovfl;				
				end if;		
				
			end if;
		end if;			
	end process;
	
	PC <= registers(REG_PC);
	SP <= registers(REG_SP);

end architecture;