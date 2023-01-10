library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Mux_32to1 IS
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
END Mux_32to1;

ARCHITECTURE behaviour OF Mux_32to1 IS

	COMPONENT mux16to1 IS
	GENERIC (N:INTEGER:=16);
	PORT (in0, in1, in2, in3: IN SIGNED(N-1 DOWNTO 0);
			in4, in5, in6, in7: IN SIGNED(N-1 DOWNTO 0);
			in8, in9, in10, in11: IN SIGNED(N-1 DOWNTO 0);
			in12, in13, in14, in15: IN SIGNED(N-1 DOWNTO 0);
			
			sel: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
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
	
	
SIGNAL mux0, mux1 : SIGNED(N-1 DOWNTO 0);
	
BEGIN
	
	MX0 : mux16to1 GENERIC MAP(N) PORT MAP
		(in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, 
		in11, in12, in13, in14, in15, sel(3 DOWNTO 0), mux0);
		
	MX1 : mux16to1 GENERIC MAP(N) PORT MAP
		(in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, 
		in26, in27, in28, in29, in30, in31, sel(3 DOWNTO 0), mux1);
		
	MX2 : mux2to1 GENERIC MAP(N) PORT MAP
		(mux0, mux1, sel(4), out_mux);



--		out_mux <= in0 when (sel = "00000") else in1 when (sel = "00001") else in2 when (sel = "00010") else in3 when (sel = "00011") else
--					  in4 when (sel = "00100") else in5 when (sel = "00101") else in6 when (sel = "00110") else in7 when (sel = "00111") else
--					  in8 when (sel = "01000") else in9 when (sel = "01001") else in10 when (sel = "01010") else in11 when (sel = "01011") else
--					  in12 when (sel = "01100") else in13 when (sel = "01101") else in14 when (sel = "01110") else in15 when (sel = "01111") else
--					  in16 when (sel = "10000") else in17 when (sel = "10001") else in18 when (sel = "10010") else in19 when (sel = "10011") else
--					  in20 when (sel = "10100") else in21 when (sel = "10101") else in22 when (sel = "10110") else in23 when (sel = "10111") else
--					  in24 when (sel = "11000") else in25 when (sel = "11001") else in26 when (sel = "11010") else in27 when (sel = "11011") else
--					  in28 when (sel = "11100") else in29 when (sel = "11101") else in30 when (sel = "11110") else in31 when (sel = "11111");
	
END behaviour;