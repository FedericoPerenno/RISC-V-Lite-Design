library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Mux_4to1 IS
GENERIC (N:INTEGER:=16);
PORT (in0, in1, in2, in3: IN SIGNED(N-1 DOWNTO 0);
		sel: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		out_mux: OUT SIGNED(N-1 DOWNTO 0)
);
END Mux_4to1;

ARCHITECTURE behaviour OF Mux_4to1 IS
BEGIN
		out_mux <= in0 when (sel = "00") else in1 when (sel = "01") else in2 when (sel = "10") else in3;
	
END behaviour;