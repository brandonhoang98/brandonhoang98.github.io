----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/20/2017 12:16:33 PM
-- Design Name: 
-- Module Name: RCA2C - Behavioral
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

entity RCA2C is
    Port ( a : in STD_LOGIC_VECTOR (3 downto 0);
           b : in STD_LOGIC_VECTOR (3 downto 0);
           c : in STD_LOGIC;
           s : out STD_LOGIC_VECTOR (3 downto 0));
end RCA2C;

architecture Behavioral of RCA2C is
    component FullAdder
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Cin : in STD_LOGIC;
           S : out STD_LOGIC;
           Cout : out STD_LOGIC);
           
    end component;
    
    signal B0, B1, B2, B3, c1, c2, c3, c4: STD_LOGIC;
    
begin
        B0 <= b(0) XOR c;
        B1 <= b(1) XOR c;
        B2 <= b(2) XOR c;
        B3 <= b(3) XOR c;
    FA1: FullAdder port map ( a(0), B0, c, s(0), c1);
    FA2: FullAdder port map ( a(1), B1, c1, s(1), c2);
    FA3: FullAdder port map ( a(2), B2, c2, s(2), c3);
    FA4: FullAdder port map ( a(3), B3, c3, s(3), c4);

end Behavioral;
