library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Full_Adder is
	Port ( a : in std_logic;
           b : in std_logic;
           cin : in std_logic;
           s : out std_logic;
           cout : out std_logic);
end Full_Adder;

architecture Behavioral of Full_Adder is
	component Half_adder
	Port ( a : in std_logic;
           b : in std_logic;
           s : out std_logic;
           cout : out std_logic);
	end component;
	signal one, two, three: std_logic;
begin
	HA1:	Half_adder port map (a ,b , one, two); 
	HA2:	Half_adder port map (one, cin, s, three);
	cout <= two or three;
end Behavioral;
