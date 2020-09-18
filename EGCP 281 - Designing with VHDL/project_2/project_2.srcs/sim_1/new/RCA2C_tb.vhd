----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/20/2017 12:34:58 PM
-- Design Name: 
-- Module Name: RCA2C_tb - Behavioral
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

entity RCA2C_tb is
end RCA2C_tb;

architecture Behavioral of RCA2C_tb is
    component RCA2C
    Port   (a : in STD_LOGIC_VECTOR (3 downto 0);
            b : in STD_LOGIC_VECTOR (3 downto 0);
            c : in STD_LOGIC;
            s : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    signal A: STD_LOGIC_VECTOR (3 downto 0);
    signal B: STD_LOGIC_VECTOR (3 downto 0);
    signal C: STD_LOGIC;
    signal S: STD_LOGIC_VECTOR (3 downto 0);
    
begin
    dut : RCA2C port map (
    a => A,
    b => B,
    c => C,
    s => S
    );
    process
    begin
        --one
        wait for 100ns;
        A <= "1000";
        B <= "1000";
        C <= '1';
        --two
        wait for 100ns;
        A <= "1001";
        B <= "1011";
        C <= '0';
        --three
        wait for 100ns;
        A <= "0010";
        B <= "0111";
        C <= '1';
        --four
        wait for 100ns;
        A <= "1011";
        B <= "0001";
        C <= '0';
        --five
        wait for 100ns;
        A <= "0100";
        B <= "0001";
        C <= '1';
    wait;
    end process;

end Behavioral;
