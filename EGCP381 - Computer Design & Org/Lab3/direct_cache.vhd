library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; 
use work.definitions.all;

entity direct_cache is
	port (
			clk : in std_logic;
			rst : in std_logic;
			addr : in std_logic_vector((cache_tag_width + cache_line_width + cache_word_width)-1 downto 0);
			hit : out std_logic;

			cache_we : out std_logic;
			cache_data_from : out std_logic_vector(cache_data_width-1 downto 0);
			cache_line : out std_logic_vector(cache_line_width-1 downto 0);
			cache_tag : out std_logic_vector(cache_tag_width-1 downto 0);
			cache_data_to : out std_logic_vector(cache_data_width-1 downto 0);

			main_mem_addr : out std_logic_vector(main_mem_adr_width-1 downto 0);
			main_mem_data_from : out std_logic_vector(main_mem_data_width-1 downto 0);
			
			state : out integer
		);
end direct_cache;

architecture structural of direct_cache is
	component direct_cache_ctrl is
		port (
				clk, rst : in std_logic;
				addr : in std_logic_vector((cache_tag_width + cache_line_width + cache_word_width)-1 downto 0);
				hit : out std_logic;

				cache_data_from : in std_logic_vector(cache_data_width-1 downto 0);
				cache_we : out std_logic;
				cache_line : out std_logic_vector(cache_line_width-1 downto 0);
				cache_tag : out std_logic_vector(cache_tag_width-1 downto 0);
				cache_data_to : out std_logic_vector(cache_data_width-1 downto 0);

				main_mem_data_from : in std_logic_vector(main_mem_data_width-1 downto 0);
				main_mem_addr : out std_logic_vector(main_mem_adr_width-1 downto 0);
				
				state : out integer
			);
	end component;
	
	component main_mem is
		port (
				clk, rst : in std_logic;
				addr : in std_logic_vector(main_mem_adr_width-1 downto 0);
				data_out : out std_logic_vector(main_mem_data_width-1 downto 0)
			);
	end component;
	
	component cache is
		port (
				clk, rst : in std_logic;
				we : in std_logic;
				line : in std_logic_vector(cache_line_width-1 downto 0);
				data_in : in std_logic_vector(cache_data_width-1 downto 0);
				data_out : out std_logic_vector(cache_data_width-1 downto 0)
			);
	end component;

	--******************************************
	--*	TODO: Add any signal here
	--******************************************
	
	signal cache_we0: std_logic;
	signal cache_line0: std_logic_vector(3 downto 0);
	signal cache_data_to0: std_logic_vector(35 downto 0);
	signal main_mem_addr0: std_logic_vector(7 downto 0);
	signal main_mem_data_from0: std_logic_vector(31 downto 0);
	signal cache_data_from0: std_logic_vector (35 downto 0);
	
begin
	--******************************************
	--*	TODO: Complete the structural model
	--******************************************
	CACHE0: cache port map (clk, rst, cache_we0, cache_line0, cache_data_to0, cache_data_from0 );
		
	MAIN_MEM0: main_mem port map (clk, rst, main_mem_addr0, main_mem_data_from0 );

	CTRL: direct_cache_ctrl port map (clk, rst, addr, hit, cache_data_from0, cache_we0, 
	cache_line0, cache_tag, cache_data_to0, main_mem_data_from0, main_mem_addr0, state );


		 -- CACHE
		cache_data_from <= cache_data_from0;
		
		 -- MEM
		
		
		main_mem_data_from <= main_mem_data_from0;
		-- CONTROL
		main_mem_addr <= main_mem_addr0; 
		cache_line <= cache_line0;
		cache_we <= cache_we0;
		cache_data_to <= cache_data_to0;
													 
end structural;

