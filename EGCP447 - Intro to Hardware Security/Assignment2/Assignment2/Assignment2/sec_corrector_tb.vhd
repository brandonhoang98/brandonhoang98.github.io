
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
		m : IN std_logic_vector(6 downto 0); 
		clk : in std_logic;
		rst : in std_logic;
		err : OUT std_logic;         
		mp : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	COMPONENT sec_func is
		port (m: in std_logic_vector(3 downto 0);
			clk: in std_logic;
			rst : in std_logic;
			dataout : out std_logic_vector(6 downto 0)
			);
	END COMPONENT;
	SIGNAL m :  std_logic_vector(6 downto 0);
	SIGNAL clk : std_logic;
	SIGNAL rst : std_logic;
	SIGNAL mp :  std_logic_vector(3 downto 0);
	SIGNAL m1 : std_logic_vector(3 downto 0); 
	SIGNAL err : std_logic;
	SIGNAL dataout : std_logic_vector (6 downto 0);
	SIGNAL flip : std_logic_vector (6 downto 0);
BEGIN
	uut1: sec_func PORT MAP (
		m => m1,
		clk => clk,
		rst => rst,
		dataout => dataout
	);

	m <= dataout xor flip;


	uut: sec_corrector PORT MAP(
		m => m,
		clk => clk,
		rst => rst,
		err => err,
		mp => mp
	);



-- *** Test Bench - User Defined Section ***
   tb : PROCESS
   BEGIN
   clk <= '0';
   rst <= '0';
   m1 <= "1001";
   flip <= "0000000";
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1';	
   wait for 10ns;
   clk <= '0';
   flip <= "1000000";
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   flip <= "0100000";
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1'; 
   wait for 10ns;
   clk <= '0';
   flip <= "0010000";
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1'; 
   wait for 10ns;
   clk <= '0';
   flip <= "0001000";
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1'; 
   wait for 10ns;
   clk <= '0';
   flip <= "0000100";
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
