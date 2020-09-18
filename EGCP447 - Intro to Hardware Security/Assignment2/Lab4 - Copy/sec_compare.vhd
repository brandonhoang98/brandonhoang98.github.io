library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity sec_compare is
	port(k, kp : in std_logic_vector(2 downto 0);
		  syndrome : out std_logic_vector(2 downto 0);
		  err : out std_logic);
end sec_compare;

architecture behavioral of sec_compare is	
begin	
	process(k, kp)
	begin
		--******************************************
		-- TO DO: Determine if an error has occurred
		--******************************************
		if (not(k = kp)) then
			err <= '1';
		else
			err <= '0';
		end if;
	end process;
	--******************************************
	-- TO DO: Determine the check bits
	--*****************************************
		syndrome(2) <= k(2) xor kp(2);
		syndrome(1) <= k(1) xor kp(1);
		syndrome(0) <= k(0) xor kp(0);
		
end behavioral;
