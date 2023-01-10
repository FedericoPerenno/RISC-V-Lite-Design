LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
GENERIC (N : INTEGER:=32);
port (In0 	  : IN SIGNED (N-1 DOWNTo 0);
		In1 	  : IN SIGNED (N-1 DOWNTo 0);
		ALU_c   : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		Out_ALU : OUT SIGNED (N-1 DOWNTO 0));
end entity;

architecture Beh of ALU is

	COMPONENT Shift
	GENERIC (N : INTEGER:=32);
	port (Shift_In  : IN SIGNED (N-1 DOWNTo 0);
			Shift_Val : IN INTEGER;
		
			Shift_Out : OUT SIGNED (N-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT mux2to1 IS
	GENERIC (N:INTEGER:=16);
	PORT (in0, in1: IN SIGNED(N-1 DOWNTO 0);
		sel: IN STD_LOGIC;
		out_mux: OUT SIGNED(N-1 DOWNTO 0)
	);
	END COMPONENT;
	
	SIGNAL Shamt : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAl Shift_res : SIGNED(N-1 DOWNTO 0);
	
	SIGNAL XOR_res : SIGNED(N-1 DOWNTO 0);
	SIGNAL AND_res : SIGNED(N-1 DOWNTO 0);

	SIGNAL ADD_res : SIGNED(N-1 DOWNTO 0);
	
	SIGNAL Sub_temp : SIGNED(N-1 DOWNTO 0);
	SIGNAL Cmp_res : SIGNED(N-1 DOWNTO 0);
	SIGNAL Shamt_int : INTEGER;
	

begin
	
	--Shift (SRAI)
	Shamt <= std_logic_vector(In1(4 DOWNTO 0));
	
	Shamt_int <= to_integer(unsigned(Shamt));
	S0 : Shift GENERIC MAP (N) PORT MAP
		(In0, Shamt_int, Shift_res);
	
	-- Logic operations (XOR, ANDI)
	XOR_res <= In0 XOR In1;
	AND_res <= In0 AND In1;
	
	-- Addition (ADD, ADDI, SW, LW)	
	ADD_res <= In0 + In1;
	
	-- Comparison by subtraction (SLT)
	Sub_temp <= In0 - In1; --negative number if Rs1 < Rs2
		
	Mux_cmp : mux2to1 GENERIC MAP(N) PORT MAP
		(to_signed(0, N), to_signed(1, N), Sub_temp(N-1), Cmp_res);
		
	--> (BEQ, JAL, LUI, APUIC) don't require ALU operations
	
	Out_ALU <= ADD_res when (ALU_c = "000") else   -- ADD,ADDI,SW,LW
				  AND_res when (ALU_c = "001") else   -- ANDI
				  XOR_res when (Alu_c = "010") else   -- XOR
				  Shift_res when (Alu_c = "011") else -- SRAI
				  Cmp_res;                            -- SLT
	
end Beh;

