library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LFSRFF is
    Port ( clk : in STD_LOGIC;
           InitEN : in STD_LOGIC;
           InitVal : in STD_LOGIC;
           D : in STD_LOGIC;
           Q : out STD_LOGIC
           );
end LFSRFF;

architecture Behavioral of LFSRFF is

begin
	process (clk, InitVal)
	begin
		if (InitEN = '1') then
			Q <= InitVal;		
		elsif (rising_edge(clk)) then
			Q <= D;
		end if;
	
	end process;
	
end Behavioral;