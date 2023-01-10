library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity data_maker is  
  port (
    CLK     : in  std_logic;
	 
    ADD_Instr     : out std_logic_vector(6 DOWNTO 0);
    DOUT_Instr    : out std_logic_vector(31 downto 0);
	 
	 ADD_Data     : out std_logic_vector(5 DOWNTO 0);
    DOUT_Data   : out std_logic_vector(31 downto 0);
	 
	 Sel : out std_logic;
	 WR_IM : out std_logic);
end data_maker;

architecture beh of data_maker is

  constant tco : time := 1 ns;
  
  SIGNAL Sel_Instr : STD_LOGIC;
  SIGNAL Sel_Data : STD_LOGIC;

begin  -- beh

  process (CLK)
    file fp_in : text open READ_MODE is "./Instruction.txt";
    variable line_in : line;
    variable x : std_logic_vector(31 DOWNTO 0);
	 variable a : integer := 0;
  begin 
    if CLK'event and CLK = '1' then  -- rising clock edge
      if not endfile(fp_in) then
		  WR_IM <= '1';
		  Sel_Instr <= '0';
        readline(fp_in, line_in);
        read(line_in, x);
        DOUT_Instr <= x after tco;
        ADD_Instr  <= std_logic_vector(to_signed(a, 7)) after tco;
		  a := a + 4;
		else
		  Sel_Instr <= '1';
		  WR_IM <= '0';
      end if;
	 end if;
  end process;
  
  
  process (CLK)
    file fp_in : text open READ_MODE is "./Data.txt";
    variable line_in : line;
    variable x : std_logic_vector(31 DOWNTO 0);
	 variable a : integer := 0;
  begin 
    if CLK'event and CLK = '1' then  -- rising clock edge
      if not endfile(fp_in) then
		  Sel_Data <= '0';
        readline(fp_in, line_in);
        read(line_in, x);
        DOUT_Data <= x after tco;
        ADD_Data  <= std_logic_vector(to_signed(a, 6)) after tco;
		  a := a + 4;
		 else
			Sel_Data <= '1';
      end if;
	 end if;
  end process;

  Sel <= Sel_Instr AND Sel_Data;  

end beh;
