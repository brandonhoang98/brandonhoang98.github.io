

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SinDigWatch is
    Port ( BTN1 : in STD_LOGIC;
           BTN2 : in STD_LOGIC;
           BTN3 : in STD_LOGIC;
           ClkPin : in STD_LOGIC;
           BTN4 : in STD_LOGIC;
           OutSeven : out STD_LOGIC_VECTOR (6 downto 0));
end SinDigWatch;

architecture Behavioral of SinDigWatch is
    component Controller is
        Port ( Start : in STD_LOGIC;
               Stop : in STD_LOGIC;
               CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               Inc : in STD_LOGIC;
               Run : out STD_LOGIC);
        end component;
    component FourBitCounter is
        Port ( Cen: in STD_LOGIC;
               CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               B : inout STD_LOGIC_VECTOR (3 downto 0));
        end component;
    component SevenDD_d is 
        Port ( I : in STD_LOGIC_VECTOR (3 downto 0);
               O : out STD_LOGIC_VECTOR (6 downto 0));
        end component;
    component Clock_Divider is
        Port ( CLKin : in STD_LOGIC;
               CLKout : out STD_LOGIC;
               RESET : in STD_LOGIC);
        end component;
   signal a1, a2: STD_LOGIC;
   signal b1: STD_LOGIC_VECTOR(3 downto 0);
begin
    CNTRL: Controller port map (BTN1, BTN2, a1, BTN4, BTN3, a2 );
    FBC: FourBitCounter port map (a2 , a1, BTN4, b1);
    SEVDD: SevenDD_d port map (b1 ,OutSeven);
    CLKDV: Clock_Divider port map (ClkPin, a1, BTN4);

end Behavioral;
