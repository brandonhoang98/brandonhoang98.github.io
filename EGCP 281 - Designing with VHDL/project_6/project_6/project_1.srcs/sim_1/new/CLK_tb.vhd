----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2017 11:33:45 AM
-- Design Name: 
-- Module Name: CLK_tb - Behavioral
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

entity CLK_tb is
    
end CLK_tb;

architecture Behavioral of CLK_tb is
    component Clock_Divider is
        Port ( CLKin : in STD_LOGIC;
               CLKout : out STD_LOGIC;
               RESET : in STD_LOGIC);
    end component;
    signal clkin, clkout, reset: STD_LOGIC;
begin
    dut: Clock_Divider port map (
        CLKin => clkin,
        CLKout => clkout,
        RESET => reset
    );
    process
    begin
        clkin <= '0';
        reset <= '0';
        wait for 50 ns;
        clkin <= '1';
        wait for 50ns;
        reset <= '1';
        clkin <= '1';
        wait for 50ns;
        
    
    wait;
    end process;
end Behavioral;
