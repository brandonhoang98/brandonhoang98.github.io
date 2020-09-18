
-- VHDL Test Bench Created from source file sec_corrector.vhd -- 16:23:43 03/11/2019
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

ENTITY sec_corrector_sec_corrector_tb_vhd_tb IS
END sec_corrector_sec_corrector_tb_vhd_tb;

ARCHITECTURE behavior OF sec_corrector_sec_corrector_tb_vhd_tb IS 

	COMPONENT sec_corrector
	PORT(
		m : IN std_logic_vector(7 downto 0);
		syndrome : IN std_logic_vector(3 downto 0);          
		mp : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	SIGNAL m :  std_logic_vector(7 downto 0);
	SIGNAL syndrome :  std_logic_vector(3 downto 0);
	SIGNAL mp :  std_logic_vector(7 downto 0);

BEGIN

	uut: sec_corrector PORT MAP(
		m => m,
		syndrome => syndrome,
		mp => mp
	);


-- *** Test Bench - User Defined Section ***
   tb : PROCESS
   BEGIN
   	 m <= "10011000";
	 syndrome <= "0110";
	wait for 10ns;
	m <= "00100010";
	 syndrome <= "1000";
	wait for 10ns;
	m <= "11011101";
	 syndrome <= "0000";
      wait; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
