LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.MIPS_Types.ALL;

ENTITY Register_File IS
	PORT (CLK: IN STD_LOGIC;
	ReadAddress_1, ReadAddress_2, WriteAddress: IN REG_ADDRESS;
	WriteData: IN WORD; RegWrite: IN STD_LOGIC;
	ReadData_1, ReadData_2: OUT WORD;
	Registers: OUT REG_FILE);
END ENTITY Register_File;

ARCHITECTURE MIPS_Registers OF Register_File IS
SIGNAL Regs: REG_FILE := ( 	X"0000",	-- R0 --
							X"0260",	-- R1 --
							X"3126",	-- R2 --
							X"1122",	-- R3 --
							X"0142",	-- R4 --
							X"0001",	-- R5 --
							X"A34B",	-- R6 --
							X"E3EF");	-- R7 --
BEGIN
	ReadData_1 <= Regs(conv_integer(ReadAddress_1)) AFTER 5 NS;
	ReadData_2 <= Regs(conv_integer(ReadAddress_2)) AFTER 5 NS;
	Regs(conv_integer(WriteAddress)) <= WriteData WHEN 
			(RegWrite = '1' AND WriteAddress /= "000" AND falling_edge(CLK));
	Registers <= Regs;
	Regs(0) <= X"0000" AFTER 20 NS;
END ARCHITECTURE MIPS_Registers;