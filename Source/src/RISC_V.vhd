LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RISC_V is
PORT (Clk 	: IN STD_LOGIC;
		Rst_n : IN STD_LOGIC;
		Instruc 	: IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Uscita Instruct_Mem
		Data 		: IN SIGNED(31 DOWNTO 0); -- Uscita Data_Mem
		
		AddressDM 	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		DataDM 		: OUT SIGNED(31 DOWNTO 0);
		AddressIM   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		Mem_Write : OUT STD_LOGIC;
		Mem_Read : OUT STD_LOGIC
		);
end entity;

ARCHITECTURE Beh OF RISC_V IS

	COMPONENT Instruc_Fetch is
	GENERIC (N : INTEGER:=32);
	PORT (Clk 	: IN STD_LOGIC;
		Rst_n : IN STD_LOGIC;
		
		PC_Write : IN STD_LOGIC;
		Sel_Pc_in : IN STD_LOGIC;
		
		PC_BEQ_JAL : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		
		PC_Out : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		PC_4 : OUT SIGNED(N-1 DOWNTO 0));
		
	end COMPONENT;

	COMPONENT Instruc_Decode is
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
		
	end COMPONENT;
	
	COMPONENT Execute is
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
		
	end COMPONENT;
	
	COMPONENT MEM IS
	GENERIC (N:INTEGER:=32);
	PORT (In_MEM0: IN SIGNED(N-1 DOWNTO 0); --ALU
		In_MEM1: IN SIGNED(N-1 DOWNTO 0); --PC+4
		In_MEM2: IN SIGNED(N-1 DOWNTO 0); --Imm
		In_MEM3: IN SIGNED(N-1 DOWNTO 0); --PC + Imm
		
		WD : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		
		Out_Mux : OUT SIGNED(N-1 DOWNTO 0));
	END COMPONENT;

	COMPONENT WB IS
	GENERIC (N:INTEGER:=32);
	PORT (ALU_Data	: IN SIGNED(N-1 DOWNTO 0); --ALU
		DataMem  : IN SIGNED(N-1 DOWNTO 0); --DataMem
		
		MemtoReg : IN STD_LOGIC;

		In_WB1: IN SIGNED(N-1 DOWNTO 0); --PC+4
		In_WB2: IN SIGNED(N-1 DOWNTO 0); --Imm
		In_WB3: IN SIGNED(N-1 DOWNTO 0); --PC+Imm

		WD : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		
		Out_Mux : OUT SIGNED(N-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT Reg
	GENERIC (N : INTEGER := 8);
	port (Clk : IN STD_LOGIC;
		Enable : IN STD_LOGIC;
		
		DIN : IN SIGNED(N-1 DOWNTO 0);
		
		RST_n : IN STD_LOGIC;
		
		DOUT : OUT SIGNED(N-1 DOWNTO 0));
	end COMPONENT;
	
	COMPONENT Reg_slv is
	GENERIC (N : INTEGER := 8);
	port (Clk : IN STD_LOGIC;
		Enable : IN STD_LOGIC;
		
		DIN : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		
		RST_n : IN STD_LOGIC;
		
		DOUT : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
	end COMPONENT;
	
	COMPONENT FF
	port (Clk : IN STD_LOGIC;
		Enable : IN STD_LOGIC;
		
		DIN : IN STD_LOGIC;
		
		RST_n : IN STD_LOGIC;
		
		DOUT : OUT STD_LOGIC);
	end COMPONENT;
	
	COMPONENT mux2to1
	GENERIC (N:INTEGER:=16);
	PORT (in0, in1: IN SIGNED(N-1 DOWNTO 0);
		sel: IN STD_LOGIC;
		out_mux: OUT SIGNED(N-1 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT mux2to1_slv
	GENERIC (N:INTEGER:=16);
	PORT (in0, in1: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		sel: IN STD_LOGIC;
		out_mux: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT mux2to1_sl
	PORT (in0, in1: IN STD_LOGIC;
		sel: IN STD_LOGIC;
		out_mux: OUT STD_LOGIC
	);
	END COMPONENT;

	SIGNAL PC_Write : STD_LOGIC;
	SIGNAL Sel_Pc_in : STD_LOGIC;
	SIGNAL PC_BEQ_JAL : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL PC_4_IF : SIGNED(31 DOWNTO 0);
	SIGNAL PC_4_ID : SIGNED(31 DOWNTO 0);
	SIGNAL PC_4_ID0 : SIGNED(31 DOWNTO 0);
	SIGNAL PC_Out_IF : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL PC_Out_ID : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL PC_Out_ID0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	SIGNAL IF_ID_Write : STD_LOGIC;
	SIGNAL instruc_ID : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL instruc_ID0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	SIGNAL ID_EX_MemRead : STD_LOGIC;
	SIGNAL Branch_Jump_ID_EX 	: STD_LOGIC;
	
	SIGNAL Imm : SIGNED(31 DOWNTO 0);
		
	SIGNAL Read_data1 : SIGNED(31 DOWNTO 0);
	SIGNAL Read_data2 : SIGNED(31 DOWNTO 0);
	SIGNAL Zero 		  : STD_LOGIC;

	SIGNAL Out_mux : STD_LOGIC_VECTOR(10 DOWNTO 0);
		
	SIGNAL Out_sum_BEQ_JMP : SIGNED(31 DOWNTO 0);
	
	SIGNAL Hazard_Detec : STD_LOGIC;
	SIGNAL Hazard_Detec_d : STD_LOGIC;
	
	SIGNAL Branch_ID : STD_LOGIC;
	SIGNAL Branch_ID_EX : STD_LOGIC;
	SIGNAL Branch_EX : STD_LOGIC;
	SIGNAL Branch_EX_d : STD_LOGIC;
	
	SIGNAL Imm_shifted : SIGNED(31 DOWNTO 0);
	
	SIGNAL AddRd_ID_EX_s : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL AddRs1_ID_EX_s : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL AddRs2_ID_EX_s : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL BJ_ID_EX_s : STD_LOGIC;
	SIGNAL Imm_ID_EX_s : SIGNED(31 DOWNTO 0);
	SIGNAL DataRs1_ID_EX_s : SIGNED(31 DOWNTO 0);
	SIGNAL func3_ID_EX_s : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL MEM_EX_s : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL EX_EX_s : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL WB_EX_s : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL MEM_WB_EX_s : STD_LOGIC_VECTOR(1 DOWNTO 0);
	
	SIGNAL PC_Out_EX : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL PC_4_EX : SIGNED(31 DOWNTO 0);
	
	SIGNAL AddRd_EX_s : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL AddRs1_EX_s : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL AddRs2_EX_s : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL Imm_EX_s : SIGNED(31 DOWNTO 0);
	SIGNAL DataRs1_EX_s : SIGNED(31 DOWNTO 0);
	SIGNAL DataRs2_EX_s : SIGNED(31 DOWNTO 0);
	SIGNAL PC_Imm_EX_s : SIGNED(31 DOWNTO 0);
	SIGNAL Memory_Data_EX_s : SIGNED(31 DOWNTO 0); --Memory data pipe input
	SIGNAL ALU_res_EX_s : SIGNED(31 DOWNTO 0); --Alu result pipe input
	SIGNAL func3_EX_s : STD_LOGIC_VECTOR(2 DOWNTO 0);
	
	SIGNAL MEM_MEM_s : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL WB_MEM_s : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL MEM_WB_MEM_s : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL PC_4_MEM : SIGNED(31 DOWNTO 0);
	SIGNAL AddRd_MEM_s : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL Imm_MEM_s : SIGNED(31 DOWNTO 0);
	SIGNAL PC_Imm_MEM_s : SIGNED(31 DOWNTO 0);
	SIGNAL Memory_Data_MEM_s : SIGNED(31 DOWNTO 0); --Memory data pipe output
	SIGNAL ALU_res_MEM_s : SIGNED(31 DOWNTO 0); --Alu result pipe output
	SIGNAL Out_Mux_MEM_s : SIGNED(31 DOWNTO 0); -- MEM mux output
	
	SIGNAL AddRd_WB_s : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL WB_WB_s : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL MEM_WB_WB_s : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL PC_4_WB : SIGNED(31 DOWNTO 0);
	SIGNAL Imm_WB_s : SIGNED(31 DOWNTO 0);
	SIGNAL PC_Imm_WB_s : SIGNED(31 DOWNTO 0);
	SIGNAL Memory_Data_WB_s : SIGNED(31 DOWNTO 0); --Memory data pipe output
	SIGNAL ALU_res_WB_s : SIGNED(31 DOWNTO 0); --Alu result pipe output
	SIGNAL Out_Mux_WB_s : SIGNED(31 DOWNTO 0); -- WB mux output

	SIGNAL WB_ID_EX_in, MEM_ID_EX_in: STD_LOGIC_VECTOR(1 DOWNTO 0);
 	SIGNAL EX_ID_EX_in : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Rst_n_sync : STD_LOGIC;
	SIGNAL Sel_NOP : STD_LOGIC;
	
	SIGNAL Mem_Read_d : STD_LOGIC;
	constant tco : time := 1 ns;
BEGIN

	-- IF - Instruction Fetch
	PC_Write <= NOT(Hazard_Detec);
	
	InF : Instruc_Fetch GENERIC MAP(32) PORT MAP
		(Clk, Rst_n, PC_Write, Sel_Pc_in, PC_BEQ_JAL, PC_Out_IF, PC_4_IF);
		
	AddressIM <= PC_Out_IF;
	
	-- IF/ID - First Pipeline stage
	
	IF_ID_Write <= NOT(Hazard_Detec);
	
	PC_IF_ID0 : Reg_slv GENERIC MAP (32) PORT MAP
		(Clk, IF_ID_Write, PC_Out_IF, Rst_n, PC_Out_ID);
		
	PC_4_IF_ID0 : Reg GENERIC MAP (32) PORT MAP
		(Clk, IF_ID_Write, PC_4_IF, Rst_n, PC_4_ID);
	
	Instruc_IF_ID : Reg_slv GENERIC MAP (32) PORT MAP
		(Clk, IF_ID_Write, Instruc, Rst_n, instruc_ID);
	
	-- ID - Istruction Decode
	
	Mem_Read_d <= MEM_EX_s(1) after tco;
	InD : Instruc_Decode GENERIC MAP (32) PORT MAP
		(Clk, Rst_n, Branch_EX, Imm_shifted, PC_Out_ID, PC_Out_EX, instruc_ID, Branch_Jump_ID_EX,
		AddRd_WB_s, WB_WB_s(0), Out_Mux_WB_s, Mem_Read_d, AddRd_EX_s, WB_WB_s(0), 
		Imm, Read_data1, Read_data2, Sel_Pc_in, Hazard_Detec, Out_mux, PC_BEQ_JAL, Branch_ID);
		
	-- ID/EX - Second Pipeline stage
	
	MEM_ID_EX_in <= Out_mux(10) & Out_mux(6);
	MEM_ID_EX : Reg_slv GENERIC MAP (2) PORT MAP
		(Clk, '1', MEM_ID_EX_in, Rst_n, MEM_EX_s); -- CU signals for MEM
	
	WB_ID_EX_in <= Out_mux(9) & Out_mux(4);
	WB_ID_EX : Reg_slv GENERIC MAP (2) PORT MAP -- CU signals for WB
		(Clk, '1', WB_ID_EX_in, Rst_n, WB_EX_s);
	
	EX_ID_EX_in <= Out_mux(8 DOWNTO 7) & Out_mux(5) & Out_mux(2);
	EX_ID_EX : Reg_slv GENERIC MAP (4) PORT MAP -- CU signals for EX
		(Clk, '1', EX_ID_EX_in, Rst_n, EX_EX_s);
	
	MEM_WB_ID_EX : Reg_slv GENERIC MAP (2) PORT MAP -- CU signals for both MEM and WB
		(Clk, '1', Out_mux(1 DOWNTO 0), Rst_n, MEM_WB_EX_s);
	
	PC_ID_EX : Reg_slv GENERIC MAP (32) PORT MAP -- PC propagation
		(Clk, '1', PC_Out_ID, Rst_n, PC_Out_EX);
		
	PC_4_ID_EX : Reg GENERIC MAP (32) PORT MAP -- PC + 4 propagation
		(Clk, '1', PC_4_ID, Rst_n, PC_4_EX);
		
	BJ_ID_EX : FF PORT MAP -- Branch/Jump propagation
		(Clk, '1', Sel_Pc_in, Rst_n, Branch_Jump_ID_EX);
	
	DataRs1_ID_EX : Reg GENERIC MAP (32) PORT MAP -- Rs1 data
		(Clk, '1', Read_data1, Rst_n, DataRs1_EX_s);
		
	DataRs2_ID_EX : Reg GENERIC MAP (32) PORT MAP -- Rs2 data
		(Clk, '1', Read_data2, Rst_n, DataRs2_EX_s);
	
	Imm_ID_EX : Reg GENERIC MAP (32) PORT MAP -- Immediate
		(Clk, '1', Imm, Rst_n, Imm_EX_s);
	
	AddRs1_ID_EX : Reg_slv GENERIC MAP (5) PORT MAP -- Rs1 address
		(Clk, '1', instruc_ID(19 DOWNTO 15), Rst_n, AddRs1_EX_s);
		
	AddRs2_ID_EX : Reg_slv GENERIC MAP (5) PORT MAP -- Rs2 address
		(Clk, '1', instruc_ID(24 DOWNTO 20), Rst_n, AddRs2_EX_s);
	
	AddRd_ID_EX : Reg_slv GENERIC MAP (5) PORT MAP -- Rd address
		(Clk, '1', instruc_ID(11 DOWNTO 7), Rst_n, AddRd_EX_s);
		
	func3_ID_EX : Reg_slv GENERIC MAP (3) PORT MAP -- func3 propagation
		(Clk, '1',instruc_ID(14 DOWNTO 12), Rst_n, func3_EX_s);
		
	-- EX - Execute
	
	EX : Execute GENERIC MAP(32) PORT MAP
		(EX_EX_s(0), DataRs1_EX_s, DataRs2_EX_s, Imm_EX_s, AddRs1_EX_s, AddRs2_EX_s,
		AddRd_MEM_s, AddRd_WB_s, WB_MEM_s(0), WB_WB_s(0), EX_EX_s(1),
		Out_Mux_WB_s, Out_Mux_MEM_s, EX_EX_s(3 DOWNTO 2), func3_EX_s, PC_Out_EX,
		PC_Imm_EX_s, ALU_res_EX_s, Memory_Data_EX_s, Branch_EX, Imm_shifted);
		
	-- EX/MEM - Third Pipeline stage
	
	WB_EX_MEM : Reg_slv GENERIC MAP (2) PORT MAP -- CU signals for WB
		(Clk, '1', WB_EX_s, Rst_n, WB_MEM_s);
		
	MEM_EX_MEM : Reg_slv GENERIC MAP (2) PORT MAP
		(Clk, '1', MEM_EX_s, Rst_n, MEM_MEM_s); -- CU signals for MEM
		
	MEM_WB_EX_MEM : Reg_slv GENERIC MAP (2) PORT MAP -- CU signals for both MEM and WB
		(Clk, '1', MEM_WB_EX_s, Rst_n, MEM_WB_MEM_s);
	
	PC_4_EX_MEM : Reg GENERIC MAP (32) PORT MAP -- PC + 4 propagation
		(Clk, '1', PC_4_EX, Rst_n, PC_4_MEM);
	
	PC_Imm_EX_MEM : Reg GENERIC MAP (32) PORT MAP -- PC + immediate propagation
		(Clk, '1', PC_Imm_EX_s, Rst_n, PC_Imm_MEM_s);
	
	Imm_EX_MEM : Reg GENERIC MAP (32) PORT MAP -- Immediate
		(Clk, '1', Imm_EX_s, Rst_n, Imm_MEM_s);
	
	AddRd_EX_MEM : Reg_slv GENERIC MAP (5) PORT MAP -- Rd address
		(Clk, '1', AddRd_EX_s, Rst_n, AddRd_MEM_s);
		
	ALURes_EX_MEM : Reg GENERIC MAP (32) PORT MAP -- ALU result
		(Clk, '1', ALU_res_EX_s, Rst_n, ALU_res_MEM_s);
		
	MemData_EX_MEM : Reg GENERIC MAP (32) PORT MAP -- Memory Data
		(Clk, '1', Memory_Data_EX_s, Rst_n, Memory_Data_MEM_s);
		
	-- MEM - Data Memory operations
	
	Mem_Write <= MEM_MEM_s(0); --Write control signal for Data Memory
	Mem_Read <= MEM_MEM_s(1); --Read control signal for Data Memory
	
	AddressDM <= std_logic_vector(ALU_res_MEM_s);
	DataDM <= Memory_Data_MEM_s;
	
	MEMO : MEM GENERIC MAP(32) PORT MAP
		(ALU_res_MEM_s, PC_4_MEM, Imm_MEM_s, PC_Imm_MEM_s, MEM_WB_MEM_s, Out_Mux_MEM_s);
	
	-- MEM/WB - Last pipeline stage
	
	WB_MEM_WB : Reg_slv GENERIC MAP (2) PORT MAP -- CU signals for WB
		(Clk, '1', WB_MEM_s, Rst_n, WB_WB_s);
	
	MEM_WB_MEM_WB : Reg_slv GENERIC MAP (2) PORT MAP -- CU signals for both MEM and WB
		(Clk, '1', MEM_WB_MEM_s, Rst_n, MEM_WB_WB_s);
	
	ALURes_MEM_WB : Reg GENERIC MAP (32) PORT MAP -- ALU result
		(Clk, '1', ALU_res_MEM_s, Rst_n, ALU_res_WB_s);
	
	MemData_MEM_WB : Reg GENERIC MAP (32) PORT MAP -- Memory Data
		(Clk, '1', Data, Rst_n, Memory_Data_WB_s);
	
	PC_4_MEM_WB : Reg GENERIC MAP (32) PORT MAP -- PC + 4 propagation
		(Clk, '1', PC_4_MEM, Rst_n, PC_4_WB);
	
	PC_Imm_MEM_WB : Reg GENERIC MAP (32) PORT MAP -- PC + immediate propagation
		(Clk, '1', PC_Imm_MEM_s, Rst_n, PC_Imm_WB_s);
	
	Imm_MEM_WB : Reg GENERIC MAP (32) PORT MAP -- Immediate
		(Clk, '1', Imm_MEM_s, Rst_n, Imm_WB_s);
		
	AddRd_MEM_WB : Reg_slv GENERIC MAP (5) PORT MAP -- Rd address
		(Clk, '1', AddRd_MEM_s, Rst_n, AddRd_WB_s);
	
	-- WB - Write Back
	WrB : WB GENERIC MAP(32) PORT MAP
		(ALU_res_WB_s, Memory_Data_WB_s, WB_WB_s(1), PC_4_WB, Imm_WB_s, PC_Imm_WB_s, MEM_WB_WB_s, Out_Mux_WB_s);	
	
END Beh;