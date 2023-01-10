LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity FF is
port (Clk : IN STD_LOGIC;
		Enable : IN STD_LOGIC;
		
		DIN : IN STD_LOGIC;
		
		RST_n : IN STD_LOGIC;
		
		DOUT : OUT STD_LOGIC);
end entity;
		
architecture behaviour of FF is

begin

	process(Clk, Rst_n)
	begin
		if(Clk'EVENT AND Clk = '1') then
			if(Rst_n = '0') then
				DOUT <= '0';
			elsif (Enable = '1') then
				DOUT <= DIN;
			end if;
		end if;
	end process;
	
end behaviour;
			