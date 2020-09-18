library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ScanFF is
    Port ( clk : in std_logic;
           rst : in std_logic;
           sel : in std_logic;
		 feed : in std_logic;
           input : in std_logic;
		 scan : in std_logic;
		 outScan : out std_logic;
           output : out std_logic
		   );
end ScanFF;

architecture Behavioral of ScanFF is
-- if doesn't work, add feedback wire 

begin
    process (clk, rst)
    begin
	 if (rst = '1')   then
	 	output <= '0';
	 elsif ( rising_edge(clk))  then
		if ( sel = '0') then
				output <= input;
		elsif (sel = '1') then
				outScan <= feed;
				output <= scan;
		end if;
	 end if;

    end process;

end Behavioral;
