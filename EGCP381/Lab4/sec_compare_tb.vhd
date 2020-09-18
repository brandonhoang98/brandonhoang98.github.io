
-- VHDL Test Bench Created from source file sec_compare.vhd -- 16:22:53 03/11/2019
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

ENTITY sec_compare_sec_compare_tb_vhd_tb IS
END sec_compare_sec_compare_tb_vhd_tb;

ARCHITECTURE behavior OF sec_compare_sec_compare_tb_vhd_tb IS 

	COMPONENT sec_compare
	PORT(
		k : IN std_logic_vector(3 downto 0);
		kp : IN std_logic_vector(3 downto 0);          
		syndrome : OUT std_logic_vector(3 downto 0);
		err : OUT std_logic
		);
	END COMPONENT;

	SIGNAL k :  std_logic_vector(3 downto 0);
	SIGNAL kp :  std_logic_vector(3 downto 0);
	SIGNAL syndrome :  std_logic_vector(3 downto 0);
	SIGNAL err :  std_logic;

BEGIN

	uut: sec_compare PORT MAP(
		k => k,
		kp => kp,
		syndrome => syndrome,
		err => err
	);


-- *** Test Bench - User Defined Section ***
   tb : PROCESS
   BEGIN
   	 k <= "0100";
	 kp <= "0100";
	 wait for 10ns;
	 k <= "0100";
	 kp <= "0110";
	 wait for 10ns;
	 k <= "0100";
	 kp <= "1010";
      wait; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
