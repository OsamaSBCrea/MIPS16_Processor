LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.MIPS_Types.ALL;

ENTITY Mux4_1 IS
	GENERIC (size: POSITIVE := 16);
	PORT (I0, I1, I2, I3: IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);
	Selection: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
	Output: OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0));
END ENTITY;

ARCHITECTURE GenericMux OF Mux4_1 IS
BEGIN
	Output <= I0 WHEN Selection = "00"
	ELSE I1 WHEN Selection = "01"
	ELSE I2 WHEN Selection = "10"
	ELSE I3;
END ARCHITECTURE;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE work.MIPS_Types.ALL;

ENTITY Mux2_1 IS
	GENERIC (size: POSITIVE := 16);
	PORT (I0, I1: IN STD_LOGIC_VECTOR (size-1 DOWNTO 0);
	Selection: IN STD_LOGIC;
	Output: OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0));
END ENTITY;

ARCHITECTURE GenericMux OF Mux2_1 IS
BEGIN
	Output <= I0 WHEN Selection = '0' ELSE I1;
END ARCHITECTURE;