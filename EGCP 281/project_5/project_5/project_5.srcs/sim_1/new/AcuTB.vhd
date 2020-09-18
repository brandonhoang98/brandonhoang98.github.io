----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/08/2017 12:09:15 PM
-- Design Name: 
-- Module Name: AcuTB - Behavioral
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

entity AcuTB is
   
end AcuTB;

architecture Behavioral of AcuTB is
    component AcuData is
        Port ( Bin : in STD_LOGIC_VECTOR (3 downto 0);
              OpCode : in STD_LOGIC_VECTOR (2 downto 0);
              CLK1 : in STD_LOGIC;
              RST1 : in STD_LOGIC;
              O : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    
    signal bin: STD_LOGIC_VECTOR(3 downto 0);
    signal opcode: STD_LOGIC_VECTOR(2 downto 0);
    signal clk1, rst1: STD_LOGIC;
    signal o: STD_LOGIC_VECTOR(6 downto 0);
begin
    dut: AcuData port map(
        Bin => bin,
        OpCode => opcode,
        CLK1 => clk1,
        RST1 => rst1,
        O => o
    );
    process
    begin
        bin <= "0000";
        opcode <= "000";
        clk1 <= '0';
        rst1 <= '1';
        wait for 10 ns;
        clk1 <= '1';
        wait for 10 ns;
        clk1 <= '0';
        rst1 <= '0';
        bin <= "0001";
        wait for 10 ns;
        
        clk1 <= '1';
        wait for 10ns;
        
        wait;
    end process;
end Behavioral;
