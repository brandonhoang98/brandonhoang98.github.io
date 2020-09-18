library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Function f from fig. 5.7 to generate check bits k

  entity sec_func is
	port(m : in std_logic_vector(7 downto 0);
		  k : out std_logic_vector(3 downto 0));
end sec_func;

architecture behavioral of sec_func is

begin
	--******************************************
	-- TO DO: Create the function that obtains 
	--		  the k bits from data-in m
	-- HINT:  This can be done concurrently
	--******************************************
	k(0) <=	m(0) xor m(1) xor m(3) xor m(4) xor m(6);
	k(1) <= 	m(0) xor m(2) xor m(3) xor m(5) xor m(6);
	k(2) <= 	m(1) xor m(2) xor m(3) xor m(7);
	k(3) <= 	m(4) xor m(5) xor m(6) xor m(7);

end behavioral;
