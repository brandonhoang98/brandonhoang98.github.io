
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RE_DFF is
    Port ( D : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           SET : in STD_LOGIC;
           CE : in STD_LOGIC;
           Q : out STD_LOGIC);
end RE_DFF;

architecture Behavioral of RE_DFF is


begin
    process (CLK)
    begin
    if (rising_edge(CLK)) then
        if (RST = '1') then
            Q <= '0';
        elsif (SET = '1') then
             Q <= '1';
        elsif (CE = '1') then
             Q <= D;
        end if;
    end if;
    end process;

end Behavioral;
