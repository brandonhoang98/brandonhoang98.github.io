library ieee;
use ieee.std_logic_1164.all;
 
entity sec_tb is
end sec_tb;
 
architecture behavior of sec_tb is 
 
    -- component declaration for the unit under test (uut)
 
    component sec
    port(
         data_in : in  std_logic_vector(11 downto 0);
         syndrome : out  std_logic_vector(3 downto 0);
         data_out : out  std_logic_vector(7 downto 0);
         err : out  std_logic
        );
    end component;
    

   --inputs
   signal data_in : std_logic_vector(11 downto 0) := (others => '0');

 	--outputs
   signal syndrome : std_logic_vector(3 downto 0);
   signal data_out : std_logic_vector(7 downto 0);
   signal err : std_logic;
 
begin
 
	-- instantiate the unit under test (uut)
   uut: sec port map (
          data_in => data_in,
          syndrome => syndrome,
          data_out => data_out,
          err => err
        );

   -- stimulus process
   stim_proc: process
   begin
		--******************************************
		-- TO DO: Create the test bench here
		--******************************************
		data_in <= "001101001111";
		wait for 10ns;
		data_in <= "001101101111";
		wait for 10ns;
		data_in <= "001101001110";
        wait;
		-- end
		assert false report "end of simulation" severity failure;
   end process;

end;
