LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ROM IS

PORT( address: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
	  data: OUT STD_LOGIC_VECTOR (10 DOWNTO 0));

END ENTITY ROM;

ARCHITECTURE behaviour OF ROM IS

TYPE rom_array IS ARRAY (0 TO 8) OF STD_LOGIC_VECTOR(10 DOWNTO 0);

constant rom_data: rom_array := ( "00000010000",
								  "00010110000",
								  "00101100000",
								  "11110110000",
								  "00110000100",
								  "00110011001",
								  "00110010011",
								  "00110010010",
								  "00000000000");

BEGIN

data <= rom_data(to_integer(unsigned(address)));

END ARCHITECTURE;