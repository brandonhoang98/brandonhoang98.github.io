library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sec_corrector is
	port(m : in std_logic_vector(6 downto 0);
		clk, rst : in std_logic;
		err : out std_logic;
		  mp : out std_logic_vector(3 downto 0));
end sec_corrector;

architecture behavioral of sec_corrector is
	signal mSig : std_logic_vector (3 downto 0);
	signal k, kp, syndrome : std_logic_vector (2 downto 0);
begin
	mSig(0) <=m(2);
	mSig(3 downto 1) <= m(6 downto 4);
	
	k(0) <=		mSig(0) xor mSig(1) xor mSig(3);
	k(1) <= 	mSig(0) xor mSig(2) xor mSig(3);
	k(2) <= 	mSig(1) xor mSig(2) xor mSig(3);
	kp(1 downto 0) <= m(1 downto 0);
	kp(2) <= m(3);
		--******************************************
	-- TO DO: Determine the check bits
	--*****************************************
		syndrome(2) <= k(2) xor kp(2);
		syndrome(1) <= k(1) xor kp(1);
		syndrome(0) <= k(0) xor kp(0);
	process (clk, rst, syndrome)
	begin
		if ( rst = '1') then
			mp <= "0000";
		elsif (rising_edge(clk)) then
	
		case syndrome is
			when "000" =>
				mp <= mSig;
			when "001" =>
				mp <= mSig;
			when "010" =>
				mp <= mSig;
			when "011" =>
				mp <= mSig;
				mp(0) <= not(mSig(0));
			when "100" =>
				mp <= mSig;
			when "101" =>
				mp <= mSig;
				mp(1) <= not(mSig(1));
			when "110" =>
				mp <= mSig;
				mp(2) <= not(mSig(2));
			when "111" =>
				mp <= mSig;
				mp(3) <= not(mSig(3));	
			when others =>
				mp <= mSig;

		end case;
		end if;
	end process;
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

end behavioral;
