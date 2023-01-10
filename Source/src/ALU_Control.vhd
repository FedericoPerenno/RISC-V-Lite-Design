LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_Control is
port (ALUOp 	  : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		funct3 	  : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		
		Out_ALU_control : OUT STD_LOGIC_VECTOR (2 DOWNTO 0));
end entity;

architecture Beh of ALU_Control is
begin

	Out_ALU_control(2) <= NOT(ALUOp(1)) AND NOT(ALUOp(0)) AND NOT(funct3(2)) AND funct3(1) AND NOT(funct3(0));
	
	Out_ALU_control(1) <= (NOT(ALUOp(1)) AND NOT(ALUOp(0)) AND funct3(2) AND NOT(funct3(1)) AND NOT(funct3(0))) OR
								 (NOT(ALUOp(1)) AND ALUOp(0) AND funct3(2) AND NOT(funct3(1)) AND funct3(0));
	
	Out_ALU_control(0) <= NOT(ALUOp(1)) AND ALUOp(0) AND funct3(2) AND funct3(0);
								 
end Beh;
