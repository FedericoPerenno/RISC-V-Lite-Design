library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY mux8to1 IS
GENERIC (N:INTEGER:=16);
PORT (in0, in1, in2, in3: IN SIGNED(N-1 DOWNTO 0);
		in4, in5, in6, in7: IN SIGNED(N-1 DOWNTO 0);
		sel: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		out_mux: OUT SIGNED(N-1 DOWNTO 0)
);
END mux8to1;

ARCHITECTURE behaviour OF mux8to1 IS

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
	
	SIGNAL mux0, mux1 : SIGNED(N-1 DOWNTO 0);
	
BEGIN
	
	MX0 : Mux_4to1 GENERIC MAP(N) PORT MAP
		(in0, in1, in2, in3, sel(1 DOWNTO 0), mux0);
		
	MX1 : Mux_4to1 GENERIC MAP(N) PORT MAP
		(in4, in5, in6, in7, sel(1 DOWNTO 0), mux1);
		
	MX2 : mux2to1 GENERIC MAP(N) PORT MAP
		(mux0, mux1, sel(2), out_mux);
	
END behaviour;