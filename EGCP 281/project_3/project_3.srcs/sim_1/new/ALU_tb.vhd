

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity ALU_tb is

end ALU_tb;

architecture Behavioral of ALU_tb is
    component ALU_d is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
               B : in STD_LOGIC_VECTOR (3 downto 0);
               Sel : in STD_LOGIC_VECTOR (2 downto 0);
               Y : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    signal a, b, y: STD_LOGIC_VECTOR (3 downto 0);
    signal sel : STD_LOGIC_VECTOR (2 downto 0);

begin
    dut: ALU_d port map (
        A => a,
        B => b,
        Sel => sel,
        Y => y
    );
    process
    begin
    a <= "0110";
    b <= "0010";
    sel <= "000";
    wait for 50ns;
    a <= "1000";
    b <= "0111";
    wait for 50ns;
    a <= "0111";
    sel <= "001";
    wait for 50ns;
    a <= "0000";
    wait for 50ns;
    sel <= "010";
    a <= "1000";
    b <= "0011";
    wait for 50ns;
    b <= "1000";
    wait for 50ns;
    sel <= "011";
    wait for 50ns;
    sel <= "100";
    a <= "0110";
    b <= "1000";
    wait for 50ns;
    a <= "0001";
    b <= "0000";
    wait for 50ns;
    a <= "0000";
    b <= "0001";
    wait for 50ns;
    sel <= "101";
    a <= "0000";
    wait for 50ns;
    a <= "0110";
    wait for 50ns;
    sel <= "110";
    a <= "0001";
    b <= "0000";
    wait for 50 ns;
    a <= "0000";
    b <= "0010";
    wait for 50ns;
    sel <= "111";
    b <= "0001";
    wait for 50ns;
    a <= "0001";
    
    wait;
    end process;

end Behavioral;
