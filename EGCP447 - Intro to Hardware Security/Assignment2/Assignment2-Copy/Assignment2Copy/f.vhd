
-- VHDL Test Bench Created from source file scanff.vhd -- 17:12:06 10/29/2019
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

ENTITY scanff_f_vhd_tb IS
END scanff_f_vhd_tb;

ARCHITECTURE behavior OF scanff_f_vhd_tb IS 

	COMPONENT scanff
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		sel : IN std_logic;
		input : IN std_logic;
		scan : IN std_logic;          
		output : OUT std_logic
		);
	END COMPONENT;

	SIGNAL clk :  std_logic;
	SIGNAL rst :  std_logic;
	SIGNAL sel :  std_logic;
	SIGNAL input :  std_logic;
	SIGNAL scan :  std_logic;
	SIGNAL output :  std_logic;

BEGIN

	uut: scanff PORT MAP(
		clk => clk,
		rst => rst,
		sel => sel,
		input => input,
		scan => scan,
		output => output
	);


-- *** Test Bench - User Defined Section ***
   tb : PROCESS
   BEGIN
   	 input <= '1';
	 rst <= '0';
	 clk <= '0';
	 sel <= '0';
	 scan <= '0';
	 wait for 10ns;
	 clk <= '1';
	 wait for 10ns;
	 clk <= '0';
	 sel <= '1';
	 wait for 10ns;
	 clk <= '1';
      wait; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
