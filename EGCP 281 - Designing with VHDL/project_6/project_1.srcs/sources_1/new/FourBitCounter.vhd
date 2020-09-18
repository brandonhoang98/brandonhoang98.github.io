library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
entity FourBitCounter is
 Port ( Cen : in STD_LOGIC;
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        B : out STD_LOGIC_VECTOR (3 downto 0));
end FourBitCounter;

architecture Behavioral of FourBitCounter is
signal temp: STD_LOGIC_VECTOR(3 downto 0):= "0000";
begin
process (Cen, CLK, RST)
 begin
 if RST = '1' then 
    temp <= "0000";
    B <= "0000";
 elsif (CLK'event and CLK='1') then
         if (Cen = '1') then
            temp <= temp + "0001";
            B <= temp;
         end if;
 end if;
  
 end process;

end Behavioral;