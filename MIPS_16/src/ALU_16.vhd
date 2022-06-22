LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.all;
USE work.MIPS_Types.ALL;

ENTITY ALU IS
	GENERIC (n: POSITIVE := 16);
	PORT (	A, B: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	Operation: IN ALU_OP;
	C: OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0); ZeroFlag: OUT STD_LOGIC);
END ENTITY ALU;

ARCHITECTURE ALU_MIPS OF ALU IS
BEGIN
	WITH Operation SELECT C <=
		A and B WHEN And_Op,
		STD_LOGIC_VECTOR(to_signed(conv_integer(A) + conv_integer(B), C'LENGTH)) WHEN Add_Op,
		STD_LOGIC_VECTOR(to_unsigned(conv_integer(A) + conv_integer(B), C'LENGTH)) WHEN Addu_Op,
		A - B WHEN Sub_Op,
		MAX(A,B) WHEN Cas_Op,
		to_stdlogicvector(to_bitvector(A) SLL to_integer(unsigned(B))) WHEN ShL_Op,
		to_stdlogicvector(to_bitvector(A) SRL to_integer(unsigned(B))) WHEN ShR_Op,
		A WHEN UNDEFINED;
	
	ZeroFlag <= '1' WHEN A = B ELSE '0';
END ARCHITECTURE ALU_MIPS;