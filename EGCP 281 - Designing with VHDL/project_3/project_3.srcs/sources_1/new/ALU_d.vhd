
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity ALU_d is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Sel : in STD_LOGIC_VECTOR (2 downto 0);
           Y : out STD_LOGIC_VECTOR (3 downto 0));
end ALU_d;

architecture Behavioral of ALU_d is

begin
    with Sel select
    Y <= A + B when "000",
         A + "0001" when "001",
         A - B when "010",
         "0000" when "011",
         (A xor B) when "100",
         (not(A)) when "101",
         (A or B) when "110",
         (A and B) when others;
         
end Behavioral;
