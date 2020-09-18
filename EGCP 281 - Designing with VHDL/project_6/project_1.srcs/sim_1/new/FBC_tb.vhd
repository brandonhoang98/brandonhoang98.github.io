----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2017 12:33:33 PM
-- Design Name: 
-- Module Name: FBC_tb - Behavioral
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

entity FBC_tb is
   
end FBC_tb;

architecture Behavioral of FBC_tb is
    component FourBitCounter is
     Port ( Cen : in STD_LOGIC;
          CLK : in STD_LOGIC;
          RST : in STD_LOGIC;
          B : out STD_LOGIC_VECTOR (3 downto 0));
     end component;
     signal cen, clk, rst: STD_LOGIC;
     signal b: STD_LOGIC_VECTOR(3 downto 0);
begin
    dut: FourBitCounter port map (
    Cen => cen,
    CLK => clk,
    RST => rst,
    B => b
    );
    process
    begin
        cen <= '1';
        clk <= '0';
        rst <= '0';
        wait for 10ns;
        clk <= '1';
        wait for 10ns;
        clk <= '0';
        wait for 10ns;
        clk <= '1';
                wait for 10ns;
                clk <= '0';
                wait for 10ns;
                clk <= '1';
                        wait for 10ns;
                        clk <= '0';
                        wait for 10ns;
                        clk <= '1';
                                wait for 10ns;
                                clk <= '0';
                                wait for 10ns;
                                clk <= '1';
                                        wait for 10ns;
                                        clk <= '0';
                                        wait for 10ns;
                                        rst <= '1';
                                        
    wait;
    end process;

end Behavioral;
