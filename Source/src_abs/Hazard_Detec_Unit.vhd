LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Hazard_Detec_Unit is
port (Rs1		: IN STD_LOGIC_VECTOR (4 DOWNTo 0);
		Rs2		: IN STD_LOGIC_VECTOR (4 DOWNTo 0);
		Rd_ID_EX	: IN STD_LOGIC_VECTOR (4 DOWNTo 0);
		ID_EX_MemRead 			: IN STD_LOGIC;
		
		Hazard_Detec 	: OUT STD_LOGIC);
end entity;

architecture Beh of Hazard_Detec_Unit is
	
	SIGNAL Rs1_ID_EX_s : STD_LOGIC_VECTOR (4 DOWNTo 0);
	SIGNAL Rs2_ID_EX_s :STD_LOGIC_VECTOR (4 DOWNTo 0);
	SIGNAL Rs1_ID_EX : STD_LOGIC;
	SIGNAL Rs2_ID_EX : STD_LOGIC;
	SIGNAL OR_RS1_RS2 : STD_LOGIC;
	SIGNAL All_zeros : STD_LOGIC;
	
begin
	
	Rs1_ID_EX <= '1' when ((Rs1 = Rd_ID_EX)) else '0'; 
	Rs2_ID_EX <= '1' when ((Rs2 = Rd_ID_EX)) else '0'; 
	
	OR_RS1_RS2 <= (Rs1_ID_EX OR Rs2_ID_EX);
	
	Hazard_Detec <= (ID_EX_MemRead AND OR_RS1_RS2);

	
	
end Beh;