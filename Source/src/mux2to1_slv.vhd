library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY mux2to1_slv IS
GENERIC (N:INTEGER:=16);
PORT (in0, in1: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	sel: IN STD_LOGIC;
	out_mux: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
);
END mux2to1_slv;

ARCHITECTURE behaviour OF mux2to1_slv IS
BEGIN
		out_mux <= in1 when (sel = '1') else in0;
	
END behaviour;