

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity AcuData is
    Port ( Bin : in STD_LOGIC_VECTOR (3 downto 0);
           OpCode : in STD_LOGIC_VECTOR (2 downto 0);
           CLK1 : in STD_LOGIC;
           O : out STD_LOGIC_VECTOR (6 downto 0);
           RST1 : in STD_LOGIC);
end AcuData;

architecture Behavioral of AcuData is
    component Clock_Divider is
        Port ( CLKin : in STD_LOGIC;
               CLKout : out STD_LOGIC;
               RESET : in STD_LOGIC);
    end component;
    component Reg_ff is
        Port ( D : in STD_LOGIC_VECTOR(3 downto 0);
               CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               Q : out STD_LOGIC_VECTOR(3 downto 0));
    end component;
        
    component SevenDD_d is
        Port ( I : in STD_LOGIC_VECTOR (3 downto 0);
              O : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    
    component ALU_d is
          Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
             B : in STD_LOGIC_VECTOR (3 downto 0);
             Sel : in STD_LOGIC_VECTOR (2 downto 0);
             Y : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    signal a1, a2: STD_LOGIC_VECTOR (3 downto 0);
    signal b1: STD_LOGIC;
begin
    CLKDV: Clock_Divider port map ( CLK1, b1, RST1);
    REG: Reg_ff port map (a1, b1, RST1, a2);
    ALU: ALU_d port map (a2 , Bin, OpCode, a1);
    SEVDD: SevenDD_d port map (a2 , O);
    
end Behavioral;
