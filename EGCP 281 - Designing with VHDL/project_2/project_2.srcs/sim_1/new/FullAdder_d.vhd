----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/13/2017 11:28:26 AM
-- Design Name: 
-- Module Name: FullAdder_d - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FullAdder_tb is
end FullAdder_tb;

architecture Behavioral of FullAdder_tb is
component FullAdder is
   Port ( a : in STD_LOGIC;
           b : in STD_LOGIC;
           cin : in STD_LOGIC;
           s : out STD_LOGIC;
           cout : out STD_LOGIC);
end component;
signal A, B, Cin, S, Cout: STD_LOGIC;

begin
    dut: FullAdder port map (
        a => A,
        b => B,
        cin => Cin,
        s => S,
        cout => Cout);
    process
    begin
        A <= '0';
        B <= '0';
        Cin <= '0';
        wait for 1ns;
   A <= '0';
              B <= '0';
              Cin <= '1';
              wait for 1ns;       
   A <= '0';
                    B <= '1';
                    Cin <= '0';
                    wait for 1ns;
                      A <= '0';
                          B <= '1';
                          Cin <= '1';
                          wait for 1ns;
                            A <= '1';
                                B <= '0';
                                Cin <= '0';
                                wait for 1ns;        
                                  A <= '1';
                                      B <= '0';
                                      Cin <= '1';
                                      wait for 1ns;
                                        A <= '1';
                                            B <= '1';
                                            Cin <= '0';
                                            wait for 1ns;
                                              A <= '1';
                                                  B <= '1';
                                                  Cin <= '1';
                                                  wait for 1ns;     
        wait;
    end process;
    
end Behavioral;

