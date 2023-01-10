library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY CU IS
PORT (Clk 				: IN STD_LOGIC;

		opcode 			: IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		
		MemRead			: OUT STD_LOGIC;
		MemtoReg			: OUT STD_LOGIC;
		ALUOp				: OUT STD_LOGIC_VECTOR(1 downto 0);
		MemWrite			: OUT STD_LOGIC;
		ALUSrc			: OUT STD_LOGIC;
		RegWrite			: OUT STD_LOGIC;
		JMP				: OUT STD_LOGIC;
		Branch         : OUT STD_LOGIC;
		SelMUX_WD 		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
END CU;

ARCHITECTURE beh OF CU IS

	COMPONENT Decoder7to4
	PORT (InDEC 			: IN STD_LOGIC_VECTOR(6 DOWNTO 0);

			OutDEC			: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT ROM
	PORT( address: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			data: OUT STD_LOGIC_VECTOR (10 DOWNTO 0));
	END COMPONENT;
	
	SIGNAL OutDec_s : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL Out_rom : STD_LOGIC_VECTOR(10 DOWNTO 0);

BEGIN

	Dec : Decoder7to4 PORT MAP
		(opcode, OutDec_s);
		
	Mem : ROM PORT MAP
		(OutDec_s, Out_rom);
	
	MemRead			<= Out_rom(10);
	MemtoReg			<= Out_rom(9);
	ALUOp				<= Out_rom(8 DOWNTO 7);
	MemWrite			<= Out_rom(6);
	ALUSrc			<= Out_rom(5);
	RegWrite			<= Out_rom(4);
	JMP				<= Out_rom(3);
	Branch         <= Out_rom(2);
	SelMUX_WD 		<= Out_rom(1 DOWNTO 0);
	
END beh;