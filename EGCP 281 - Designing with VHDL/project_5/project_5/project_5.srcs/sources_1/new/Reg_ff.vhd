
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg_ff is
    Port ( D : in STD_LOGIC_VECTOR(3 downto 0);
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(3 downto 0));
end Reg_ff;

architecture Behavioral of Reg_ff is
begin
    process (CLK, RST)
    begin
    if (RST = '1') then
                Q <= "0000";
    elsif (rising_edge(CLK)) then
             Q(0) <= D(0);
             Q(1) <= D(1);
             Q(2) <= D(2);
             Q(3) <= D(3);
    end if;
    end process;


end Behavioral;
