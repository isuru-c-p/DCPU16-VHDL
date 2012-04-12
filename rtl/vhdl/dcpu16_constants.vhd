library ieee;
use ieee.std_logic_1164.all;

package dcpu16_constants is
	constant OPCODE_WIDTH : integer := 4;
	constant MEM_WIDTH : integer := 16;
	constant MEM_ADDR_WIDTH : integer := 16;
	constant MEM_SIZE : integer := 1048576;

	-- OPCODES
	
	constant NON_BASIC_OP : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "0000";
	constant SET_OP : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "0001";
	constant ADD_OP : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "0010";
	constant SUB_OP : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "0011";
	constant MUL_OP : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "0100";
	constant DIV_OP : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "0101";
	constant MOD_OP : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "0110";
	constant SHL_OP : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "0111";
	constant SHR_OP : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "1000";
	constant AND_OP : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "1001";
	constant BOR_OP : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "1010";
	constant XOR_OP : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "1011";
	constant IFE_OP : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "1100";
	constant IFN_OP : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "1101";
	constant IFG_OP : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "1110";
	constant IFB_OP : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "1111";
	
	constant PC_IN_SEL_WIDTH : integer := 2;
	
	-- PC_IN_SEL
	constant PC_IN_PC : std_logic_vector(PC_IN_SEL_WIDTH-1 downto 0) := "00";
	constant PC_IN_PC_ADD_1 : std_logic_vector(PC_IN_SEL_WIDTH-1 downto 0) := "01";
	constant PC_IN_PC_ADD_2 : std_logic_vector(PC_IN_SEL_WIDTH-1 downto 0) := "10";
	constant PC_IN_REGA : std_logic_vector(PC_IN_SEL_WIDTH-1 downto 0) := "11";

	constant SP_IN_SEL_WIDTH : integer := 2;
	
	-- SP_IN_SEL
	constant SP_IN_SP : std_logic_vector(PC_IN_SEL_WIDTH-1 downto 0) := "00";
	constant SP_IN_SP_ADD_1 : std_logic_vector(PC_IN_SEL_WIDTH-1 downto 0) := "01";
	constant SP_IN_SP_SUB_1 : std_logic_vector(PC_IN_SEL_WIDTH-1 downto 0) := "10";
	constant SP_IN_REGA : std_logic_vector(PC_IN_SEL_WIDTH-1 downto 0) := "11";
	
	-- OVFL_IN_SEL
	constant OVFL_IN_SEL_WIDTH : integer := 2;
	
	constant OVFL_IN_OVFL : std_logic_vector(OVFL_IN_SEL_WIDTH-1 downto 0) := "00";
	constant OVFL_IN_ALU : std_logic_vector(OVFL_IN_SEL_WIDTH-1 downto 0) := "01";
	constant OVFL_IN_REGA : std_logic_vector(OVFL_IN_SEL_WIDTH-1 downto 0) := "10";
	
	constant REG_SEL_WIDTH : integer := 3;
	
	-- REG_SEL
	constant REG_SEL : std_logic_vector(REG_SEL_WIDTH-1 downto 0) := "000";
	constant REG_PTR_SEL : std_logic_vector(REG_SEL_WIDTH-1 downto 0) := "001";
	constant REG_NXT_WORD_REG_PTR : std_logic_vector(REG_SEL_WIDTH-1 downto 0) := "010";
	constant REG_PC_SEL : std_logic_vector(REG_SEL_WIDTH-1 downto 0) := "011";
	constant REG_SP_SEL : std_logic_vector(REG_SEL_WIDTH-1 downto 0) := "100";
	constant REG_OVFL_SEL : std_logic_vector(REG_SEL_WIDTH-1 downto 0) := "101";
	constant REG_LITERAL_SEL : std_logic_vector(REG_SEL_WIDTH-1 downto 0) := "110";
	
	-- COMPARISON_FLAG_BITS
	constant A_EQ_B_BIT : integer := 2;
	constant A_GT_B_BIT : integer := 1;
	constant A_AND_B_NEQ_Z_BIT : integer := 0;
	
	-- MEM_SEL
	constant MEM_SEL_WIDTH : integer := 4;
	
	constant MEM_SEL_PC : std_logic_vector(MEM_SEL_WIDTH-1 downto 0) := "0000";
	constant MEM_SEL_REGA : std_logic_vector(MEM_SEL_WIDTH-1 downto 0) := "0001";
	constant MEM_SEL_REGB : std_logic_vector(MEM_SEL_WIDTH-1 downto 0) := "0010";
	constant MEM_SEL_REGA_SUB_1 : std_logic_vector(MEM_SEL_WIDTH-1 downto 0) := "0011";
	constant MEM_SEL_REGB_SUB_1 : std_logic_vector(MEM_SEL_WIDTH-1 downto 0) := "0100";
	constant MEM_SEL_NXT_WORD_ADD_REGA : std_logic_vector(MEM_SEL_WIDTH-1 downto 0) := "0101";
	constant MEM_SEL_NXT_WORD_ADD_REGB : std_logic_vector(MEM_SEL_WIDTH-1 downto 0) := "0110";
	constant MEM_SEL_NXT_WORD : std_logic_vector(MEM_SEL_WIDTH-1 downto 0) := "0111";
	constant MEM_SEL_PC_ADD_1 : std_logic_vector(MEM_SEL_WIDTH-1 downto 0) := "1000";
	constant MEM_SEL_ADDRESS_A : std_logic_vector(MEM_SEL_WIDTH-1 downto 0) := "1001";
	constant MEM_SEL_PC_ADD_2 : std_logic_vector(MEM_SEL_WIDTH-1 downto 0) := "1010";
	
	-- ALU OP
	constant ALU_OP_WIDTH : integer := 4;
	
	constant ALU_OP_ADD : std_logic_vector(ALU_OP_WIDTH-1 downto 0) := "0000";
	constant ALU_OP_SUB : std_logic_vector(ALU_OP_WIDTH-1 downto 0) := "0001";
	constant ALU_OP_MUL : std_logic_vector(ALU_OP_WIDTH-1 downto 0) := "0010";
	constant ALU_OP_DIV : std_logic_vector(ALU_OP_WIDTH-1 downto 0) := "0011";
	constant ALU_OP_MOD : std_logic_vector(ALU_OP_WIDTH-1 downto 0) := "0100";
	constant ALU_OP_SHL : std_logic_vector(ALU_OP_WIDTH-1 downto 0) := "0101";
	constant ALU_OP_SHR : std_logic_vector(ALU_OP_WIDTH-1 downto 0) := "0110";
	constant ALU_OP_AND : std_logic_vector(ALU_OP_WIDTH-1 downto 0) := "0111";
	constant ALU_OP_BOR : std_logic_vector(ALU_OP_WIDTH-1 downto 0) := "1000";
	constant ALU_OP_XOR : std_logic_vector(ALU_OP_WIDTH-1 downto 0) := "1001";
	constant ALU_OP_EQUALS : std_logic_vector(ALU_OP_WIDTH-1 downto 0) := "1010";
	constant ALU_OP_NOTEQUALS : std_logic_vector(ALU_OP_WIDTH-1 downto 0) := "1011";
	constant ALU_OP_GREATER_THAN : std_logic_vector(ALU_OP_WIDTH-1 downto 0) := "1100";
	constant ALU_OP_AND_NE_ZERO : std_logic_vector(ALU_OP_WIDTH-1 downto 0) := "1101";
	
	
	-- ALU SEL
	constant ALU_SEL_WIDTH : integer := 2;
	
	constant ALU_SEL_REG : std_logic_vector(ALU_SEL_WIDTH-1 downto 0) := "00";
	constant ALU_SEL_OPERAND : std_logic_vector(ALU_SEL_WIDTH-1 downto 0) := "01";
	constant ALU_SEL_MEM_DATA : std_logic_vector(ALU_SEL_WIDTH-1 downto 0) := "10";
	
	-- REGA_IN_SEL
	constant REGA_IN_SEL_WIDTH : integer := 2;
	
	constant REGA_IN_SEL_ALU : std_logic_vector(REGA_IN_SEL_WIDTH-1 downto 0) := "00";
	constant REGA_IN_SEL_REGB : std_logic_vector(REGA_IN_SEL_WIDTH-1 downto 0) := "01";
	constant REGA_IN_SEL_OPERAND : std_logic_vector(REGA_IN_SEL_WIDTH-1 downto 0) := "10";
	
	-- REGFILE constants
	constant REG_A : integer := 0;
	constant REG_B : integer := 1;
	constant REG_C : integer := 2;
	constant REG_X : integer := 3;
	constant REG_Y : integer := 4;
	constant REG_Z : integer := 5;
	constant REG_I : integer := 6;
	constant REG_J : integer := 7;
	constant REG_SP : integer := 8;
	constant REG_PC : integer := 9;
	constant REG_O : integer := 10;
	
end package;
