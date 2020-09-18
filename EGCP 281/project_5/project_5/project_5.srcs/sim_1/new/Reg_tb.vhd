
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg_tb is
   
end Reg_tb;
architecture Behavioral of Reg_tb is
    component Reg_ff is
        Port ( D : in STD_LOGIC_VECTOR(3 downto 0);
               CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               Q : out STD_LOGIC_VECTOR(3 downto 0));
               
               
    end component;
    signal d, q: STD_LOGIC_VECTOR(3 downto 0);
    signal clk, rst: STD_LOGIC;
begin
    dut: Reg_ff port map (
        D => d,
        CLK => clk,
        RST => rst,
        Q => q
    );
    process
    begin
        d <= "0000";
        clk <= '0';
        rst <= '0';
    wait for 10 ns;
        d <= "1000";
        clk <= '1';
    wait for 10 ns;
        clk <= '0';
        rst <= '1';
    wait for 10 ns;
        clk <= '1';
    wait for 10 ns;
        clk <= '0';
        rst <= '0';
    wait for 10 ns;
        clk <= '1';
    wait for 10 ns;
    wait;
    end process;

end Behavioral;
