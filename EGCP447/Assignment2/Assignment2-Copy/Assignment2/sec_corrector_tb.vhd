
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
		min : IN std_logic_vector(6 downto 0); 
		clk : in std_logic;
		rst : in std_logic;
		scanin : in std_logic;
		sel : in std_logic;
		scanbits : out std_logic_vector (6 downto 0);
		scanout : out std_logic;
		err : OUT std_logic;         
		mp : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	COMPONENT sec_func is
		port (min: in std_logic_vector(3 downto 0);
			clk: in std_logic;
			rst : in std_logic;
			scanin : in std_logic;
			sel : in std_logic;
			scanbits : out std_logic_vector( 3 downto 0);
			dataout : out std_logic_vector(6 downto 0)  ;
			scanout : out std_logic
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
	SIGNAL scanin : std_logic;
	SIGNAL scaninC : std_logic;
	SIGNAL scanbits: std_logic_vector(3 downto 0);
	SIGNAL scanbitsB: std_logic_vector( 6 downto 0);
	SIGNAL sel : std_logic;
	SIGNAL scanout : std_logic;
	SIGNAL scanoutC : std_logic;

BEGIN
	uut1: sec_func PORT MAP (
		min => m1,
		clk => clk,
		rst => rst,
		scanin => scanin,
		sel => sel,
		scanbits => scanbits,
		dataout => dataout,
		scanout => scanout
	);

	m <= dataout xor flip;

	uut: sec_corrector PORT MAP(
		min => m,
		clk => clk,
		rst => rst,
		scanin => scanout,
		sel => sel,
		scanbits => scanbitsB,
		scanout => scanoutC,
		err => err,
		mp => mp
	);



-- *** Test Bench - User Defined Section ***
   tb : PROCESS
   BEGIN
   clk <= '0';
   rst <= '0';
   sel <= '1';
   m1 <= "0111";
   scanin <= '1';
   flip <= "0100000";
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
   scanin <= '1';
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
   scanin <= '1';
   clk <= '0'; 
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
   clk <= '0';
   scanin <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
   clk <= '0';
   scanin <= '1';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
   clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
      clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
   clk <= '0';
   scanin <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
      clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
   clk <= '0';
   scanin <= '1';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
      clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
   scanin <= '0';
   clk <= '0';
   wait for 10ns;
   clk <= '1';
   wait for 10ns;
      clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
   scanin <= '1';
   clk <= '0';
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
   clk <= '0';
    sel <= '0';
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
   sel <= '1';
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
   wait for 10ns;  clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
    clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
     clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
	 clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
	  clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
	   clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
	    clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
	     clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
		 clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
		  clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
		   clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
		    clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
		     clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns; 
			clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
			clk <= '0'; wait for 10ns; clk <= '1'; wait for 10ns;
      wait; -- will wait forever
   END PROCESS;
-- *** End Test Bench - User Defined Section ***

END;
