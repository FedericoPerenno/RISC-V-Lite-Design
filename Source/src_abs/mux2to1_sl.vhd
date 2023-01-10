library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY mux2to1_sl IS
PORT (in0, in1: IN STD_LOGIC;
	sel: IN STD_LOGIC;
	out_mux: OUT STD_LOGIC
);
END mux2to1_sl;

ARCHITECTURE behaviour OF mux2to1_sl IS
BEGIN
		out_mux <= in1 when (sel = '1') else in0;
	
END behaviour;