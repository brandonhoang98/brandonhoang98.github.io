
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SevenDD_tb is
end SevenDD_tb;

architecture Behavioral of SevenDD_tb is
    component SevenDD_d 
    Port (I: in STD_LOGIC_VECTOR(3 downto 0);
    O: out STD_LOGIC_VECTOR(6 downto 0)
    );
    end component;  
    Signal i: STD_LOGIC_VECTOR(3 downto 0);
    Signal o: STD_LOGIC_VECTOR(6 downto 0);
    
begin
    dut: SevenDD_d port map (
        I => i,
        O => o
    );
    process 
    begin
        i <= "0000";
        wait for 10ns;
        i <= "0001";
        wait for 10ns;
        i <= "0010";
        wait for 10ns;
        i <= "0011";
        wait for 10ns;
        i <= "0100";
        wait for 10ns;
        i <= "0101";
        wait for 10ns;
        i <= "0110";
        wait for 10ns;
        i <= "0111";
        wait for 10ns;
        i <= "1000";
        wait for 10ns;
        i <= "1001";
        wait for 10ns;
        i <= "1010";
        wait for 10ns;
        i <= "1011";
        wait for 10ns;
        i <= "1100";
        wait for 10ns;
        i <= "1101";
        wait for 10ns;
        i <= "1110";
        wait for 10ns;
        i <= "1111";
    wait;
    end process;
end Behavioral;
