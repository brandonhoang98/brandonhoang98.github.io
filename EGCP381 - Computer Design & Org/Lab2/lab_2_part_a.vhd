library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity lab_2_part_a is
	port(clk, reset : in std_logic;
		 r1_reg, r2_reg : inout std_logic_vector (7 downto 0));
end lab_2_part_a;

architecture behavioral of lab_2_part_a is
	--******************************************
	--*	TODO: Add FSM states and any signals
	--******************************************

begin
	--******************************************
	--*	TODO: State register
	--******************************************
	process(clk, reset)
	begin
	
	end process;
	
	--******************************************
	--*	TODO: Next-state and Moore logic
	--******************************************
	process(state_reg)
	begin
	
	end process;

end behavioral;

