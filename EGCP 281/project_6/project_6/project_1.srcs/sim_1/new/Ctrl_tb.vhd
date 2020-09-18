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
    
    
    
    
    
    wait;
    end process;

end Behavioral;
