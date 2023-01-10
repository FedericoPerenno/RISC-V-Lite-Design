LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instruc_Decode is
GENERIC (N : INTEGER:=32);
PORT (Clk 	: IN STD_LOGIC;
		Rst_n : IN STD_LOGIC;
		
		BEQ : IN STD_LOGIC;
		Imm_shifted : IN SIGNED(N-1 DOWNTO 0);
		
		PC : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		PC_d : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		
		instruct : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		
		BJ_ID_EX : IN STD_LOGIC;
		
		Write_reg : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		RegWrite : IN STD_LOGIC;
		Write_Data : IN SIGNED(N-1 DOWNTO 0);
		
		ID_EX_MemRead 			: IN STD_LOGIC;
		
		ID_EX_Rd : IN STD_LOGIC_VECTOR(4 DOWNTO 0);

		RegWrite_MEM_WB : IN STD_LOGIC;
		
		Imm : OUT SIGNED(N-1 DOWNTO 0);
		
		Read_data1 : OUT SIGNED(N-1 DOWNTO 0);
		Read_data2 : OUT SIGNED(N-1 DOWNTO 0);

		Sel_Mux_PC : OUT STD_LOGIC;
		
		Hazard_detec : OUT STD_LOGIC;
		
		Out_mux : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
		
		Out_sum_BEQ_JMP : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		
		Branch : OUT STD_LOGIC);
		
end entity;

