----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/18/2017 12:33:17 PM
-- Design Name: 
-- Module Name: p1_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity p1_tb is

end p1_tb;

architecture Behavioral of p1_tb is
    component p1 is
        Port ( A : in STD_LOGIC;
              B : in STD_LOGIC;
              C : in STD_LOGIC;
               notG: out STD_LOGIC;
             orG: out STD_LOGIC;
              orG2: out STD_LOGIC;
              orG3: out STD_LOGIC;
              Y : out STD_LOGIC);
    end component;
    
    signal a, b, c, nG, anG1, anG2, anG3, y: STD_LOGIC;
begin
    dut: p1 port map(
        A => a,
        B => b,
        C => c,
        notG => nG,
        orG => anG1,
        orG2 => anG2,
        orG3 => anG3,
        Y => y
    );
    process
    begin
        a <= '0';
        b <= '0';
        c <= '0';
        wait for 10ns;
        a <= '1';
        b <= '0';
        c <= '0';
        wait for 10ns;
        a <= '0';
        b <= '0';
        c <= '0';
        wait for 10ns;
        a <= '0';
        b <= '1';
        c <= '1';
        wait for 10ns;
         a <= '1';
        b <= '1';
        c <= '1';
        wait for 10ns;
        a <= '0';
        b <= '1';
        c <= '1';
         wait for 10ns;
        a <= '1';
        b <= '0';
        c <= '0';
        wait for 10ns;
        a <= '1';
        b <= '0';
        c <= '1';
        wait for 10ns;
        a <= '1';
        b <= '1';
        c <= '0';
        wait for 10ns;
        a <= '1';
        b <= '1';
        c <= '1';
        wait for 10ns;
    wait;
    end process;

end Behavioral;
