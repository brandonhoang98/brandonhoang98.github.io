library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Function f from fig. 5.7 to generate check bits k

  entity sec_func is
	port(min : in std_logic_vector(3 downto 0);
		clk : in std_logic;
		rst : in std_logic; 
		sel : in std_logic;
		scanin : in std_logic;
		scanbits : out std_logic_vector(3 downto 0);
		dataout: out std_logic_vector(6 downto 0);
		scanout : out std_logic);
end sec_func;

architecture behavioral of sec_func is

	component ScanFF is 
		Port ( clk : in std_logic;
           rst : in std_logic;
           sel : in std_logic;
		 feed : in std_logic;
           input : in std_logic;
		 scan : in std_logic;
		 outScan : out std_logic;
           output : out std_logic
		   );
	end component;
	signal m : std_logic_vector(3 downto 0);
	signal mS : std_logic_vector ( 3 downto 0);
	signal k : std_logic_vector (2 downto 0);
begin
	--******************************************
	-- TO DO: Create the function that obtains 
	--		  the k bits from data-in m
	-- HINT:  This can be done concurrently
	--******************************************
	FF4: ScanFF port map(clk, rst, sel, m(3), min(3), scanin, mS(3), m(3));
	FF3: ScanFF port map(clk, rst, sel, m(2), min(2), mS(3), mS(2), m(2));
	FF2: ScanFF port map(clk, rst, sel, m(1), min(1), mS(2), mS(1),m(1));
	FF1: ScanFF port map(clk, rst, sel, m(0), min(0), mS(1), mS(0), m(0));
	
	scanbits <= mS;
	scanout <= mS(0);
	process ( clk, rst )
	begin

	if ( rst = '1') then 
	k <= "000";
	elsif (rising_edge(clk)) then
	if ( sel = '0' ) then
	k(0) <=	m(0) xor m(1) xor m(3);
	k(1) <= 	m(0) xor m(2) xor m(3);
	k(2) <= 	m(1) xor m(2) xor m(3);
	end if;
	dataout(1 downto 0) <= k(1 downto 0);
	dataout(2) <= m(0);
	dataout(3) <= k(2);
	dataout(6 downto 4) <= m(3 downto 1);
	
	end if;
	end process;
end behavioral;
