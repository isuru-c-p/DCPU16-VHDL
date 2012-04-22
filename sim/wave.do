onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal -label Clk /dut/Clk
add wave -noupdate -format Logic -radix hexadecimal -label Reset /dut/Reset

add wave -noupdate -format Literal -radix hexadecimal -label state /dut/controlunit0/state

add wave -noupdate -divider Memory

add wave -noupdate -format Literal -radix hexadecimal -label mem_rd_addr /dut/mem_rd_addr
add wave -noupdate -format Literal -radix hexadecimal -label mem_wr_addr /dut/mem_wr_addr
add wave -noupdate -format Literal -radix hexadecimal -label mem_wr_data /dut/mem_wr_data
add wave -noupdate -format Logic -radix hexadecimal -label mem_data /dut/mem_data
add wave -noupdate -format Logic -radix hexadecimal -label mem_write_int /dut/mem_write_int

add wave -noupdate -divider ControlUnit

add wave -noupdate -format Literal -radix hexadecimal -label opcode /dut/opcode
add wave -noupdate -format Literal -radix hexadecimal -label opcode /dut/nonbasic_opcode
add wave -noupdate -format Logic -radix hexadecimal -label ld_ir /dut/ld_ir
add wave -noupdate -format Logic -radix hexadecimal -label ld_address /dut/ld_address
add wave -noupdate -format Logic -radix hexadecimal -label ld_operand /dut/ld_operand
add wave -noupdate -format Literal -radix hexadecimal -label alu_a_in_sel /dut/alu_a_in_sel
add wave -noupdate -format Literal -radix hexadecimal -label alu_b_in_sel /dut/alu_b_in_sel
add wave -noupdate -format Literal -radix hexadecimal -label alu_op /dut/alu_op
add wave -noupdate -format Logic -radix hexadecimal -label alu_start /dut/alu_start
add wave -noupdate -format Literal -radix hexadecimal -label rega_sel /dut/rega_sel
add wave -noupdate -format Literal -radix hexadecimal -label regb_sel /dut/regb_sel
add wave -noupdate -format Literal -radix hexadecimal -label pc_in_sel /dut/pc_in_sel
add wave -noupdate -format Literal -radix hexadecimal -label sp_in_sel /dut/sp_in_sel
add wave -noupdate -format Literal -radix hexadecimal -label ovfl_in_sel /dut/ovfl_in_sel
add wave -noupdate -format Logic -radix hexadecimal -label mem_write_int /dut/mem_write_int
add wave -noupdate -format Literal -radix hexadecimal -label mem_sel_rd /dut/mem_sel_rd
add wave -noupdate -format Literal -radix hexadecimal -label mem_sel_wr /dut/mem_sel_wr
add wave -noupdate -format Literal -radix hexadecimal -label rega_in_sel /dut/rega_in_sel
add wave -noupdate -format Logic -radix hexadecimal -label rega_write /dut/rega_write

add wave -noupdate -divider DataPath

add wave -noupdate -format Literal -radix hexadecimal -label PC /dut/datapath0/PC
add wave -noupdate -format Literal -radix hexadecimal -label SP /dut/datapath0/SP
add wave -noupdate -format Literal -radix hexadecimal -label instruction_reg /dut/datapath0/instruction_reg
add wave -noupdate -format Literal -radix hexadecimal -label address_reg /dut/datapath0/address_reg
add wave -noupdate -format Literal -radix hexadecimal -label operand_reg_a /dut/datapath0/operand_reg_a
add wave -noupdate -format Literal -radix hexadecimal -label operand_reg_b /dut/datapath0/operand_reg_b
add wave -noupdate -format Literal -radix hexadecimal -label rega /dut/rega
add wave -noupdate -format Literal -radix hexadecimal -label regb /dut/regb
add wave -noupdate -format Literal -radix hexadecimal -label rega_val /dut/datapath0/regfile0/rega_val
add wave -noupdate -format Literal -radix hexadecimal -label regb_val /dut/datapath0/regfile0/regb_val
add wave -noupdate -format Literal -radix hexadecimal -label comparison_result /dut/comparison_result
add wave -noupdate -format Literal -radix hexadecimal -label alu_a /dut/datapath0/alu0/alu_a
add wave -noupdate -format Literal -radix hexadecimal -label alu_b /dut/datapath0/alu0/alu_b
add wave -noupdate -format Literal -radix hexadecimal -label alu_result /dut/datapath0/alu_result
add wave -noupdate -format Literal -radix hexadecimal -label rega_in /dut/datapath0/regfile0/rega_in
add wave -noupdate -format Literal -radix hexadecimal -label registers /dut/datapath0/regfile0/registers


TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {35999000 ps} 0}
configure wave -namecolwidth 228
configure wave -valuecolwidth 144
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {11789100 ps} {12011100 ps}
