LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.MIPS_Types.ALL;

------------------------- Control Unit ---------------------------------------
--	RegDst signal is "00" for Rd, "01" for Rt, "10" for R7 and "11" for R1	--
--	RegWrite signal is '1' when writing to the register file				--
--	RegWriteSrc signal is "00" for ALU output, "01" for memory output,		--
--						  "10" for (PC + 2) and "11" for (Immediate << 4)	--
--	ALUSrc1 signal is '0' for Rs and '1' for Rs*4							--
--	ALUSrc2 signal is '0' for Rt and '1' for Immediate						--
--	PCSrc signal is "00" for (PC + 1), "01" for (PC + Imm6),				--
--					"10" for (PC + Imm12) and "11" for Ra					--
--	MemWrite signal is '1' when writing to data memory						--
--	MemRead signal is '1' when reading from data memory						--						
--	MemToReg signal is '0' for memory word and '1' for memory lower byte	--
--	MemSrc signal is '0' for Rt and '1' for lower byte of Rt				--
--	ALUOP signal indicates ALU needed operation								--
------------------------------------------------------------------------------

ENTITY Control_Unit IS
	PORT (Opcode: IN INST_OP; FuncField: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
	ZeroFlag: IN STD_LOGIC;
	RegDst, RegWriteSrc, PCSrc: OUT STD_LOGIC_VECTOR (1 DOWNTO 0) := "00";
	RegWrite: OUT STD_LOGIC := '1';
	ALUSrc1, ALUSrc2, MemWrite, MemRead, MemToReg, MemSrc: OUT STD_LOGIC := '0';
	ALUOP: OUT ALU_OP);
END ENTITY Control_Unit;

ARCHITECTURE MIPS_Control OF Control_Unit IS
BEGIN
	RegDst <= 	"00" WHEN Opcode = ZERO OR Opcode = LWS
	ELSE "01" WHEN Opcode = ANDI OR Opcode = ADDI OR Opcode = SLTI OR Opcode = LW OR Opcode = LLB
	ELSE "10" WHEN Opcode = JAL
	ELSE "11" WHEN Opcode = LUI;
		
	RegWriteSrc <= 	"01" WHEN Opcode = LW OR Opcode = LLB OR Opcode = LWS
	ELSE "10" WHEN Opcode = JAL
	ELSE "11" WHEN Opcode = LUI
	ELSE "00";
		
	RegWrite <= '0' WHEN Opcode = SW OR Opcode = SLB OR Opcode = BEQ OR Opcode = BNE OR
	Opcode = J OR Opcode = JALR OR Opcode = TERMINATE
	ELSE '1' AFTER 80 NS;
		
	ALUSrc1 <= '1' WHEN Opcode = LWS ELSE '0';
	ALUSrc2 <= '0' WHEN Opcode = ZERO OR Opcode = BEQ OR Opcode = BNE ELSE '1';
	
	MemWrite <= '1', '0' AFTER 80 NS WHEN Opcode = SW OR Opcode = SLB ELSE '0';
	MemRead <= '1' WHEN Opcode = LW OR Opcode = LLB OR Opcode = LWS ELSE '0';
	MemToReg <= '1' WHEN Opcode = LLB ELSE '0';
	MemSrc <= '1' WHEN Opcode = SLB ELSE '0';
	
	PCSrc <= "01" WHEN (Opcode = BEQ AND ZeroFlag = '1') OR (Opcode = BNE AND ZeroFlag = '0')
	ELSE "10" WHEN Opcode = J OR Opcode = JAL
	ELSE "11" WHEN Opcode = JALR
	ELSE "00";
		
	ALUOP <= AND_OP WHEN (Opcode = ZERO AND FuncField = "000") OR Opcode = ANDI
	ELSE ADDU_OP WHEN Opcode = ZERO AND FuncField = "010"
	ELSE SUB_OP WHEN (Opcode = ZERO AND FuncField = "011") OR Opcode = BEQ OR Opcode = BNE
	ELSE CAS_OP WHEN Opcode = ZERO AND FuncField = "100"
	ELSE SHR_OP WHEN Opcode = ZERO AND FuncField = "101"
	ELSE SHL_OP WHEN Opcode = SLTI
	ELSE ADD_OP;
	
END ARCHITECTURE MIPS_Control;