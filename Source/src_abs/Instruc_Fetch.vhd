LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instruc_Fetch is
GENERIC (N : INTEGER:=32);
PORT (Clk 	: IN STD_LOGIC;
		Rst_n : IN STD_LOGIC;
		
		PC_Write : IN STD_LOGIC;
		Sel_Pc_in : IN STD_LOGIC;
		
		PC_BEQ_JAL : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		
		PC_Out : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		PC_4 : OUT SIGNED(N-1 DOWNTO 0));
		
end entity;

ARCHITECTURE Beh OF Instruc_Fetch IS

	COMPONENT  mux2to1_slv IS
	GENERIC (N:INTEGER:=16);
	PORT (in0, in1: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		sel: IN STD_LOGIC;
		out_mux: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT Reg_slv is
	GENERIC (N : INTEGER := 8);
	port (Clk : IN STD_LOGIC;
			Enable : IN STD_LOGIC;
			
			DIN : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
			
			RST_n : IN STD_LOGIC;
			
			DOUT : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
	END COMPONENT;
		
	SIGNAL PC_4_s : SIGNED(N-1 DOWNTO 0);
	SIGNAL Out_Mux : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL Out_PC : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	
BEGIN

	Mux : mux2to1_slv GENERIC MAP (32) PORT MAP
		(std_logic_vector(PC_4_s), PC_BEQ_JAL, Sel_Pc_in, Out_Mux);
		
	PC : Reg_slv GENERIC MAP (32) PORT MAP
		(Clk, PC_Write, Out_Mux, Rst_n, Out_PC);
		
	
	PC_4_s <= signed(Out_PC) + to_signed(4, N);
	PC_4 <= PC_4_s;
	
	PC_Out <= Out_PC;


END Beh;