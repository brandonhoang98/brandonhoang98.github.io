
-- VHDL Test Bench Created from source file full_adder.vhd -- 10:24:38 04/23/2019
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

ENTITY full_adder_full_tb_vhd_tb IS
END full_adder_full_tb_vhd_tb;

ARCHITECTURE behavior OF full_adder_full_tb_vhd_tb IS 

	COMPONENT full_adder
	PORT(
		a : IN std_logic;
		b : IN std_logic;
		cin : IN std_logic;          
		s : OUT std_logic;
		cout : OUT std_logic
		);
	END COMPONENT;

	SIGNAL a :  std_logic;
	SIGNAL b :  std_logic;
	SIGNAL cin :  std_logic;
	SIGNAL s :  std_logic;
	SIGNAL cout :  std_logic;

BEGIN

	uut: full_adder PORT MAP(
		a => a,
		b => b,
		cin => cin,
		s => s,
		cout => cout
	);


-- *** Test Bench - User Defined Section ***
   tb : PROCESS
   BEGIN
   	 a <= '0';
	 b <= '0';
	 cin <= '0';
	 wait for 100ns;
	 cin <= '1';
	 wait for 100ns;
	 b <= '1';
	 cin <= '0';
	 wait for 100ns;
	 cin <= '1';
	 wait for 100ns;
	 b <= '0';
	 cin <= '0';
	 a <= '1';
	 wait for 100ns;
	 cin <= '1';
	 wait for 100ns;
	 b <= '1';
	 cin <= '0';
	 wait for 100ns;
	 cin <= '1';
	 wait for 100ns;
      wait; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
