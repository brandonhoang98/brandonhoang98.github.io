----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2017 12:30:30 PM
-- Design Name: 
-- Module Name: Ctrl_tb - Behavioral
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

entity Ctrl_tb is
end Ctrl_tb;

architecture Behavioral of Ctrl_tb is
    component Controller is
         Port ( Start : in STD_LOGIC;
              Stop : in STD_LOGIC;
              CLK : in STD_LOGIC;
              RST : in STD_LOGIC;
              Inc : in STD_LOGIC;
              Run : out STD_LOGIC);
         end component;
         signal start, stop, clk, rst, inc, run: STD_LOGIC;
begin
    dut: Controller port map (
        Start => start,
        Stop => stop,
        CLK => clk,
        RST => rst,
        Inc => inc,
        Run => run
    );
    process
    begin
        start <= '0';
        stop <= '0';
        clk <= '0';
        rst <= '0';
        inc <= '0';
        wait for 50ns;
        clk <= '1';
        wait for 50ns;
        clk <= '0';
        start <= '1';
        wait for 50ns;
        clk <= '1';
        stop <= '0';
        start <= '0';
        wait for 50ns;
        stop <= '1';
        wait for 50ns;
        stop <= '0';
        clk <= '0';
        inc <= '1';
        wait for 50ns;
        clk <= '1';
        wait for 50ns;
        start <= '1';
        clk <= '0';
        wait for 50ns;
        clk <= '1';
        wait for 50ns;
        rst <= '1';
    
    
    
    wait;
    end process;

end Behavioral;
