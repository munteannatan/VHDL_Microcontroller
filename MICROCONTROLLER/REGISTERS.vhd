library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;
use types.all;

entity REGISTERS_BLACK_BOX is
	generic(
		NR_BITS: INTEGER:= 8;
		NR_OF_REGISTERS: INTEGER:= 16
	);
	port(	   
		RESET: in STD_LOGIC;
		ENABLE: in STD_LOGIC;
		CLK: in STD_LOGIC;
		
		REGISTER_UPDATE_INPUT: in STD_LOGIC_VECTOR(NR_BITS - 1 downto 0);
		
		FIRST_MUX_SEL: in INTEGER;
		SECOND_MUX_SEL: in INTEGER;
		
		FIRST_REGISTER_OUT: out STD_LOGIC_VECTOR(NR_BITS - 1 downto 0);
		SECOND_REGISTER_OUT: out STD_LOGIC_VECTOR(NR_BITS - 1 downto 0);
		
		REGISTER_MATRIX_OUT: out matrix8(15 downto 0)
	);
end entity REGISTERS_BLACK_BOX;

architecture REGISTERS_BLACK_BOX_ARCHITECTURE of REGISTERS_BLACK_BOX is

signal REGISTERS_MATRIX: matrix8(15 downto 0) := 
("00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000",
"00000000");													

begin		 			
	
	MAIN_TAG:process(RESET, CLK, FIRST_MUX_SEL, SECOND_MUX_SEL, ENABLE)
	variable FIRST: INTEGER := 0;
	variable SECOND: INTEGER := 0;
	variable FIRST_VALUE: STD_LOGIC_VECTOR(NR_BITS - 1 downto 0) := "00000000";
	variable SECOND_VALUE: STD_LOGIC_VECTOR(NR_BITS - 1 downto 0) := "00000000";
	variable UPDATE_VALUE: STD_LOGIC_VECTOR(NR_BITS - 1 downto 0) := "00000000";											  								   
	begin		
		if(ENABLE = '1') then 
			if(FIRST_MUX_SEL >= 0 and FIRST_MUX_SEL < NR_OF_REGISTERS) then
				FIRST_REGISTER_OUT <= REGISTERS_MATRIX(FIRST_MUX_SEL);		   
			end if;
			if(SECOND_MUX_SEL >= 0 and SECOND_MUX_SEL < NR_OF_REGISTERS) then
				SECOND_REGISTER_OUT <= REGISTERS_MATRIX(SECOND_MUX_SEL);		 
			end if;
			
			if(RESET = '1') then
				REGISTERS_MATRIX <= (	"00000000",
										"00000000",
										"00000000",
										"00000000",
										"00000000",
										"00000000",
										"00000000",
										"00000000",
										"00000000",
										"00000000",
										"00000000",
										"00000000",
										"00000000",
										"00000000",
										"00000000",
										"00000000");
			else
				if(rising_edge(CLK)) then
					FIRST := FIRST_MUX_SEL;
					UPDATE_VALUE := REGISTER_UPDATE_INPUT;
					if(FIRST >= 0 and FIRST < NR_OF_REGISTERS) then			   			
						REGISTERS_MATRIX(FIRST) <= UPDATE_VALUE;  
					end if;
				end if;	  
			end if;
		end if;
	end process MAIN_TAG;
	
	
	
	REGISTER_MATRIX_OUT <= REGISTERS_MATRIX;
end architecture REGISTERS_BLACK_BOX_ARCHITECTURE;