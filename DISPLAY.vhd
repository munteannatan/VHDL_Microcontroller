library ieee;
use ieee.std_logic_1164.all;	
use ieee.numeric_std.all;

entity AFISOR is
	port ( clock_100Mhz : in BIT;
		RESET : in STD_LOGIC; 
		DATA_IN:in STD_LOGIC_VECTOR (7 downto 0);
		SWITCH:in BIT;
		OUTPUT1:in integer range 0 to 255;
		OUTPUT2:in integer range 0 to 255;
      ANODE : out STD_LOGIC_VECTOR (3 downto 0);
      CATHODE : out STD_LOGIC_VECTOR (6 downto 0)
	);
end;

architecture AFISOR of AFISOR is  

function input2cathode(input:in	STD_LOGIC_VECTOR (3 downto 0)) return STD_LOGIC_VECTOR  is
variable cath : STD_LOGIC_VECTOR (6 downto 0);
begin
	case input is
    	when "0000" => cath := "0000001"; -- "0"     
    	when "0001" => cath := "1001111"; -- "1" 
   	 	when "0010" => cath := "0010010"; -- "2" 
    	when "0011" => cath := "0000110"; -- "3" 
    	when "0100" => cath := "1001100"; -- "4" 
    	when "0101" => cath := "0100100"; -- "5" 
    	when "0110" => cath := "0100000"; -- "6" 
   		when "0111" => cath := "0001111"; -- "7" 
    	when "1000" => cath := "0000000"; -- "8"     
    	when "1001" => cath := "0000100"; -- "9" 
    	when "1010" => cath := "0000010"; -- a
    	when "1011" => cath := "1100000"; -- b
    	when "1100" => cath := "0110001"; -- C
    	when "1101" => cath := "1000010"; -- d
    	when "1110" => cath := "0110000"; -- E
    	when "1111" => cath := "0111000"; -- F 
		when others =>null;	
	end case;
	return cath;
end;
signal clock:BIT;
begin  
	process(clock_100Mhz,reset)
	variable c:integer:=0;	
	variable clk:BIT:='0';	
	begin
		if reset = '1'then	   
			c := 0;
		elsif clock_100Mhz='1' and clock_100Mhz'event then 
			c:=c+1;
			if c=50000 then
				c:=0;
				clk:=not clk;
			end if;
		end if;
		clock<=clk;
	end process;
	process(clock,reset)
	variable anod : STD_LOGIC_VECTOR (3 downto 0);
    variable catod : STD_LOGIC_VECTOR (6 downto 0);
	variable count:integer range 0 to 4;--4;
	variable asdf1,asdf2:STD_LOGIC_VECTOR (7 downto 0);
	begin 
		asdf1:=std_logic_vector(to_unsigned(OUTPUT1,8));
		asdf2:=std_logic_vector(to_unsigned(OUTPUT2,8));
		if reset = '1'then
			anod:="1111";
			catod :="0000001";
			count := 0;
		elsif clock='1' and clock'event then
			case count is
				when 0 => count:=1;
				when 1 =>
					if SWITCH = '1' then
						catod :=input2cathode(asdf2(3 downto 0));
					else
						catod :=input2cathode(DATA_IN(3 downto 0));
					end if;
					anod:="1110";	
					count:=2;
				when 2 =>
					if SWITCH = '1' then
						catod :=input2cathode(asdf2(7 downto 4));
					else
						catod :=input2cathode(DATA_IN(7 downto 4));
					end if;
					anod:="1101";	
					count:=3;
				when 3 =>
					catod :=input2cathode(asdf1(3 downto 0));--"0000001";
					anod:="1011";	
					count:=4;
				when 4 =>
					catod :=input2cathode(asdf1(7 downto 4));
					anod:="0111";	
					count:=1;
			end case;
		end if;
		anode<=anod;
		cathode<=catod;
	end process;
end;