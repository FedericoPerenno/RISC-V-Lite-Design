library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Decoder7to4 IS
PORT (InDEC 			: IN STD_LOGIC_VECTOR(6 DOWNTO 0);

		OutDEC			: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END Decoder7to4;

ARCHITECTURE beh OF Decoder7to4 IS
BEGIN

	OutDEC <=   "0000" when (inDEC(5) AND inDEC(4) AND NOT(InDEC(2))) = '1' else
				 "0001" when (NOT(inDEC(5)) AND inDEC(4) AND NOT(InDEC(2))) = '1' else
				 "0010" when (NOT(inDEC(6)) AND inDEC(5) AND NOT(InDEC(4))) = '1' else
				 "0011" when (NOT(inDEC(5)) AND NOT(InDEC(4)) AND InDEC(1)) = '1' else
				 "0100" when (inDEC(6) AND inDEC(5) AND NOT(InDEC(3))) = '1' else
				 "0101" when  inDEC(3) =  '1' else
				 "0110" when (NOT(inDEC(5)) AND InDEC(2)) = '1' else
				 "0111" when (inDEC(5) AND NOT(inDEC(3)) AND InDEC(2)) = '1' else
				 "1000";
				 
END beh;