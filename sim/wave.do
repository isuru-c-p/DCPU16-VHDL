onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix hexadecimal /dut/Clk
add wave -noupdate -format Logic -radix hexadecimal /dut/Reset

add wave -noupdate -format Literal -radix hexadecimal /dut/controlunit0/state

add wave -noupdate -divider MemorySim

add wave -noupdate -format Logic -radix hexadecimal /dut/memory0/file_ready

add wave -noupdate -divider Memory

add wave -noupdate -format Literal -radix hexadecimal /dut/mem_addr
add wave -noupdate -format Literal -radix hexadecimal /dut/mem_wr_data
add wave -noupdate -format Logic -radix hexadecimal /dut/mem_data
add wave -noupdate -format Logic -radix hexadecimal /dut/mem_write_int

add wave -noupdate -divider ControlUnit

add wave -noupdate -format Literal -radix hexadecimal /dut/opcode
add wave -noupdate -format Logic -radix hexadecimal /dut/ld_ir
add wave -noupdate -format Logic -radix hexadecimal /dut/ld_address
add wave -noupdate -format Logic -radix hexadecimal /dut/ld_operand
add wave -noupdate -format Literal -radix hexadecimal /dut/alu_a_in_sel
add wave -noupdate -format Literal -radix hexadecimal /dut/alu_b_in_sel
add wave -noupdate -format Literal -radix hexadecimal /dut/alu_op
add wave -noupdate -format Logic -radix hexadecimal /dut/alu_start
add wave -noupdate -format Literal -radix hexadecimal /dut/rega_sel
add wave -noupdate -format Literal -radix hexadecimal /dut/regb_sel
add wave -noupdate -format Literal -radix hexadecimal /dut/pc_in_sel
add wave -noupdate -format Literal -radix hexadecimal /dut/sp_in_sel
add wave -noupdate -format Literal -radix hexadecimal /dut/ovfl_in_sel
add wave -noupdate -format Logic -radix hexadecimal /dut/mem_write_int
add wave -noupdate -format Literal -radix hexadecimal /dut/mem_sel
add wave -noupdate -format Literal -radix hexadecimal /dut/rega_in_sel
add wave -noupdate -format Logic -radix hexadecimal /dut/rega_write

add wave -noupdate -divider DataPath

add wave -noupdate -format Literal -radix hexadecimal /dut/datapath0/PC
add wave -noupdate -format Literal -radix hexadecimal /dut/datapath0/SP
add wave -noupdate -format Literal -radix hexadecimal /dut/datapath0/instruction_reg
add wave -noupdate -format Literal -radix hexadecimal /dut/datapath0/address_reg
add wave -noupdate -format Literal -radix hexadecimal /dut/datapath0/operand_reg_a
add wave -noupdate -format Literal -radix hexadecimal /dut/datapath0/operand_reg_b
add wave -noupdate -format Literal -radix hexadecimal /dut/rega
add wave -noupdate -format Literal -radix hexadecimal /dut/regb
add wave -noupdate -format Literal -radix hexadecimal /dut/comparison_result
add wave -noupdate -format Literal -radix hexadecimal /dut/datapath0/alu0/alu_a
add wave -noupdate -format Literal -radix hexadecimal /dut/datapath0/alu0/alu_b
add wave -noupdate -format Literal -radix hexadecimal /dut/datapath0/alu_result
add wave -noupdate -format Literal -radix hexadecimal /dut/datapath0/regfile0/rega_in
add wave -noupdate -format Literal -radix hexadecimal /dut/datapath0/regfile0/registers


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
