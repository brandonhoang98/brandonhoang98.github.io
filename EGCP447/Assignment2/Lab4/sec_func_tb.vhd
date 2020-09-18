
-- VHDL Test Bench Created from source file sec_func.vhd -- 16:24:04 03/11/2019
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

ENTITY sec_func_sec_func_tb_vhd_tb IS
END sec_func_sec_func_tb_vhd_tb;

ARCHITECTURE behavior OF sec_func_sec_func_tb_vhd_tb IS 

	COMPONENT sec_func
	PORT(
		m : IN std_logic_vector(7 downto 0);          
		k : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	SIGNAL m :  std_logic_vector(7 downto 0);
	SIGNAL k :  std_logic_vector(3 downto 0);

BEGIN

	uut: sec_func PORT MAP(
		m => m,
		k => k
	);


-- *** Test Bench - User Defined Section ***
   tb : PROCESS
   BEGIN
   	m <=	"10011000";
	wait for 10ns;
	m <= "00100010";
	wait for 10ns;
	m <= "11011101";
      wait; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
