library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Imm_gen IS
GENERIC (N:INTEGER:=32);
PORT (instruct : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);

		Imm: OUT SIGNED(N-1 DOWNTO 0)
);
END Imm_gen;
	
ARCHITECTURE behaviour OF Imm_gen IS

	COMPONENT mux8to1 IS
	GENERIC (N:INTEGER:=16);
	PORT (in0, in1, in2, in3: IN SIGNED(N-1 DOWNTO 0);
			in4, in5, in6, in7: IN SIGNED(N-1 DOWNTO 0);
			sel: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			out_mux: OUT SIGNED(N-1 DOWNTO 0)
	);
	END COMPONENT;

	SIGNAL S : SIGNED(N-1 DOWNTO 0);
	SIGNAL U : SIGNED(N-1 DOWNTO 0);
	SIGNAL UJ : SIGNED(N-1 DOWNTO 0);
	SIGNAL SB : SIGNED(N-1 DOWNTO 0);
	SIGNAL I : SIGNED(N-1 DOWNTO 0);
	SIGNAL Sel : STD_LOGIC_VECTOR(2 DOWNTO 0);
	
	SIGNAL instruct_s : SIGNED(N-1 DOWNTO 0);
	

BEGIN

	Sel <= "000" when (NOT(instruct(5)) AND NOT(instruct(2))) = '1' else
			 "001" when (NOT(instruct(6)) AND (instruct(5)) AND NOT(instruct(2))) = '1' else
			 "010" when (instruct(6) AND NOT(instruct(2))) = '1' else
			 "011" when (instruct(3) AND instruct(2)) = '1' else
			 "100";
	
	instruct_s <= signed(instruct);

	S(31 DOWNTO 12) <= (others => instruct_s(31));
	S(11 DOWNTO 0) <= instruct_s(31 DOWNTO 25) & instruct_s(11 DOWNTO 7);
	
	U(31 DOWNTO 12) <= instruct_s(31 DOWNTO 12);
	U(11 DOWNTO 0) <= (others => '0');
	
	UJ(20 DOWNTO 0) <= instruct_s(31) & instruct_s(19 DOWNTO 12) & instruct_s(20) & instruct_s(30 DOWNTO 21) & '0';
	UJ(31 DOWNTO 21) <= (others => instruct_s(31));
	
	SB(12 DOWNTO 0) <= instruct_s(31) & instruct_s(7) & instruct_s(30 DOWNTO 25) & instruct_s(11 DOWNTO 8) & '0';
	SB(31 DOWNTO 13) <= (others => instruct_s(31));

	I(11 DOWNTO 0) <= instruct_s(31 DOWNTO 20);
	I(31 DOWNTO 12) <= (others => instruct_s(31));
	
	Mx : mux8to1 GENERIC MAP(N) PORT MAP
		(I, S, SB, UJ, U, to_signed(0, N), to_signed(0, N), to_signed(0, N), Sel, Imm);


END behaviour;

