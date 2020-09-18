library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Half_adder is
	Port ( a : in std_logic;
           b : in std_logic;
           s : out std_logic;
           cout : out std_logic);
end Half_adder;

architecture Behavioral of Half_adder is

begin
   s <= a xor b;
   cout <= a and b;

end Behavioral;
