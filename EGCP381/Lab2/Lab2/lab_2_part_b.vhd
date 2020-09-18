library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity lab_2_part_b is
	port(clk, reset : in std_logic;
		 r1_reg, r2_reg : inout std_logic_vector (7 downto 0));
end lab_2_part_b;

architecture behavioral of lab_2_part_b is
	--******************************************
	--*	TODO: Add FSM states and any signals
	--******************************************
	type eg_state_type is (s0, s1, s2, s3);
	signal state_reg, state_next: eg_state_type;
	signal r1_next: std_logic_vector (7 downto 0);
begin
	--******************************************
	--*	TODO: State register
	--******************************************
	process(clk, reset)
		variable count : integer := 0;
	begin
	if (reset = '1') then
		count := 0;
		r1_reg <= "00000000";
		r2_reg <= "00000001";
		state_reg <= s0;
	elsif (rising_edge(clk)) then
		if (count >= 50000000) then
		count := 0;
		state_reg <= state_next;
		r1_reg <= r1_next;
		else
		count := count + 1;
	end if;
	end if;
	end process;
	
	--******************************************
	--*	TODO: Next-state and Moore logic
	--******************************************
	process(state_reg)
	begin
	case state_reg is
		when s0 =>
			r1_next <= "00001000";
			state_next <= s1;
		when s1 =>
			r1_next <= r1_reg + r2_reg;
			state_next <= s2;
		when s2 =>
			r1_next(7 downto 2) <= r1_reg(5 downto 0);
			r1_next(1 downto 0) <= "00";
			state_next <= s3;
		when s3 =>
			r1_next <= r1_reg;
			state_next <= s0;
	    end case;
	end process;

end behavioral;

