library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; 
use work.definitions.all;

entity direct_cache_ctrl is
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
end direct_cache_ctrl;

architecture behavioral of direct_cache_ctrl is
	--******************************************
	--*	TODO: Add FSM states and any signals
	--******************************************
	type eg_state_type is (CACHE_R, GET_TAG, GET_TAG2, COMP_TAGS, MAIN_MEM_R, CACHE_UPDATE, CACHE_UPDATE2);
	signal state_reg, state_next: eg_state_type;
	
	--******************************************
	--*	Don't delete/change the following signals
	--******************************************
	signal tag : std_logic_vector(cache_tag_width-1 downto 0) := (others => '0');
	signal line : std_logic_vector(cache_line_width-1 downto 0) := (others => '0');
	signal word : std_logic_vector(cache_word_width-1 downto 0) := (others => '0');
	signal cache_tag_sig : std_logic_vector(cache_tag_width-1 downto 0) := (others => '0');
	signal addr_len : integer := cache_tag_width + cache_line_width + cache_word_width;
	
begin
	--******************************************
	--*	Don't delete/change the following
	--*	Seperate tag, line, and word concurrently
	--******************************************
	tag <= addr(addr_len-1 downto (addr_len-cache_tag_width));
	line <= addr((addr_len-cache_tag_width)-1 downto (addr_len-cache_tag_width-cache_line_width));
	word <= addr((addr_len-cache_tag_width-cache_line_width)-1 downto 0);
	cache_line <= line;
	cache_tag <= tag;	
	
	--******************************************
	--*	TODO: State register
	--******************************************
	process(clk, rst)
	begin
		if (rst = '1') then
			state_reg <= CACHE_R;
		elsif (rising_edge(clk)) then
			state_reg <= state_next;
		end if;	
	end process;
	
	--******************************************
	--*	TODO: Next-state
	--******************************************
	process(state_reg)
	begin
	case state_reg is 
		when CACHE_R =>
			state_next <= GET_TAG;
		when GET_TAG =>
			state_next <= GET_TAG2;
		when GET_TAG2 =>
			state_next <= COMP_TAGS;
		when COMP_TAGS =>
			if ( cache_tag_sig = tag ) then
				state_next <= CACHE_R;
			else
				state_next <= MAIN_MEM_R;
			end if;
		when MAIN_MEM_R =>
			state_next <= CACHE_UPDATE;	
		when CACHE_UPDATE =>
			state_next <= CACHE_UPDATE2;
		when CACHE_UPDATE2 =>
			 state_next <= CACHE_R;
		end case;
	end process;	
	
	--******************************************
	--*	TODO: Moore logic
	--******************************************
	process(state_reg)
	begin--/Users/ybai/Dropbox (CSU Fullerton)/CSUF-Teaching/Spring 2019/EGCP381/Lab/Lab 3/Template Code/direct_cache.vhd
	case state_reg is 
		when CACHE_R =>
			state <= 1;
			cache_we <= '0';	
		when GET_TAG =>
			state <= 2;
		when GET_TAG2 =>
			state <= 3;
			cache_tag_sig <= cache_data_from (35 downto 32);
		when COMP_TAGS =>
			state <= 4;
		when MAIN_MEM_R =>
			state <= 5;
			main_mem_addr(7 downto 4) <= tag;
			main_mem_addr(3 downto 0) <= line;
		when CACHE_UPDATE =>
			state <= 6;
			cache_we <= '1';
		when CACHE_UPDATE2 =>
			state <= 7;
			cache_data_to(31 downto 0) <= main_mem_data_from;	
			cache_data_to(35 downto 32) <= tag;
		end case;		
	end process;
	
	--******************************************
	--*	TODO: Mealy logic
	--******************************************
	process(state_reg)
	begin
		if ( state_reg = COMP_TAGS ) then
		if (cache_tag_sig = tag) then
			hit <= '1';

		else
			hit <= '0';
		end if;
		end if;

		if ( state_reg = CACHE_UPDATE2 ) then
			hit <= '1';
		end if;
	end process;
	
end behavioral;

