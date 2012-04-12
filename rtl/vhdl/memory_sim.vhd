library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

library work;
use work.dcpu16_constants.all;

entity memory_sim is
port (
	Clk, Reset : in std_logic;
	WriteEn : in std_logic;
	Wr_Address : in std_logic_vector(MEM_WIDTH-1 downto 0);
	Rd_Address : in std_logic_vector(MEM_WIDTH-1 downto 0);
	Q : out std_logic_vector(MEM_WIDTH-1 downto 0);
	DataIn : in std_logic_vector(MEM_WIDTH-1 downto 0)
);
end entity;

architecture behaviour of memory_sim is
	signal mem_reg : std_logic_vector(MEM_SIZE-1 downto 0);
	signal file_ready : std_logic := '0';
begin 

	
	MemoryProc: process(Clk)
		type charfile is file of character; 
		file memory_file: charfile is "dcpu16_program.bin";
		variable c : character;
		variable memory_int : std_logic_vector(MEM_SIZE-1 downto 0);
		variable memory_byte : std_logic_vector(7 downto 0);
		variable memory_pos : integer := 0;		
		variable base_rd_addr, base_wr_addr : integer := 0;
	begin
		if rising_edge(Clk) then
			if Reset = '1' then
				file_ready <= '0';
				memory_pos := 0;
				mem_reg <= (others => '0');
				memory_int := (others => '0');
				
				while not endfile(memory_file) loop
					read(memory_file, c);
					memory_byte := CONV_STD_LOGIC_VECTOR(character'pos(c), 8);
					memory_int((memory_pos+7) downto memory_pos) := memory_byte;
					memory_pos := memory_pos + 8;
				end loop;
				
				file_ready <= '1';
				mem_reg <= memory_int;		
			else
				base_wr_addr := CONV_INTEGER(Wr_Address) * MEM_WIDTH;
				base_rd_addr := CONV_INTEGER(Rd_Address) * MEM_WIDTH;
			
				if WriteEn = '1' then
					mem_reg((base_wr_addr+15) downto base_wr_addr) <= DataIn;
				end if;
				
				Q <= mem_reg((base_rd_addr+15) downto base_rd_addr);
			end if;
		end if;	
	end process;
	
end architecture;
