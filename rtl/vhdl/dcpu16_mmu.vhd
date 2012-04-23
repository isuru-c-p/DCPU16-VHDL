library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.dcpu16_constants.all;

entity dcpu16_mmu is
port (
	Clk, Reset : in std_logic;
	WriteEn_in : in std_logic;
	Wr_Address_in : in std_logic_vector(MEM_WIDTH-1 downto 0);
	Rd_Address_in : in std_logic_vector(MEM_WIDTH-1 downto 0);
	Q_out : out std_logic_vector(MEM_WIDTH-1 downto 0);
	WriteData : in std_logic_vector(MEM_WIDTH-1 downto 0);
	
	Mem_WriteEn_out : out std_logic;
	Mem_Wr_Address_out : out std_logic_vector(MEM_WIDTH-1 downto 0);
	Mem_Rd_Address_out : out std_logic_vector(MEM_WIDTH-1 downto 0);
	Mem_Q_in : in std_logic_vector(MEM_WIDTH-1 downto 0);
	Mem_WriteData_out : out std_logic_vector(MEM_WIDTH-1 downto 0);
	
	VGA_Controller_WriteEn_out : out std_logic;
	VGA_Controller_Wr_Address_out : out std_logic_vector(MEM_WIDTH-1 downto 0);
	VGA_Controller_Rd_Address_out : out std_logic_vector(MEM_WIDTH-1 downto 0);
	VGA_Controller_Q_in : in std_logic_vector(MEM_WIDTH-1 downto 0);
	VGA_Controller_WriteData_out : out std_logic_vector(MEM_WIDTH-1 downto 0)
);
end entity;

architecture behaviour of dcpu16_mmu is
begin	
	process(WriteEn_in, Wr_Address_in, Rd_Address_in, WriteData, Mem_Q_in, VGA_Controller_Q_in)
	begin
		if (Rd_Address_in >= std_logic_vector(to_unsigned(32768, MEM_WIDTH))) and (Rd_Address_in <= std_logic_vector(to_unsigned(33279, MEM_WIDTH))) then
			VGA_Controller_WriteEn_out <= WriteEn_in;
			VGA_Controller_Wr_Address_out <= Wr_Address_in;
			VGA_Controller_Rd_Address_out <= Rd_Address_in;
			VGA_Controller_WriteData_out <= WriteData;	
			Q_out <= VGA_Controller_Q_in;
		else
			Mem_WriteEn_out <= WriteEn_in;
			Mem_Wr_Address_out <= Wr_Address_in;
			Mem_Rd_Address_out <= Rd_Address_in;
			Mem_WriteData_out <= WriteData;
			Q_out <= Mem_Q_in;
		end if;
	end process;

end architecture;	