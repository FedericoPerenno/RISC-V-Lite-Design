LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shift is
GENERIC (N : INTEGER:=32);
port (Shift_In  : IN SIGNED (N-1 DOWNTo 0);
		Shift_Val : IN INTEGER;
		
		Shift_Out : OUT SIGNED (N-1 DOWNTO 0));
end entity;

architecture Beh of Shift is	
begin

--	Shift_Out(N-2-Shift_Val DOWNTO 0) <= Shift_In(N-2 DOWNTO Shift_Val);
--	Shift_Out(N-1 DOWNTo N-1-Shift_val) <= (others => shift_In(N-1));

	Shift_Out <= shift_right(Shift_In, Shift_Val);
	
end Beh;

