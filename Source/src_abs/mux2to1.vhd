library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY mux2to1 IS
GENERIC (N:INTEGER:=16);
PORT (in0, in1: IN SIGNED(N-1 DOWNTO 0);
	sel: IN STD_LOGIC;
	out_mux: OUT SIGNED(N-1 DOWNTO 0)
);
END mux2to1;

ARCHITECTURE behaviour OF mux2to1 IS
BEGIN
		out_mux <= in1 when (sel = '1') else in0;
	
END behaviour;
	