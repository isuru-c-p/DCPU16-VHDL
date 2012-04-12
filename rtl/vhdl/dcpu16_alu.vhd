library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

library work;
use work.dcpu16_constants.all;

entity dcpu16_alu is
port(
	Clk, Reset : in std_logic;
	alu_a, alu_b : in std_logic_vector(15 downto 0);
	alu_op : in std_logic_vector(ALU_OP_WIDTH-1 downto 0);
	alu_start : in std_logic;
	alu_ovfl : out std_logic_vector(15 downto 0);
	alu_result : out std_logic_vector(15 downto 0);
	comparison_result : out std_logic
);
end entity;

architecture behaviour of dcpu16_alu is
begin
	ALU: process(Clk)
		variable alu_result_int : std_logic_vector(31 downto 0);
	begin
		if rising_edge(Clk) then		
			if alu_start = '1' then
				comparison_result <= '0';
				alu_result <= (others => '0');
				alu_ovfl <= (others => '0');
			
				case alu_op is
					when ALU_OP_ADD =>
						alu_result_int := std_logic_vector(to_unsigned(to_integer(unsigned(alu_a)) + to_integer(unsigned(alu_b)), 32));
						alu_ovfl <= std_logic_vector(to_unsigned(0, 15)) & alu_result_int(16);
					
					when ALU_OP_SUB =>
						if alu_b > alu_a then
							alu_ovfl <= (others => '1');
						else					
							alu_ovfl <= std_logic_vector(to_unsigned(0, 16));
						end if;
					
						alu_result_int := std_logic_vector(to_unsigned(to_integer(unsigned(alu_a)) - to_integer(unsigned(alu_b)), 32));
						
					when ALU_OP_MUL =>
						alu_result_int := std_logic_vector(to_unsigned(to_integer(unsigned(alu_a)) * to_integer(unsigned(alu_b)), 32));
						alu_ovfl <= alu_result_int(31 downto 16);
					
					when ALU_OP_DIV =>
						if alu_b = std_logic_vector(to_unsigned(0, 16)) then
							alu_result_int := (others => '0');
							alu_ovfl <= alu_result_int(31 downto 16);
						else
							alu_result_int := std_logic_vector(to_unsigned(to_integer(unsigned(alu_a)) / to_integer(unsigned(alu_b)), 32));
							alu_ovfl <= std_logic_vector(to_unsigned(to_integer(unsigned(alu_a & std_logic_vector(to_unsigned(0, 16)))) / to_integer(unsigned(alu_b)), 16));
						end if;
												
					when ALU_OP_MOD =>
						if alu_b = std_logic_vector(to_unsigned(0, 16)) then
							alu_result_int := (others => '0');
						else
							alu_result_int := std_logic_vector(to_unsigned(to_integer(unsigned(alu_a)) mod to_integer(unsigned(alu_b)), 32));
						end if;
					
					when ALU_OP_SHL =>
						alu_result_int := std_logic_vector(to_unsigned(to_integer(unsigned(unsigned(alu_a) sll to_integer(unsigned(alu_b)))), 32));
						alu_ovfl <= alu_result_int(31 downto 16);
						
					when ALU_OP_SHR =>
						alu_result_int := std_logic_vector(to_unsigned(to_integer(unsigned(unsigned(alu_a) srl to_integer(unsigned(alu_b)))), 32));
						alu_ovfl <= std_logic_vector(to_unsigned(to_integer(unsigned(unsigned(alu_a & std_logic_vector(to_unsigned(0, 16))) srl to_integer(unsigned(alu_b)))), 16));
					
					when ALU_OP_AND =>
						alu_result_int(15 downto 0) := alu_a and alu_b;
						
					when ALU_OP_BOR =>
						alu_result_int(15 downto 0) := alu_a or alu_b; 
			
					when ALU_OP_XOR =>
						alu_result_int(15 downto 0) := alu_a xor alu_b;
						
					when ALU_OP_EQUALS =>
						if alu_a = alu_b then
							comparison_result <= '1';
						else
							comparison_result <= '0';
						end if;
						
					when ALU_OP_NOTEQUALS =>
						if alu_a /= alu_b then
							comparison_result <= '1';
						else
							comparison_result <= '0';
						end if;
						
					when ALU_OP_GREATER_THAN =>
						if alu_a > alu_b then
							comparison_result <= '1';
						else
							comparison_result <= '0';
						end if;
						
					when ALU_OP_AND_NE_ZERO =>
						if (alu_a and alu_b) /= std_logic_vector(to_unsigned(0, 16)) then
							comparison_result <= '1';
						else
							comparison_result <= '0';
						end if;	
						
					when others =>
						null;
				end case;
				
				alu_result <= alu_result_int(15 downto 0);
			end if;		
		end if;
	end process;
end architecture;