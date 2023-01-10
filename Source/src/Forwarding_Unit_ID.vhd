LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Forwarding_Unit_ID is
port (Rs1: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		Rs2: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		
		MEM_WB_Rd : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		
		RegWrite_MEM_WB : IN STD_LOGIC;
		
		ForwardA : OUT STD_LOGIC;
		ForwardB : OUT STD_LOGIC);
end Forwarding_Unit_ID;

architecture Beh of Forwarding_Unit_ID is

	SIGNAL Rs1_MEM_WB : STD_LOGIC;
	SIGNAL Rs2_MEM_WB : STD_LOGIC;
	SIGNAL ForwardA_s : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL ForwardB_s : STD_LOGIC_VECTOR(1 DOWNTO 0);

	
begin
	
	Rs1_MEM_WB <= '1' when (Rs1 = MEM_WB_Rd) else '0';
	Rs2_MEM_WB <= '1' when (Rs2 = MEM_WB_Rd) else '0';
	
	ForwardA <= '1' when (RegWrite_MEM_WB AND Rs1_MEM_WB) = '1' else '0';
	 
	ForwardB <= '1' when (RegWrite_MEM_WB AND Rs2_MEM_WB) = '1' else '0'; 

	
end Beh;
