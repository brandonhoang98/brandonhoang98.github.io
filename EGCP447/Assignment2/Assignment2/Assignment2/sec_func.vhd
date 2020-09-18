library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Function f from fig. 5.7 to generate check bits k

  entity sec_func is
	port(m : in std_logic_vector(3 downto 0);
		clk : in std_logic;
		rst : in std_logic; 
		dataout : out std_logic_vector(6 downto 0));
end sec_func;

architecture behavioral of sec_func is

	signal k : std_logic_vector (2 downto 0);
begin
	--******************************************
	-- TO DO: Create the function that obtains 
	--		  the k bits from data-in m
	-- HINT:  This can be done concurrently
	--******************************************
	process ( clk, rst )
	begin
	if ( rst = '1') then 
		k <= "000";
	elsif (rising_edge(clk)) then
		k(0) <=	m(0) xor m(1) xor m(3);
		k(1) <= 	m(0) xor m(2) xor m(3);
		k(2) <= 	m(1) xor m(2) xor m(3);
		dataout(1 downto 0) <= k(1 downto 0);
		dataout(2) <= m(0);
		dataout(3) <= k(2);
		dataout(6 downto 4) <= m(3 downto 1);
	end if;
	
	
	end process;
end behavioral;