ARCHITECTURE Beh OF Instruc_Decode IS
	
	COMPONENT FF
	port (Clk : IN STD_LOGIC;
		Enable : IN STD_LOGIC;
		
		DIN : IN STD_LOGIC;
		
		RST_n : IN STD_LOGIC;
		
		DOUT : OUT STD_LOGIC);
	end COMPONENT;
	
	COMPONENT Imm_gen
	GENERIC (N:INTEGER:=32);
	PORT (instruct : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);

		Imm: OUT SIGNED(N-1 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT Reg_file
	GENERIC (N : INTEGER := 32);
	port (Clk : IN STD_LOGIC;
		Rst_n 	: IN STD_LOGIC;

		Read_reg1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		Read_reg2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		
		Write_reg : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		Write_data: IN SIGNED (N-1 DOWNTo 0);
		
		RegWrite : IN STD_LOGIC;
		
		Read_data1 : OUT SIGNED(N-1 DOWNTO 0);
		Read_data2 : OUT SIGNED(N-1 DOWNTO 0));
	end COMPONENT;
	
	COMPONENT mux2to1
		GENERIC (N:INTEGER:=16);
		PORT (in0, in1: IN SIGNED(N-1 DOWNTO 0);
				sel: IN STD_LOGIC;
				out_mux: OUT SIGNED(N-1 DOWNTO 0)
				);
	END COMPONENT;
	
	COMPONENT mux2to1_slv IS
	GENERIC (N:INTEGER:=16);
	PORT (in0, in1: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		sel: IN STD_LOGIC;
		out_mux: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT Mux_4to1 IS
	GENERIC (N:INTEGER:=16);
	PORT (in0, in1, in2, in3: IN SIGNED(N-1 DOWNTO 0);
			sel: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			out_mux: OUT SIGNED(N-1 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT CU
	PORT (Clk 				: IN STD_LOGIC;

		opcode 			: IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		
		
		MemRead			: OUT STD_LOGIC;
		MemtoReg			: OUT STD_LOGIC;
		ALUOp				: OUT STD_LOGIC_VECTOR(1 downto 0);
		MemWrite			: OUT STD_LOGIC;
		ALUSrc			: OUT STD_LOGIC;
		RegWrite			: OUT STD_LOGIC;
		JMP            : OUT STD_LOGIC;
		Branch			: OUT STD_LOGIC;
		SelMUX_WD 		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT Hazard_Detec_Unit
	port (Rs1		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			Rs2		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
			Rd_ID_EX	: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		
			ID_EX_MemRead 			: IN STD_LOGIC;
		
			Hazard_Detec 	: OUT STD_LOGIC);
	end COMPONENT;
	
	COMPONENT Forwarding_Unit_ID is
		port (Rs1: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		Rs2: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		
		MEM_WB_Rd : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		
		RegWrite_MEM_WB : IN STD_LOGIC;
		
		ForwardA : OUT STD_LOGIC;
		ForwardB : OUT STD_LOGIC);
	end COMPONENT;
	
	SIGNAL Imm_s 	: SIGNED(N-1 DOWNTO 0);
	
	SIGNAL Read_data1_s : SIGNED(N-1 DOWNTO 0);
	SIGNAL Read_data2_s : SIGNED(N-1 DOWNTO 0);
	
	SIGNAL Out_CU : STD_LOGIC_VECTOR(10 DOWNTO 0);

	SIGNAL Hazard_Detec_s : STD_LOGIC;
	SIGNAL Hazard_Detec_d : STD_LOGIC;
	
	SIGNAL Out_mux_BEQ_JMP : SIGNED(N-1 DOWNTO 0);
	
	SIGNAL Zero 		  : STD_LOGIC;
	SIGNAL Out_sum_BEQ_JMP_s : SIGNED(N-1 DOWNTO 0);

	SIGNAL in0 : SIGNED(N-1 DOWNTO 0);
	
	SIGNAL SelA, SelB : STD_LOGIC;
	SIGNAL OutMuxA, OutMuxB : SIGNED (N-1 DOWNTO 0);
	SIGNAL Sel_Mux_PC_s : STD_LOGIC;
	
	SIGNAL SEL_NOP : STD_LOGIC;
	SIGNAL Out_mux_PC : STD_LOGIC_VECTOR(N-1 DOWNTO 0);

	SIGNAL Out_mux_s : STD_LOGIC_VECTOR(10 DOWNTO 0);
BEGIN 

	IG : Imm_gen GENERIC MAP (N) PORT MAP
		(instruct, Imm_s);
		
	FSM : CU PORT MAP
		(Clk, instruct(6 DOWNTO 0), Out_CU(10), Out_CU(9), 
		 Out_CU(8 DOWNTO 7), Out_CU(6), Out_CU(5), Out_CU(4), 
		 Out_CU(3), Out_CU(2), Out_CU(1 DOWNTO 0));
		
	HDU : Hazard_Detec_Unit PORT MAP
		(instruct(19 DOWNTO 15), instruct(24 DOWNTO 20), ID_EX_Rd, ID_EX_MemRead, Hazard_Detec_s);
	
	Imm <= Imm_s;
	
	RF : Reg_file GENERIC MAP (N) PORT MAP
		(Clk, Rst_n, instruct(19 DOWNTO 15), instruct(24 DOWNTO 20), 
		 Write_reg, Write_Data, RegWrite, Read_data1_s, Read_data2_s);
	
	FU : Forwarding_Unit_ID PORT MAP
		(instruct(19 DOWNTO 15), instruct(24 DOWNTO 20), Write_reg, RegWrite_MEM_WB, SelA, SelB);
		 
	MX_A : mux2to1 GENERIC MAP(32) PORT MAP	
		(Read_data1_s, Write_Data, SelA, OutMuxA);
		
	MX_B : mux2to1 GENERIC MAP(32) PORT MAP	
		(Read_data2_s, Write_Data, SelB, OutMuxB);
		
	
		 
	Hazard_Detec <= Hazard_Detec_s;
	
	SEL_NOP <= BJ_ID_EX OR Hazard_Detec_s OR BEQ;
	M_haz : mux2to1_slv GENERIC MAP (11) PORT MAP
		(Out_CU, "00000000000", SEL_NOP, Out_mux_s); 
	
	M_BEQ_JAL : mux2to1 GENERIC MAP (N) PORT MAP
		(Imm_shifted, Imm_s, Out_CU(3), Out_mux_BEQ_JMP);
		
	M_PC : mux2to1_slv GENERIC MAP (N) PORT MAP
		(PC_d, Pc, Out_CU(3), Out_mux_PC);
		
	Sel_Mux_PC_s <= BEQ OR Out_mux_s(3); 
	
	Sel_Mux_PC <= Sel_Mux_PC_s;
	Read_data1 <= OutMuxA;
	Read_data2 <= OutMuxB;
	
	Out_sum_BEQ_JMP_s <= Out_mux_BEQ_JMP + signed(Out_mux_PC); --> delayed PC
	Out_sum_BEQ_JMP <= std_logic_vector(Out_sum_BEQ_JMP_s);
	
	Branch <= Out_mux_s(2);

	Out_mux <= Out_mux_s;

END Beh;