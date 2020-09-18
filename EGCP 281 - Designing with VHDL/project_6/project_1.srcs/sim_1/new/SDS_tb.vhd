----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/29/2017 12:35:57 PM
-- Design Name: 
-- Module Name: SDS_tb - Behavioral
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

entity SDS_tb is
    
end SDS_tb;

architecture Behavioral of SDS_tb is
    component SinDigWatch is
    Port ( BTN1 : in STD_LOGIC;
               BTN2 : in STD_LOGIC;
               BTN3 : in STD_LOGIC;
               ClkPin : in STD_LOGIC;
               BTN4 : in STD_LOGIC;
               OutSeven : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    signal btn1, btn2, btn3, clkpin, btn4: STD_LOGIC;
    signal outseven: STD_LOGIC_VECTOR(6 downto 0);
begin
    -- Start
    -- Stop
    -- Increment
    -- CLK
    -- Reset
    dut: SinDigWatch port map (
        BTN1 => btn1,
        BTN2 => btn2,
        BTN3 => btn3,
        ClkPin => clkpin,
        BTN4 => btn4,
        OutSeven => outseven
    );
    process
    begin
        btn1 <= '1';
        btn2 <= '0';
        btn3 <= '0';
        clkpin <= '0';
        btn4 <= '0';
        wait for 10 ns;
        clkpin <= '1';
        wait for 10 ns;
        clkpin <= '0';
        wait for 10ns;
        clkpin <= '1';
        wait for 10 ns;
        clkpin <= '0';
        wait for 10ns;
        clkpin <= '1';
        wait for 10 ns;
        clkpin <= '0';
        wait for 10ns;
        clkpin <= '1';
    
    wait;
    end process;
end Behavioral;
