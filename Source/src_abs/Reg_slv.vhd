LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity Reg_slv is
GENERIC (N : INTEGER := 8);
port (Clk : IN STD_LOGIC;
		Enable : IN STD_LOGIC;
		
		DIN : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		
		RST_n : IN STD_LOGIC;
		
		DOUT : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
end entity;
		
architecture behaviour of Reg_slv is

begin

	process(Clk, Rst_n)
	begin
		if(Clk'EVENT AND Clk = '1') then
			if(Rst_n = '0') then
				DOUT <= (others => '0');
			elsif (Enable = '1') then
				DOUT <= DIN;
			end if;
		end if;
	end process;
	
end behaviour;