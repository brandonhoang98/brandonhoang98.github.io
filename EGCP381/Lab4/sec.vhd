library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity sec is
	port(data_in : in std_logic_vector(11 downto 0);
		 syndrome : out std_logic_vector(3 downto 0);
		 data_out : out std_logic_vector(7 downto 0);
		 err : out std_logic);
end sec;

architecture struct of sec is
	component sec_func
		port(m : in std_logic_vector(7 downto 0);
			  k : out std_logic_vector(3 downto 0));
	end component;

	component sec_compare
		port(k, kp : in std_logic_vector(3 downto 0);
			  syndrome : out std_logic_vector(3 downto 0);
			  err : out std_logic);
	end component;

	component sec_corrector
		port(m : in std_logic_vector(7 downto 0);
			  syndrome : in std_logic_vector(3 downto 0);
			  mp : out std_logic_vector(7 downto 0));
	end component;

	signal ksig: std_logic_vector(3 downto 0);
	signal msig: std_logic_vector(7 downto 0);
	signal kq: std_logic_vector(3 downto 0);
	signal syndromeSig: std_logic_vector(3 downto 0); 
begin
	--******************************************
	-- TO DO: Separate data-in to m and k
	--******************************************
	ksig(1 downto 0) <= data_in(1 downto 0);
	ksig(2) <= data_in(3);
	ksig(3) <= data_in(7);	
	
	msig(0) <= data_in(2);
	msig(3 downto 1) <= data_in(6 downto 4);
	msig(7 downto 4) <= data_in(11 downto 8);
	--******************************************
	-- TO DO: Send m through f to get k'
	--******************************************
	FUNC: sec_func port map (msig, kq);

	--******************************************
	-- TO DO: Compare k and k', get error signal
	--******************************************
	COMPARE: sec_compare port map (ksig, kq, syndromeSig, err);
	
	--******************************************
	-- TO DO: Correct data
	--******************************************
	CORRECT: sec_corrector port map (msig, syndromeSig, data_out);
	

	--******************************************
	-- TO DO: Set output signals
	--******************************************
	syndrome <= syndromeSig;

	

end struct;
