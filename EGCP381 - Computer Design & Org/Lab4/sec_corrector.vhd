library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sec_corrector is
	port(m : in std_logic_vector(7 downto 0);
		  syndrome : in std_logic_vector(3 downto 0);
		  mp : out std_logic_vector(7 downto 0));
end sec_corrector;

architecture behavioral of sec_corrector is
begin
	process(m,syndrome)
	begin
		--******************************************
		-- TO DO: If there is an error, correct the 
		--        bit
		-- HINT:  A case-when statement is 
		--        convenient for this!
		--******************************************
		case syndrome is
			when "0000" =>
				mp <= m;
			when "0001" =>
				mp <= m;
			when "0010" =>
				mp <= m;
			when "0011" =>
				mp <= m;
				mp(0) <= not(m(0));
			when "0100" =>
				mp <= m;
			when "0101" =>
				mp <= m;
				mp(1) <= not(m(1));
			when "0110" =>
				mp <= m;
				mp(2) <= not(m(2));
			when "0111" =>
				mp <= m;
				mp(3) <= not(m(3));
			when "1000" =>
				mp <= m;
			when "1001" =>
				mp <= m;
				mp(4) <= not(m(4));
			when "1010" =>
				mp <= m;
				mp(5) <= not(m(5));
			when "1011" =>
				mp <= m;
				mp(6) <= not(m(6));
			when "1100" =>
				mp <= m;
				mp(7) <= not(m(7));
			when others =>
				mp <= m;
		end case;

	end process;

end behavioral;
