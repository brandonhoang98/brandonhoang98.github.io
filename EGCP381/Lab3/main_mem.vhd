library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.definitions.all;

entity main_mem is
	generic (
		ADDR_WIDTH : integer := main_mem_adr_width;
		DATA_WIDTH : integer := main_mem_data_width
	);
	
	port (
			clk, rst : in std_logic;
			addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
			data_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
			);
end main_mem;

architecture behavioral of main_mem is
	type ram_type is array (2**ADDR_WIDTH-1 downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0);
	signal ram : ram_type;
	signal addr_reg : std_logic_vector (ADDR_WIDTH-1 downto 0);

begin
	process(clk, rst)
	begin
		if (rst = '1') then
			-- Stores the address in the location
			for i1 in 0 to 2**ADDR_WIDTH-1 loop
				ram(i1) <= conv_std_logic_vector(i1,main_mem_data_width);
			end loop;			
		elsif(rising_edge(clk)) then
			addr_reg <= addr;
		end if;
	end process;
	
	data_out <= ram(conv_integer(addr_reg));
	
end behavioral;


