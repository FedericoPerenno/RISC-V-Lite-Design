LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--Memoria con 2^(DimAdd) Registri, ognuno da DimData bit.
--Se voglio 1024 registri, dovrò inserire DimAdd=10.

ENTITY Memory_asynch IS 
GENERIC (DimAdd: INTEGER:=7 ;--Indica la dimensione bit di Address. Deve essere 10.
		   DimData: INTEGER:= 8);--Indica la dimensione bit di Data. Deve essere 8.
PORT (DataIn:IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	   WR,RD,CS: IN STD_LOGIC;
	   Address: IN STD_LOGIC_VECTOR(DimAdd-1 DOWNTO 0);
	   DataOut: OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
END Memory_asynch;

ARCHITECTURE Behaviour OF Memory_asynch IS 

  TYPE matrix IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(DimData-1 downto 0);
  signal Mem : MATRIX(0 TO (2**DimAdd)-1);
  signal data : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN

--Tri-State Buffer control
dataOut <= data when (CS = '1' and RD = '1' and WR = '0') else (others=>'Z');

--memory write block
MEM_WRITE: PROCESS (Address) BEGIN
	IF (CS = '1' AND WR = '1') THEN
			Mem(TO_INTEGER(UNSIGNED(Address)))<= DataIn(31 downto 24);
			Mem(TO_INTEGER(UNSIGNED(Address)+1))<=(DataIn(23 downto 16));
			Mem(TO_INTEGER(UNSIGNED(Address)+2))<=(DataIn(15 downto 8));
			Mem(TO_INTEGER(UNSIGNED(Address)+3))  <=(DataIn(7 downto 0));
	END IF;
END PROCESS;

-- Memory Read Block
MEM_READ: PROCESS(Address, CS, RD, Mem) begin
	IF (CS = '1' AND RD = '1') THEN
			data(7 downto 0)   <=Mem(TO_INTEGER(UNSIGNED(Address)+3));
			data(15 downto 8) <=Mem(TO_INTEGER(UNSIGNED(Address)+2));
			data(23 downto 16)<=Mem(TO_INTEGER(UNSIGNED(Address)+1));
			data(31 downto 24)<=Mem(TO_INTEGER(UNSIGNED(Address)));
	END IF;
END PROCESS;
END Behaviour;
