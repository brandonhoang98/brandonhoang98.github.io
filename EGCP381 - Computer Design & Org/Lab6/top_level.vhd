library ieee;
use ieee.std_logic_1164.all;

entity top_level is
	port (
		switches : in std_logic_vector(7 downto 0);
		clk : in std_logic;
		leds : out std_logic_vector(7 downto 0)
	);
end top_level;

architecture behavioral of top_level is
	-- declaration of kcpsm3 (always use this declaration to call
	-- up picoblaze core)
	component kcpsm3
		port (
			address : out std_logic_vector(9 downto 0);
			instruction : in std_logic_vector(17 downto 0);
			port_id : out std_logic_vector(7 downto 0);
			write_strobe : out std_logic;
			out_port : out std_logic_vector(7 downto 0);
			read_strobe : out std_logic;
			in_port : in std_logic_vector(7 downto 0);
			interrupt : in std_logic;
			interrupt_ack : out std_logic;
			reset : in std_logic;
			clk : in std_logic
		);
	end component;
	-------------------------------------------------------------------------
	-- declaration of program memory (here you will specify the entity name
	-- as your .psm prefix name)
	component lab_6
		port (
			address : in std_logic_vector(9 downto 0);
			instruction : out std_logic_vector(17 downto 0);
			clk : in std_logic
		);
	end component;
	-------------------------------------------------------------------------
	-- signals used to connect picoblaze core to program memory and i/o logic
	signal address : std_logic_vector(9 downto 0);
	signal instruction : std_logic_vector(17 downto 0);
	signal port_id : std_logic_vector(7 downto 0);
	signal out_port : std_logic_vector(7 downto 0);
	signal in_port : std_logic_vector(7 downto 0);
	signal write_strobe : std_logic;
	signal read_strobe : std_logic;
	signal interrupt_ack : std_logic;
	signal reset : std_logic;
	-- the following input is assigned an inactive value since it is
	-- unused in this example
	signal interrupt : std_logic := '0';
	-------------------------------------------------------------------------
	-- start of circuit description
begin
	-- instantiating the picoblaze core
	processor : kcpsm3
	port map(
		address => address, 
		instruction => instruction, 
		port_id => port_id, 
		write_strobe => write_strobe, 
		out_port => out_port, 
		read_strobe => read_strobe, 
		in_port => in_port, 
		interrupt => interrupt, 
		interrupt_ack => interrupt_ack, 
		reset => reset, 
		clk => clk
	);

	-- instantiating the program memory
	program : lab_6
	port map(
		address => address, 
		instruction => instruction, 
		clk => clk
	);

	-- connect i/o of picoblaze
	------------------------------------------------------------------------
	----- TO DO: kcpsm3 define input ports
	------------------------------------------------------------------------
	
	
	
	------------------------------------------------------------------------
	-- TO DO: kcpsm3 define output ports
	------------------------------------------------------------------------
	
	
	
	
	
	------------------------------------------------------------------------
	-- TO DO: kcpsm3 define interrupt control
	------------------------------------------------------------------------
	
	
	
end behavioral;