
-- VHDL Test Bench Created from source file sec_func.vhd -- 17:10:55 10/24/2019
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

ENTITY sec_func_f_vhd_tb IS
END sec_func_f_vhd_tb;

ARCHITECTURE behavior OF sec_func_f_vhd_tb IS 

	COMPONENT sec_func
	PORT(
		m : IN std_logic_vector(3 downto 0);
		clk : IN std_logic;
		rst : IN std_logic;          
		dataout : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;

	SIGNAL m :  std_logic_vector(3 downto 0);
	SIGNAL clk :  std_logic;
	SIGNAL rst :  std_logic;
	SIGNAL dataout :  std_logic_vector(6 downto 0);

BEGIN

	uut: sec_func PORT MAP(
		m => m,
		clk => clk,
		rst => rst,
		dataout => dataout
	);


-- *** Test Bench - User Defined Section ***
   tb : PROCESS
   BEGIN
   	 m <= "1001";
	 clk <= '0';
	 rst <= '0';
	 wait for 100ns;
	 clk <= '1';
	 wait for 100ns;
	 clk <= '0';
	 wait for 100ns;
	 clk <= '1';
	 wait for 100ns;
	 clk <= '0';
	 wait for 100ns;
	 clk <= '1';
	 wait for 100ns;
	 clk <= '0';
      wait; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
