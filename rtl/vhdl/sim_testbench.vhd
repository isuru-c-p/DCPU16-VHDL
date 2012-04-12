library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sim_testbench is
end entity;

architecture behaviour of sim_testbench is
	signal Clk, Reset : std_logic := '0';

begin
	ClkGen: process
	begin
		loop
			Clk <= '0';
			wait for 10 ns;
			Clk <= '1';
			wait for 10 ns;		
		end loop;
	end process;
	
	Reset <= '1', '0' after 30ns;

	dut: entity work.dcpu16_top
	port map(
		Clk => Clk,
		Reset => Reset
	);
	
end architecture;