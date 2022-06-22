LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.MIPS_Types.ALL;

ENTITY Instruction_Memory IS
	PORT (Address: IN INTEGER;
	Instruction: OUT WORD);
END ENTITY Instruction_Memory;

ARCHITECTURE Inst_Mem OF Instruction_Memory IS
	SIGNAL Instructions: MEM_INST;
BEGIN
	Instructions(0) <= X"070A";	-- ADD	R1, R3, R4
	Instructions(1) <= X"4B83";	-- LW	R6, 3(R5)
	Instructions(2) <= X"4A89";	-- LW 	R2, 9(R5)
	Instructions(3) <= X"058B";	-- SUB	R1, R2, R6
	Instructions(4) <= X"FFFF"; -- TERMINATE
	Instruction <= Instructions(Address);
END ARCHITECTURE Inst_Mem;