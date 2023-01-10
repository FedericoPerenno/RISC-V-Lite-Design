LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Forwarding_Unit is
port (Rs1: IN STD_LOGIC_VECTOR (4 DOWNTo 0);
		Rs2: IN STD_LOGIC_VECTOR (4 DOWNTo 0);
		
		EX_MEM_Rd : IN STD_LOGIC_VECTOR (4 DOWNTo 0);
		MEM_WB_Rd : IN STD_LOGIC_VECTOR (4 DOWNTo 0);
		
		RegWrite_EX_MEM : IN STD_LOGIC;
		RegWrite_MEM_WB : IN STD_LOGIC;
		
		ForwardA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		ForwardB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
end entity;

architecture Beh of Forwarding_Unit is

	SIGNAL Rs1_EX_MEM : STD_LOGIC;
	SIGNAL Rs2_EX_MEM : STD_LOGIC;
	SIGNAL Rs1_MEM_WB : STD_LOGIC;
	SIGNAL Rs2_MEM_WB : STD_LOGIC;
	
begin

	Rs1_EX_MEM <= '1' when (Rs1 = EX_MEM_Rd) else '0';
	Rs2_EX_MEM <= '1' when (Rs2 = EX_MEM_Rd) else '0';
	Rs1_MEM_WB <= '1' when (Rs1 = MEM_WB_Rd) else '0';
	Rs2_MEM_WB <= '1' when (Rs2 = MEM_WB_Rd) else '0';
	

	ForwardA <= "10" when (RegWrite_EX_MEM AND Rs1_EX_MEM) = '1' else
				   "01" when (RegWrite_MEM_WB AND Rs1_MEM_WB) = '1' else "00";
	 
	ForwardB <= "10" when (RegWrite_EX_MEM AND Rs2_EX_MEM) = '1' else
				   "01" when (RegWrite_MEM_WB AND Rs2_MEM_WB) = '1' else "00";

	
end Beh;
