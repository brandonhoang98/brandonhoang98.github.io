library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.definitions.all;

entity direct_cache_tb is
end direct_cache_tb;
 
architecture behavior of direct_cache_tb is 
 
    -- component declaration for the unit under test (uut)
 
    component direct_cache
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
    end component;
    

   --inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal addr : std_logic_vector(9 downto 0) := (others => '0');

 	--outputs
   signal hit : std_logic;
   signal cache_we : std_logic;
   signal cache_data_to : std_logic_vector(35 downto 0);
   signal cache_line : std_logic_vector(3 downto 0);
   signal cache_tag : std_logic_vector(3 downto 0);
   signal cache_data_from : std_logic_vector(35 downto 0);
   signal main_mem_addr : std_logic_vector(7 downto 0);
   signal main_mem_data_from : std_logic_vector(31 downto 0);
	signal state : integer;

   -- clock period definitions
   constant clk_period : time := 20 ns;
 
begin
 
	-- instantiate the unit under test (uut)
   uut: direct_cache port map (
          clk => clk,
          rst => rst,
          addr => addr,
          hit => hit,
          cache_we => cache_we,
          cache_data_to => cache_data_to,
          cache_line => cache_line,
          cache_tag => cache_tag,
          cache_data_from => cache_data_from,
          main_mem_addr => main_mem_addr,
          main_mem_data_from => main_mem_data_from,
			 state => state
        );

   -- clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- stimulus process
   stim_proc: process
		variable addr_len : integer := cache_tag_width + cache_line_width + cache_word_width;
   begin
		--******************************************
		--*	TODO: Complete the test bench
		--******************************************		
		rst <= '1';
		wait for clk_period;
		rst <= '0';
		addr <= "0000000000";
		wait for clk_period*4;
		addr <= "1111011100";
		wait for clk_period*7;
		addr <= "0000000000";
		wait for clk_period*4;
		addr <= "1111011100";
		wait for clk_period*4;
		addr <= "0110011000";
		wait for clk_period*7;
		addr <= "0110011000";
		wait;
		-- End
		assert false report "End of Simulation" severity failure;
   end process;

end;
