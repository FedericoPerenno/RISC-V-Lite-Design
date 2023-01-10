library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB is

end TB;

architecture beh of TB is

  COMPONENT RISC_V
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
	END COMPONENT;
	
	COMPONENT clk_gen
	port (
		CLK     : out std_logic;
		RST_n   : out std_logic);
	END COMPONENT;
	
	COMPONENT data_maker is  
	port (CLK     : in  std_logic;
	 
			ADD_Instr     : out std_logic_vector(6 DOWNTO 0);
			DOUT_Instr    : out std_logic_vector(31 downto 0);
	 
			ADD_Data     : out std_logic_vector(5 DOWNTO 0);
			DOUT_Data   : out std_logic_vector(31 downto 0);
	 
			Sel : out std_logic;
			WR_IM : out std_logic);
	end COMPONENT;
	
	COMPONENT mux2to1_slv IS
	GENERIC (N:INTEGER:=16);
	PORT (in0, in1: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			sel: IN STD_LOGIC;
			out_mux: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT mux2to1_sl IS
	PORT (in0, in1: IN STD_LOGIC;
	sel: IN STD_LOGIC;
	out_mux: OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT Memory_asynch IS 
	GENERIC (DimAdd: INTEGER:=7 ;--Indica la dimensione bit di Address. Deve essere 10.
			   DimData: INTEGER:= 8);--Indica la dimensione bit di Data. Deve essere 8.
	PORT (DataIn:IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		   WR,RD,CS: IN STD_LOGIC;
		   Address: IN STD_LOGIC_VECTOR(DimAdd-1 DOWNTO 0);
		   DataOut: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	END COMPONENT;

	SIGNAL CLK_i : STD_LOGIC;
	SIGNAL SEL_i : STD_LOGIC;
    SIGNAL RST_n_i : STD_LOGIC;
	SIGNAL ADD_Instr_i : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL DIN_Instr_i : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ADD_Data_i : STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL DIN_Data_i : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL INSTRUC_i : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL DATA_i : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL DATA_s_i : SIGNED(31 DOWNTO 0);
	
	SIGNAL WR_IM_i : STD_LOGIC;
	SIGNAL RD_IM_i : STD_LOGIC;
	SIGNAL WR_DM_i : STD_LOGIC;
	SIGNAL Mem_Write_i : STD_LOGIC;
	
	SIGNAL AddressIM_i : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ADD_IM_i : STD_LOGIC_VECTOR(6 DOWNTO 0);
	
	SIGNAL AddressDM_i : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ADD_DM_i : STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL DataDM_i : SIGNED(31 DOWNTO 0);
	SIGNAL DataDM_slv_i : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL D_DM_i : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ADD_DM_i_delayed : STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL Mem_Read_i : STD_LOGIC;
	
	constant tco : time := 1 ns;

begin

	

	CG : clk_gen port map
		(CLK_i, RST_n_i);
		
	SM : data_maker port map
		(CLK_i, ADD_Instr_i, DIN_Instr_i, ADD_Data_i, DIN_Data_i, SEL_i, WR_IM_i);
	
	RD_IM_i <= NOT(WR_IM_i);
	
	MX_AI : mux2to1_slv GENERIC MAP (7) PORT MAP
		(ADD_Instr_i, AddressIM_i(6 DOWNTO 0), SEL_i, ADD_IM_i);
	
	IM : Memory_asynch GENERIC MAP (7, 8) port map
		(DIN_Instr_i, WR_IM_i, RD_IM_i, '1', ADD_IM_i, INSTRUC_i);
		
	MX_WR : mux2to1_sl port map
		('1', Mem_Write_i, SEL_i, WR_DM_i);
		
	MX_AD : mux2to1_slv GENERIC MAP (6) PORT MAP
		(ADD_Data_i, AddressDM_i(5 DOWNTO 0), SEL_i, ADD_DM_i);
		
	DataDM_slv_i <= std_logic_vector(DataDM_i);
		
	MX_DD : mux2to1_slv GENERIC MAP (32) PORT MAP
		(DIN_Data_i, DataDM_slv_i, SEL_i, D_DM_i);
		
	ADD_DM_i_delayed <= ADD_DM_i after tco;
	
	DM : Memory_asynch GENERIC MAP (6, 8) port map
		(D_DM_i, WR_DM_i, Mem_Read_i, '1', ADD_DM_i_delayed, DATA_i);
	
	DATA_s_i <= signed(DATA_i);

	UUT : RISC_V PORT MAP
		(CLK_i, RST_n_i, INSTRUC_i, DATA_s_i, AddressDM_i, DataDM_i, AddressIM_i, Mem_Write_i, Mem_Read_i);	
	
end beh;
