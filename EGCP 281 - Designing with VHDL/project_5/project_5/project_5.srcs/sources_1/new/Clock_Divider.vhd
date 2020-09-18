library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity Clock_Divider is
    Port ( CLKin : in STD_LOGIC;
           CLKout : out STD_LOGIC;
           RESET : in STD_LOGIC);
end Clock_Divider;

architecture Behavioral of Clock_Divider is

constant clkOriginal : STD_LOGIC_VECTOR (26 downto 0 ) := "101111101011110000100000000";
signal clkValue: STD_LOGIC_VECTOR (26 downto 0);
begin

process (CLKin, RESET)
    begin
    if RESET = '1' then clkValue <= "000000000000000000000000000";
        elsif (CLKin'event and CLKin ='1') then
            if (clkValue = clkOriginal) then clkValue <= "000000000000000000000000000";
                else clkValue <= (clkValue + 1);
                end if;
            end if;
        end process;
       
        CLKout <= clkValue(26);
end Behavioral;
