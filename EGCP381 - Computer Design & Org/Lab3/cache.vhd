library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.definitions.all;

entity cache is
	generic (
		LINE_WIDTH : integer := cache_line_width;
		DATA_WIDTH : integer := cache_data_width
	);
	
	port (
			clk, rst : in std_logic;
			we : in std_logic;
			line : in std_logic_vector(LINE_WIDTH-1 downto 0);
			data_in : in std_logic_vector(DATA_WIDTH-1 downto 0);
			data_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
			);
end cache;

architecture behavioral of cache is
	type ram_type is array (2**LINE_WIDTH-1 downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0);
	signal cache : ram_type;
	signal line_reg : std_logic_vector (LINE_WIDTH-1 downto 0);

begin
	process(clk, rst)
	begin
		if (rst = '1') then
			-- Clear
			for i1 in 0 to 2**LINE_WIDTH-1 loop
				cache(i1) <= (others => '0');
			end loop;			
		elsif(rising_edge(clk)) then
			if (we = '1') then
				cache(conv_integer(line)) <= data_in;
			end if;
			line_reg <= line;
		end if;
	end process;
	
	data_out <= cache(conv_integer(line_reg));
	
end behavioral;


