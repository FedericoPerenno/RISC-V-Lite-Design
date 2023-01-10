library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY WB IS
GENERIC (N:INTEGER:=32);
PORT (ALU_Data	: IN SIGNED(N-1 DOWNTO 0); --ALU
		DataMem  : IN SIGNED(N-1 DOWNTO 0); --DataMem
		
		MemtoReg : IN STD_LOGIC;

		In_WB1: IN SIGNED(N-1 DOWNTO 0); --PC+4
		In_WB2: IN SIGNED(N-1 DOWNTO 0); --Imm
		In_WB3: IN SIGNED(N-1 DOWNTO 0); --PC+Imm

		WD : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		
		Out_Mux : OUT SIGNED(N-1 DOWNTO 0));
END ENTITY;

ARCHITECTURE behaviour OF WB IS

	COMPONENT Mux_4to1 IS
	GENERIC (N:INTEGER:=16);
	PORT (in0, in1, in2, in3: IN SIGNED(N-1 DOWNTO 0);
		sel: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		out_mux: OUT SIGNED(N-1 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT mux2to1 IS
	GENERIC (N:INTEGER:=16);
	PORT (in0, in1: IN SIGNED(N-1 DOWNTO 0);
		sel: IN STD_LOGIC;
		out_mux: OUT SIGNED(N-1 DOWNTO 0)
	);
	END COMPONENT;
	
	SIGNAL Out_Mux2to1 : SIGNED(N-1 DOWNTO 0);

BEGIN
		
	M2to1 : mux2to1 GENERIC MAP (32) PORT MAP
		(ALU_Data, DataMem, MemtoReg, Out_Mux2to1);
		
	M4to1 : Mux_4to1 GENERIC MAP (32) PORT MAP
		(Out_Mux2to1, In_WB1, In_WB2, In_WB3, WD, Out_Mux);
		
	
END behaviour;