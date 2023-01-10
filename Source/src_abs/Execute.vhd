LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Execute is
GENERIC (N : INTEGER:=32);
PORT (Branch_in : IN STD_LOGIC;
		
		Rs1_Data : IN SIGNED(N-1 DOWNTO 0);
		Rs2_Data : IN SIGNED(N-1 DOWNTO 0);
		Imm	 	: IN SIGNED(N-1 DOWNTO 0);
		Rs1_Add : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		Rs2_Add : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		EX_MEM_Rd : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		MEM_WB_Rd : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		RegWrite_EX_MEM : IN STD_LOGIC;
		RegWrite_MEM_WB : IN STD_LOGIC;
		ALUSrc			: IN STD_LOGIC;
		In_01 : IN SIGNED(N-1 DOWNTO 0); --Out DataMemory MEM_WB
		In_10 : IN SIGNED(N-1 DOWNTO 0); --Out ALU EX_MEM
		ALUOp 	  : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		funct3 	  : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		PC: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0); --used to compute PC + immediate

		PC_Imm : OUT SIGNED(N-1 DOWNTO 0);
		Out_ALU : OUT SIGNED(N-1 DOWNTO 0);
		Memory_Data : OUT SIGNED(N-1 DOWNTO 0);
		Branch_out : OUT STD_LOGIC;
		Imm_shifted : OUT SIGNED(N-1 DOWNTO 0));
end entity;

ARCHITECTURE Beh OF Execute IS

	COMPONENT Mux_4to1
	GENERIC (N:INTEGER:=16);
	PORT (in0, in1, in2, in3: IN SIGNED(N-1 DOWNTO 0);
		sel: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		out_mux: OUT SIGNED(N-1 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT mux2to1
	GENERIC (N:INTEGER:=16);
	PORT (in0, in1: IN SIGNED(N-1 DOWNTO 0);
			sel: IN STD_LOGIC;
			out_mux: OUT SIGNED(N-1 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT Forwarding_Unit
	port (Rs1: IN STD_LOGIC_VECTOR (4 DOWNTo 0);
			Rs2: IN STD_LOGIC_VECTOR (4 DOWNTo 0);
		
			EX_MEM_Rd : IN STD_LOGIC_VECTOR (4 DOWNTo 0);
		MEM_WB_Rd : IN STD_LOGIC_VECTOR (4 DOWNTo 0);
		
		RegWrite_EX_MEM : IN STD_LOGIC;
		RegWrite_MEM_WB : IN STD_LOGIC;
		
		ForwardA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		ForwardB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
	end COMPONENT;
	
	COMPONENT ALU_Control
	port (ALUOp 	  : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
		funct3 	  : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		
		Out_ALU_control : OUT STD_LOGIC_VECTOR (2 DOWNTO 0));
	end COMPONENT;
	
	COMPONENT ALU
	GENERIC (N : INTEGER:=32);
	port (In0 	  : IN SIGNED (N-1 DOWNTo 0);
		In1 	  : IN SIGNED (N-1 DOWNTo 0);
		ALU_c   : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		Out_ALU : OUT SIGNED (N-1 DOWNTO 0));
	end COMPONENT;
	
	SIGNAL Out_mux_B : SIGNED (N-1 DOWNTO 0);
	
	SIGNAL Sel_Mux_A : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL Sel_Mux_B : STD_LOGIC_VECTOR(1 DOWNTO 0);
	
	SIGNAL In_ALU_A : SIGNED(N-1 DOWNTO 0);
	SIGNAL In_ALU_B : SIGNED(N-1 DOWNTO 0);
	
	SIGNAL Out_ALU_control : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL Zero : STD_LOGIC;
	
BEGIN
	
	M_4to1_A : Mux_4to1 GENERIC MAP (32) PORT MAP
		(Rs1_Data, In_01, In_10, to_signed(0, 32), Sel_Mux_A, In_ALU_A);
		
	M_4to1_B : Mux_4to1 GENERIC MAP (32) PORT MAP
		(Rs2_Data, In_01, In_10, to_signed(0, 32), Sel_Mux_B, Out_mux_B);
	
	M_2to1 : mux2to1 GENERIC MAP (32) PORT MAP
		(Out_mux_B, Imm, ALUSrc, In_ALU_B);
		
	FU : Forwarding_Unit PORT MAP
		(Rs1_Add, Rs2_Add, EX_MEM_Rd, MEM_WB_Rd, RegWrite_EX_MEM, RegWrite_MEM_WB,
		 Sel_Mux_A, Sel_Mux_B);
		 
	AC : ALU_Control PORT MAP
		(ALUOp, funct3, Out_ALU_control);
	
	A : ALU GENERIC MAP (32) PORT MAP
		(In_ALU_A, In_ALU_B, Out_ALU_control, Out_ALU);
		
	--M_4to1_B output which goes to the data memory
	Memory_Data <= Out_mux_B;
	
	-- PC + immediate
	PC_Imm <= signed(PC) + Imm;
	
	Zero <= '1' when (In_ALU_A = Out_mux_B) else '0';
	
	Branch_out <= Zero AND Branch_in;
	
	Imm_shifted <= Imm(N-2 DOWNTO 0) & '0';

END Beh;