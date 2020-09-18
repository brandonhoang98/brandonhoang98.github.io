library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LFSR is
    Port ( clk : in STD_LOGIC;
           InitEN : in STD_LOGIC;
           InitVal : in STD_LOGIC_VECTOR(2 downto 0);
           Q : out STD_LOGIC_VECTOR(2 downto 0)
           );
end LFSR;

architecture Behavioral of LFSR is
    component LFSRFF is
    Port ( clk : in STD_LOGIC;
           InitEN : in STD_LOGIC;
           InitVal : in STD_LOGIC;
           D : in STD_LOGIC;
           Q : out STD_LOGIC
           );
    end component;
    signal q1, q2, q3, xor1 : std_logic;
begin
	FF0: LFSRFF port map (clk, InitEN, InitVal(0), q3, q1 );
	xor1 <= q1 xor q3;
	FF1: LFSRFF port map (clk, InitEN, InitVal(1), xor1, q2);
	FF2: LFSRFF port map (clk, InitEN, InitVal(2), q2, q3);
	Q(0) <= q1;
	Q(1) <= q2;
	Q(2) <= q3;
end Behavioral;