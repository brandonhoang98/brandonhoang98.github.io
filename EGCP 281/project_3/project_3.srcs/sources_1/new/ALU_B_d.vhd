

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.all;

entity ALU_B_d is
    Port ( IA: in STD_LOGIC_VECTOR (3 downto 0);
           IB: in STD_LOGIC_VECTOR (3 downto 0);
           ISel: in STD_LOGIC_VECTOR (2 downto 0);
           IO: out STD_LOGIC_VECTOR (6 downto 0));
end ALU_B_d;

architecture Behavioral of ALU_B_d is
    component SevenDD_d
     Port ( I : in STD_LOGIC_VECTOR (3 downto 0);
           O : out STD_LOGIC_VECTOR (6 downto 0));
     end component;
     
     component ALU_d
         Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
                  B : in STD_LOGIC_VECTOR (3 downto 0);
                  Sel : in STD_LOGIC_VECTOR (2 downto 0);
                  Y : out STD_LOGIC_VECTOR (3 downto 0));
        end component;
        
     signal c: STD_LOGIC_VECTOR(3 downto 0);
     
begin
    ALU: ALU_d port map(IA, IB, ISel, c);
    SevenD: SevenDD_d port map( c, IO);

end Behavioral;
