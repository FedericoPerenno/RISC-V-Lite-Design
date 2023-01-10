library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY MEM IS
GENERIC (N:INTEGER:=32);
PORT (In_MEM0: IN SIGNED(N-1 DOWNTO 0); --ALU
		In_MEM1: IN SIGNED(N-1 DOWNTO 0); --PC+4
		In_MEM2: IN SIGNED(N-1 DOWNTO 0); --Imm
		In_MEM3: IN SIGNED(N-1 DOWNTO 0); --PC + Imm
		
		WD : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		
		Out_Mux : OUT SIGNED(N-1 DOWNTO 0));
END ENTITY;

ARCHITECTURE behaviour OF MEM IS

	COMPONENT Mux_4to1 IS
	GENERIC (N:INTEGER:=16);
	PORT (in0, in1, in2, in3: IN SIGNED(N-1 DOWNTO 0);
		sel: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		out_mux: OUT SIGNED(N-1 DOWNTO 0)
	);
	END COMPONENT;

BEGIN	
	
--mux needed by the forwarding unit	(instead of the ALU result we might have to use 3 different results)
	M4to1 : Mux_4to1 GENERIC MAP (32) PORT MAP
		(In_MEM0, In_MEM1, In_MEM2, In_MEM3, WD, Out_Mux);
		
END behaviour;