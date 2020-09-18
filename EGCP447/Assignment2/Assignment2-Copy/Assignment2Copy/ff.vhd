
-- VHDL Test Bench Created from source file sec_func.vhd -- 17:15:23 10/29/2019
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

ENTITY sec_func_ff_vhd_tb IS
END sec_func_ff_vhd_tb;

ARCHITECTURE behavior OF sec_func_ff_vhd_tb IS 

	COMPONENT sec_func
	PORT(
		min : IN std_logic_vector(3 downto 0);
		clk : IN std_logic;
		rst : IN std_logic;
		sel : IN std_logic;
		scanin : IN std_logic;  
		scanbits : out std_logic_vector ( 3 downto 0);        
		dataout : OUT std_logic_vector(6 downto 0);
		scanout : OUT std_logic
		);
	END COMPONENT;

	SIGNAL min :  std_logic_vector(3 downto 0);
	SIGNAL clk :  std_logic;
	SIGNAL rst :  std_logic;
	SIGNAL sel :  std_logic;
	SIGNAL scanin :  std_logic;
	SIGNAL scanbits :  std_logic_vector ( 3 downto 0);
	SIGNAL dataout :  std_logic_vector(6 downto 0);
	SIGNAL scanout :  std_logic;

BEGIN

	uut: sec_func PORT MAP(
		min => min,
		clk => clk,
		rst => rst,
		sel => sel,
		scanin => scanin,
		scanbits => scanbits,
		dataout => dataout,
		scanout => scanout
	);


-- *** Test Bench - User Defined Section ***
   tb : PROCESS
   BEGIN
   clk <= '0';
   rst <= '0';
   min <= "1010";
   sel <= '1';
   scanin <= '1';
   wait for 10ns;
   rst <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   scanin <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   scanin <= '1';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   sel <= '1';
   min <= "1010";
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   scanin <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   scanin <= 'X';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   sel <= '1';
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1';
      wait; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
