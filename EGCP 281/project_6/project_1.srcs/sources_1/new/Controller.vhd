

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

signal a: STD_LOGIC_VECTOR(1 downto 0);
signal nxt: STD_LOGIC_VECTOR(1 downto 0) := "00";
begin
    
   
    process (CLK, RST, Start, Stop, Inc)
    begin
    a <= nxt;
    if RST = '1' then 
    a <= "00";
    nxt <= "00";
   
    elsif (Inc'event and Inc ='1') then 
    a <= "10";
    nxt <= "00";
    
    elsif (Start'event and Start ='1') then 
    a <= "11";
    nxt <= "11";
   
    elsif (Stop'event and Stop = '1') then
    a <= "00";
    nxt <= "00";
    
    else
    nxt <= "00";
    
    end if;
    end process;
    Run <= a(1);
    
                
    
end Behavioral;
