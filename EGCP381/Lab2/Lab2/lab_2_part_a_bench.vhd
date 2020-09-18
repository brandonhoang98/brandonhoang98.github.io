
-- VHDL Test Bench Created from source file lab_2_part_a.vhd -- 14:21:21 02/18/2019
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends 
-- that these types always be used for the top-level I/O of a design in order 
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY lab_2_part_a_lab_2_part_a_bench_vhd_tb IS
END lab_2_part_a_lab_2_part_a_bench_vhd_tb;

ARCHITECTURE behavior OF lab_2_part_a_lab_2_part_a_bench_vhd_tb IS 

	COMPONENT lab_2_part_a
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;       
		r1_reg : INOUT std_logic_vector(7 downto 0);
		r2_reg : INOUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	SIGNAL clk :  std_logic;
	SIGNAL reset :  std_logic;
	SIGNAL r1_reg :  std_logic_vector(7 downto 0);
	SIGNAL r2_reg :  std_logic_vector(7 downto 0);

BEGIN

	uut: lab_2_part_a PORT MAP(
		clk => CLK,
		reset => RESET,
		r1_reg => R1_reg,
		r2_reg => R2_reg
	);


-- *** Test Bench - User Defined Section ***
   tb : PROCESS
   BEGIN
   	CLK <= '0';
	RESET <= '1';
	wait for 10ns;
	CLK <= '1';
	wait for 10 ns;
	CLK <= '0';
	RESET <= '0';
	wait for 10 ns;
	CLK <= '1';
	wait for 10 ns;
	CLK <= '0';
	wait for 10 ns;
	CLK <= '1';
	wait for 10 ns;
	CLK <= '0';
	wait for 10 ns;
	CLK <= '1';
	wait for 10 ns;
	CLK <= '0';
	wait for 10 ns;
	CLK <= '1';
	wait for 10 ns;
	CLK <= '0';
	wait for 10 ns;
	CLK <= '1';
	wait for 10 ns;
	CLK <= '0';
	wait for 10 ns;
	CLK <= '1';
	wait for 10 ns;
	CLK <= '0';
	wait for 10 ns;
	CLK <= '1';
	wait for 10 ns;
	CLK <= '0';
	wait for 10 ns;
	CLK <= '1';
	wait for 10 ns;
	CLK <= '0';
	wait for 10 ns;
	CLK <= '1';
	wait for 10 ns;
     	 wait; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
