

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity p1 is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           C : in STD_LOGIC;
           notG: out STD_LOGIC;
           orG: out STD_LOGIC;
           orG2: out STD_LOGIC;
           orG3: out STD_LOGIC;
           Y : out STD_LOGIC);
end p1;
    
architecture Behavioral of p1 is
    signal a1, b1, c1, d1: STD_LOGIC;
begin
    notG <= (not A) after 1ns;
    a1 <=  (not A) after 1ns;
    orG <= A or B after 1ns;
    b1 <= A or B after 1ns;
    orG2 <= a1 or C after 1ns;
    c1 <= a1 or C after 1ns;
    orG3 <= B or C after 1ns;
   d1 <= B or C after 1ns;
   Y <= b1 and c1 and d1 after 1ns;

end Behavioral;
