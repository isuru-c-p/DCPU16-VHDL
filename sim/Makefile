#
# DCPU16 VHDL Makefile
#
#

OPTIONS=-93 -quiet
VHDL_DIR=../rtl/vhdl

default: sim

sim:
	vlib work
	vcom $(OPTIONS) $(VHDL_DIR)/dcpu16_constants.vhd
	vcom $(OPTIONS) $(VHDL_DIR)/dcpu16_alu.vhd
	vcom $(OPTIONS) $(VHDL_DIR)/dcpu16_reg_file.vhd
	vcom $(OPTIONS) $(VHDL_DIR)/dcpu16_datapath.vhd
	vcom $(OPTIONS) $(VHDL_DIR)/dcpu16_control_unit.vhd
	vcom $(OPTIONS) $(VHDL_DIR)/memory_sim.vhd
	vcom $(OPTIONS) $(VHDL_DIR)/dcpu16_top.vhd
	vcom $(OPTIONS) $(VHDL_DIR)/sim_testbench.vhd
	vsim -do sim.do sim_testbench -gui