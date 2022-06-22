LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.MIPS_Types.ALL;

ENTITY Data_Memory IS
	PORT (CLK: IN STD_LOGIC;
	Address: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
	DataIn: IN WORD; MemRead, MemWrite: IN STD_LOGIC;
	DataOut: OUT WORD;
	Data: INOUT MEM_Data := (X"AB", X"12", X"34", X"CA", X"FF", X"51", X"1A", X"B5", X"C3", X"EF", X"40", OTHERS => X"00"));
END ENTITY Data_Memory;

ARCHITECTURE Data_Mem OF Data_Memory IS
SIGNAL DataWord: WORD;
BEGIN
	DataOut <= Data(conv_integer(Address) + 1) & Data(conv_integer(Address)) AFTER 10 NS WHEN MemRead = '1';
	Data(conv_integer(Address) + 1) <= DataIn(15 DOWNTO 8) WHEN MemWrite = '1' AND falling_edge(CLK);
	Data(conv_integer(Address)) <= DataIn(7 DOWNTO 0) WHEN MemWrite = '1' AND falling_edge(CLK);
	
END ARCHITECTURE Data_Mem;