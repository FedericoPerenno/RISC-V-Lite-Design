LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity Reg_file is
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
end entity;
		
architecture behaviour of Reg_file is

	COMPONENT Reg
	GENERIC (N : INTEGER := 8);
		port (Clk : IN STD_LOGIC;
				Enable : IN STD_LOGIC;
		
				DIN : IN SIGNED(N-1 DOWNTO 0);
		
				RST_n : IN STD_LOGIC;
		
				DOUT : OUT SIGNED(N-1 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT Mux_32to1
	GENERIC (N:INTEGER:=32);
	PORT (in0, in1, in2, in3: IN SIGNED(N-1 DOWNTO 0);
		in4, in5, in6, in7: IN SIGNED(N-1 DOWNTO 0);
		in8, in9, in10, in11: IN SIGNED(N-1 DOWNTO 0);
		in12, in13, in14, in15: IN SIGNED(N-1 DOWNTO 0);
		in16, in17, in18, in19: IN SIGNED(N-1 DOWNTO 0);
		in20, in21, in22, in23: IN SIGNED(N-1 DOWNTO 0);
		in24, in25, in26, in27: IN SIGNED(N-1 DOWNTO 0);
		in28, in29, in30, in31: IN SIGNED(N-1 DOWNTO 0);
		
		sel: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		out_mux: OUT SIGNED(N-1 DOWNTO 0));
	END COMPONENT;
	
	SIGNAL WE0 : STD_LOGIC;
	SIGNAL WE1 : STD_LOGIC;
	SIGNAL WE2 : STD_LOGIC;
	SIGNAL WE3 : STD_LOGIC;
	SIGNAL WE4 : STD_LOGIC;
	SIGNAL WE5 : STD_LOGIC;
	SIGNAL WE6 : STD_LOGIC;
	SIGNAL WE7 : STD_LOGIC;
	SIGNAL WE8 : STD_LOGIC;
	SIGNAL WE9 : STD_LOGIC;
	SIGNAL WE10 : STD_LOGIC;
	SIGNAL WE11 : STD_LOGIC;
	SIGNAL WE12 : STD_LOGIC;
	SIGNAL WE13 : STD_LOGIC;
	SIGNAL WE14 : STD_LOGIC;
	SIGNAL WE15 : STD_LOGIC;
	SIGNAL WE16 : STD_LOGIC;
	SIGNAL WE17 : STD_LOGIC;
	SIGNAL WE18 : STD_LOGIC;
	SIGNAL WE19 : STD_LOGIC;
	SIGNAL WE20 : STD_LOGIC;
	SIGNAL WE21 : STD_LOGIC;
	SIGNAL WE22 : STD_LOGIC;
	SIGNAL WE23 : STD_LOGIC;
	SIGNAL WE24 : STD_LOGIC;
	SIGNAL WE25 : STD_LOGIC;
	SIGNAL WE26 : STD_LOGIC;
	SIGNAL WE27 : STD_LOGIC;
	SIGNAL WE28 : STD_LOGIC;
	SIGNAL WE29 : STD_LOGIC;
	SIGNAL WE30 : STD_LOGIC;
	SIGNAL WE31 : STD_LOGIC;
	
	SIGNAL OutReg0 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg1 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg2 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg3 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg4 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg5 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg6 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg7 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg8 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg9 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg10 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg11 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg12 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg13 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg14 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg15 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg16 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg17 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg18 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg19 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg20 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg21 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg22 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg23 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg24 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg25 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg26 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg27 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg28 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg29 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg30 : SIGNED(N-1 DOWNTO 0);
	SIGNAL OutReg31 : SIGNED(N-1 DOWNTO 0);
	
begin

	WE0 <= '1' when ((Write_reg = "00000") AND (RegWrite = '1')) else '0';
	X0 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE0, Write_data, Rst_n, OutReg0);
	
	WE1 <= '1' when ((Write_reg = "00001") AND (RegWrite = '1')) else '0';
	X1 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE1, Write_data, Rst_n, OutReg1);
	
	WE2 <= '1' when ((Write_reg = "00010") AND (RegWrite = '1'))  else '0';
	X2 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE2, Write_data, Rst_n, OutReg2);
	
	WE3 <= '1' when ((Write_reg = "00011") AND (RegWrite = '1'))  else '0';
	X3 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE3, Write_data, Rst_n, OutReg3);
	
	WE4 <= '1' when ((Write_reg = "00100") AND (RegWrite = '1'))  else '0';
	X4 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE4, Write_data, Rst_n, OutReg4);
	
	WE5 <= '1' when ((Write_reg = "00101") AND (RegWrite = '1'))  else '0';
	X5 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE5, Write_data, Rst_n, OutReg5);
	
	WE6 <= '1' when ((Write_reg = "00110") AND (RegWrite = '1'))  else '0';
	X6 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE6, Write_data, Rst_n, OutReg6);
	
	WE7 <= '1' when ((Write_reg = "00111") AND (RegWrite = '1'))  else '0';
	X7 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE7, Write_data, Rst_n, OutReg7);
	
	WE8 <= '1' when ((Write_reg = "01000") AND (RegWrite = '1'))  else '0';
	X8 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE8, Write_data, Rst_n, OutReg8);
	
	WE9 <= '1' when ((Write_reg = "01001") AND (RegWrite = '1'))  else '0';
	X9 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE9, Write_data, Rst_n, OutReg9);
	
	WE10 <= '1' when ((Write_reg = "01010") AND (RegWrite = '1'))  else '0';
	X10 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE10, Write_data, Rst_n, OutReg10);
	
	WE11 <= '1' when ((Write_reg = "01011") AND (RegWrite = '1'))  else '0';
	X11 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE11, Write_data, Rst_n, OutReg11);
	
	WE12 <= '1' when ((Write_reg = "01100") AND (RegWrite = '1'))  else '0';
	X12 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE12, Write_data, Rst_n, OutReg12);
	
	WE13 <= '1' when ((Write_reg = "01101") AND (RegWrite = '1'))  else '0';
	X13 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE13, Write_data, Rst_n, OutReg13);
	
	WE14 <= '1' when ((Write_reg = "01110") AND (RegWrite = '1'))  else '0';
	X14 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE14, Write_data, Rst_n, OutReg14);
	
	WE15 <= '1' when ((Write_reg = "01111") AND (RegWrite = '1'))  else '0';
	X15 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE15, Write_data, Rst_n, OutReg15);
	
	WE16 <= '1' when ((Write_reg = "10000") AND (RegWrite = '1'))  else '0';
	X16 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE16, Write_data, Rst_n, OutReg16);
	
	WE17 <= '1' when ((Write_reg = "10001") AND (RegWrite = '1'))  else '0';
	X17 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE17, Write_data, Rst_n, OutReg17);
	
	WE18 <= '1' when ((Write_reg = "10010") AND (RegWrite = '1'))  else '0';
	X18 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE18, Write_data, Rst_n, OutReg18);
	
	WE19 <= '1' when ((Write_reg = "10011") AND (RegWrite = '1'))  else '0';
	X19 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE19, Write_data, Rst_n, OutReg19);
	
	WE20 <= '1' when ((Write_reg = "10100") AND (RegWrite = '1'))  else '0';
	X20 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE20, Write_data, Rst_n, OutReg20);
	
	WE21 <= '1' when ((Write_reg = "10101") AND (RegWrite = '1'))  else '0';
	X21 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE21, Write_data, Rst_n, OutReg21);
	
	WE22 <= '1' when ((Write_reg = "10110") AND (RegWrite = '1'))  else '0';
	X22 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE22, Write_data, Rst_n, OutReg22);
	
	WE23 <= '1' when ((Write_reg = "10111") AND (RegWrite = '1'))  else '0';
	X23 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE23, Write_data, Rst_n, OutReg23);
	
	WE24 <= '1' when ((Write_reg = "11000") AND (RegWrite = '1'))  else '0';
	X24 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE24, Write_data, Rst_n, OutReg24);
	
	WE25 <= '1' when ((Write_reg = "11001") AND (RegWrite = '1'))  else '0';
	X25 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE25, Write_data, Rst_n, OutReg25);
	
	WE26 <= '1' when ((Write_reg = "11010") AND (RegWrite = '1'))  else '0';
	X26 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE26, Write_data, Rst_n, OutReg26);
	
	WE27 <= '1' when ((Write_reg = "11011") AND (RegWrite = '1'))  else '0';
	X27 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE27, Write_data, Rst_n, OutReg27);
		
	WE28 <= '1' when ((Write_reg = "11100") AND (RegWrite = '1'))  else '0';
	X28 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE28, Write_data, Rst_n, OutReg28);
	
	WE29 <= '1' when ((Write_reg = "11101") AND (RegWrite = '1'))  else '0';
	X29 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE29, Write_data, Rst_n, OutReg29);
	
	WE30 <= '1' when ((Write_reg = "11110") AND (RegWrite = '1'))  else '0';
	X30 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE30, Write_data, Rst_n, OutReg30);
	
	WE31 <= '1' when ((Write_reg = "11111") AND (RegWrite = '1'))  else '0';
	X31 : Reg GENERIC MAP (32) PORT MAP
		(Clk, WE31, Write_data, Rst_n, OutReg31);
		
	Mux1 : Mux_32to1 GENERIC MAP (32) PORT MAP
		(OutReg0, OutReg1, OutReg2, OutReg3, OutReg4, OutReg5, OutReg6, OutReg7, OutReg8, OutReg9, OutReg10, OutReg11, OutReg12, OutReg13, OutReg14, OutReg15,
		 OutReg16, OutReg17, OutReg18, OutReg19, OutReg20, OutReg21, OutReg22, OutReg23, OutReg24, OutReg25, OutReg26, OutReg27, OutReg28, OutReg29, OutReg30, 
		 OutReg31, Read_reg1, Read_data1);
		 
	Mux2 : Mux_32to1 GENERIC MAP (32) PORT MAP
		(OutReg0, OutReg1, OutReg2, OutReg3, OutReg4, OutReg5, OutReg6, OutReg7, OutReg8, OutReg9, OutReg10, OutReg11, OutReg12, OutReg13, OutReg14, OutReg15,
		 OutReg16, OutReg17, OutReg18, OutReg19, OutReg20, OutReg21, OutReg22, OutReg23, OutReg24, OutReg25, OutReg26, OutReg27, OutReg28, OutReg29, OutReg30, 
		 OutReg31, Read_reg2, Read_data2);	
	
	
end behaviour;
			