----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2017 11:50:00 AM
-- Design Name: 
-- Module Name: DFF_TB - Behavioral
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

entity DFF_TB is
    
end DFF_TB;

architecture Behavioral of DFF_TB is
    component RE_DFF is
        Port ( D : in STD_LOGIC;
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            SET : in STD_LOGIC;
            CE : in STD_LOGIC;
            Q : out STD_LOGIC);
    end component;
    signal d, clk, rst, set, ce, q: STD_LOGIC;
begin
    dut: RE_DFF port map (
        D => d,
        CLK => clk,
        RST => rst,
        SET => set,
        CE => ce,
        Q => q
    );  
    process
    begin
        d <= '0';
        ce <= '1';
        clk <= '0';
        rst <= '0';
        set <= '0';
        wait for 10 ns;
        d <= '1';
        clk <= '1';
        wait for 10 ns;
        clk <= '0';
        d <= '0';
        wait for 10 ns;
        clk <= '1';
        ce <= '0';
        wait for 10ns;
        clk <= '0';
        rst <= '1';
        wait for 10ns;
        clk <= '1';
        wait for 10ns;
        clk <= '0';
        rst <= '0';
        set <= '1';
        ce <= '1';
        wait for 10ns;
        clk <= '1';
        wait for 10ns;
        ce <= '0';
        set <= '0';
        rst <= '1';
        clk <= '0';
        wait for 10ns;
        clk <= '1';
    wait;
    end process;
end Behavioral;
