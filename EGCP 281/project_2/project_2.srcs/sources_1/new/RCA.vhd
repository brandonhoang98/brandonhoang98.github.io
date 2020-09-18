----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/13/2017 11:47:51 AM
-- Design Name: 
-- Module Name: RCA - Behavioral
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

entity RCA is
    Port ( a : in STD_LOGIC_VECTOR(3 downto 0);
           b : in STD_LOGIC_VECTOR(3 downto 0);
           cin : in STD_LOGIC;          
           s : out STD_LOGIC_VECTOR(4 downto 0) );
end RCA;

architecture Behavioral of RCA is
    component FullAdder
    Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           cin : in STD_LOGIC;
           s : out STD_LOGIC;
           cout : out STD_LOGIC);
           
    end component;
    
    signal c1, c2, c3: STD_LOGIC;
begin
    
    FA1: FullAdder port map( a(0), b(0), cin, s(0), c1);
    FA2: FullAdder port map( a(1), b(1), c1, s(1), c2);
    FA3: FullAdder port map( a(2), b(2), c2, s(2), c3);
    FA4: FullAdder port map( a(3), b(3), c3, s(3), s(4));
  
end Behavioral;
