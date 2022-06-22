LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.MIPS_Types.ALL;

ENTITY MIPS_Processor IS
END ENTITY MIPS_Processor;

ARCHITECTURE SingleCycle OF MIPS_Processor IS
COMPONENT Mux4 IS
	GENERIC (size: POSITIVE := 16);
	PORT (I0, I1, I2, I3: IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);
	Selection: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
	Output: OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0));
END COMPONENT;
FOR ALL: Mux4 USE ENTITY work.Mux4_1(GenericMux);
	
COMPONENT Mux2 IS
	GENERIC (size: POSITIVE := 16);
	PORT (I0, I1: IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);
	Selection: IN STD_LOGIC;
	Output: OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0));
END COMPONENT;
FOR ALL: Mux2 USE ENTITY work.Mux2_1(GenericMux);
	
-- Clock --
SIGNAL CLK: STD_LOGIC := '1';

-- Program Counter --
SIGNAL PC: INTEGER RANGE 0 TO 2**16 - 1 := 0;

-- Return Register --
SIGNAL Ra: WORD := X"0000";

-- Registers --
SIGNAL Registers: REG_FILE;

-- Data Memory --
SIGNAL Data: MEM_DATA;

-- Instruction --
SIGNAL Instruction: WORD;
SIGNAL RInst: RTYPE_INSTRUCTION;
SIGNAL IInst: ITYPE_INSTRUCTION;
SIGNAL JInst: JTYPE_INSTRUCTION;

-- Control Signals --
SIGNAL ZeroFlag: STD_LOGIC := '0';
SIGNAL RegDst, RegWriteSrc, PCSrc: STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";
SIGNAL RegWrite: STD_LOGIC := '1';
SIGNAL ALUSrc1, ALUSrc2, MemWrite, MemRead, MemToReg, MemSrc: STD_LOGIC := '0';
SIGNAL ALUOP: ALU_OP;

-- Calculated signals --
SIGNAL RsX4, Imm6_16, Imm12_16, RtLower, MemLower, PCplus2, PCplus1, PC_Imm6, PC_Imm12, ImmSh4: WORD := X"0000";

-- Busses --
SIGNAL DataRead_1, DataRead_2, DataWrite, ALUOutput, MemOutput, MemInput, PCIn: WORD := X"0000";

-- Muxes Signals --
SIGNAL RegDstOutput: STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
SIGNAL ALUSrc1Output, ALUSrc2Output, MemToRegOut: WORD := X"0000";

BEGIN
	CLK <= NOT CLK AFTER 50 NS;
	RInst <= RConv(Instruction);
	IInst <= IConv(Instruction);
	JInst <= JConv(Instruction);
	
	-- Calculated Signals --
	RsX4 <= to_stdlogicvector(to_bitvector(DataRead_1) SLL 2);
	Imm6_16 <= STD_LOGIC_VECTOR(resize(SIGNED(IInst.Immediate), Imm6_16'LENGTH));
	Imm12_16 <= STD_LOGIC_VECTOR(resize(SIGNED(JInst.Immediate), Imm12_16'LENGTH));
	RtLower <= STD_LOGIC_VECTOR(resize(SIGNED(DataRead_2(7 DOWNTO 0)), RtLower'LENGTH));
	MemLower <= STD_LOGIC_VECTOR(resize(SIGNED(MemOutput(7 DOWNTO 0)), MemLower'LENGTH));
	PCplus2 <= 	STD_LOGIC_VECTOR(to_unsigned(PC + 2, PCplus2'LENGTH));
	PCplus1 <= 	STD_LOGIC_VECTOR(to_unsigned(PC + 1, PCplus1'LENGTH));
	PC_Imm6 <= 	STD_LOGIC_VECTOR(to_unsigned(PC + conv_integer(IInst.Immediate), PC_Imm6'LENGTH));
	PC_Imm12 <= STD_LOGIC_VECTOR(to_unsigned(PC + conv_integer(JInst.Immediate), PC_Imm12'LENGTH));
	ImmSh4 <= to_stdlogicvector(to_bitvector(Imm12_16) SLL 4);
	
	-- Muxes --
	M1: Mux4 GENERIC MAP (3) PORT MAP (RInst.Rd, RInst.Rt, "111", "001", RegDst, RegDstOutput);
	M2: Mux2 PORT MAP (DataRead_1, RsX4, ALUSrc1, ALUSrc1Output);
	M3: Mux2 PORT MAP (DataRead_2, Imm6_16, ALUSrc2, ALUSrc2Output);
	M4: Mux2 PORT MAP (DataRead_2, RtLower, MemSrc, MemInput);
	M5: Mux2 PORT MAP (MemOutput, MemLower, MemToReg, MemToRegOut);
	M6: Mux4 PORT MAP (ALUOutput, MemToRegOut, PCplus2, ImmSh4, RegWriteSrc, DataWrite);
	M7: Mux4 PORT MAP (PCplus1, PC_Imm6, PC_Imm12, Ra, PCSrc, PCIn);
	
	ControlBlock:	ENTITY work.Control_Unit(MIPS_Control)
		PORT MAP(RInst.OPCODE, RInst.FUNC, ZeroFlag, RegDst, RegWriteSrc, PCSrc, 
		RegWrite, ALUSrc1, ALUSrc2, MemWrite, MemRead, MemToReg, MemSrc, ALUOP);
	
	InstMemBlock:	ENTITY work.Instruction_Memory(Inst_Mem)
		PORT MAP(PC, Instruction);
		
	DataMemBlock:	ENTITY work.Data_Memory(Data_Mem)
		PORT MAP(CLK, ALUOutput, MemInput, MemRead, MemWrite, MemOutput, Data);
		
	RegFileBlock:	ENTITY work.Register_File(MIPS_Registers)
		PORT MAP(CLK, RInst.Rs, RInst.Rt, RegDstOutput, DataWrite, RegWrite, DataRead_1, DataRead_2, Registers);
		
	ALUBlock:		ENTITY work.ALU(ALU_MIPS)
		PORT MAP(ALUSrc1Output, ALUSrc2Output, ALUOP, ALUOutput, ZeroFlag);
	PROCESS (CLK)
	BEGIN
		IF rising_edge(CLK) AND RInst.Opcode /= TERMINATE THEN
			PC <= PC + 1;
		END IF;
	END PROCESS;
END ARCHITECTURE SingleCycle;