----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/20/2017 11:16:20 AM
-- Design Name: 
-- Module Name: RCA_tb - Behavioral
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

entity RCA_tb is
end RCA_tb;

architecture Behavioral of RCA_tb is
    component RCA 
        Port ( a : in STD_LOGIC_VECTOR (3 downto 0);
       b : in STD_LOGIC_VECTOR (3 downto 0);
       cin : in STD_LOGIC;
       s : out STD_LOGIC_VECTOR (4 downto 0));
       end component;
       signal A: STD_LOGIC_VECTOR (3 downto 0);
       signal B: STD_LOGIC_VECTOR (3 downto 0);
       signal Cin: STD_LOGIC;
       signal S: STD_LOGIC_VECTOR ( 4 downto 0);
       
begin
    dut: RCA port map (
    a => A,
    b => B,
    cin => Cin,
    s => S
    );
    process
    begin
            wait for 100ns;
        -- one
            A <= "1000";
            B <= "0110";
            Cin <= '0';
            wait for 100ns; 
        -- two
            A <= "0110";
            B <= "1100";
            wait for 100ns;
        -- three
            A <= "0100";
            B <= "0101";
            wait for 100ns;
        -- four 
            A <= "0011";
            B <= "1011";
            wait for 100ns;
        -- five
            A <= "1010";
            B <= "0101";
    wait;
    end process;
    

end Behavioral;
