

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Controller is
    Port ( Start : in STD_LOGIC;
           Stop : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           Inc : in STD_LOGIC;
           Run : out STD_LOGIC);
end Controller;

architecture Behavioral of Controller is

signal a: STD_LOGIC;
begin
    process (CLK, RST, Start, Stop, Inc)
    begin
    
    if RST = '1' then Run <= '0';
    
    elsif (Inc ='1') then Run <= '1';
    
    elsif (Start ='1') then a <= '1';
    
    elsif (Stop='1') then a <= '0';
    
    elsif (CLK'event and CLK ='1') then Run <= a;
        
    end if;
    
    end process;

end Behavioral;
