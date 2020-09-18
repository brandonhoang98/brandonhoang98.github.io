----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2019 01:38:22 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
--  Port ( );
end top;

architecture Behavioral of top is
    component LFSR is
    Port ( clk : in STD_LOGIC;
           InitEN : in STD_LOGIC;
           InitVal : in STD_LOGIC_VECTOR(2 downto 0);
           Q : out STD_LOGIC_VECTOR(2 downto 0)
           );
    end component;
    
    component BFSM is
     Port ( clk : in STD_LOGIC;
           ready : in STD_LOGIC;
           rw : in STD_LOGIC;
           InitEN: in STD_LOGIC;
           InitVal: in STD_LOGIC_VECTOR (2 downto 0);
           state: out STD_LOGIC_VECTOR (2 downto 0);
           oe : out STD_LOGIC;
           we : out STD_LOGIC);
    end component; 
    
    signal clk, ready, rw, oe, we, InitEN, InitENLFSR : std_logic;
    signal state, InitValLFSR, Q : std_logic_vector(2 downto 0);
begin
    uut1 : LFSR PORT MAP (
        clk => clk,
        InitEN => InitENLFSR,
        InitVal => InitValLFSR,
        Q => Q
        
    );
    
    uut2 : BFSM PORT MAP (
        clk => clk,
        ready => ready,
        rw => rw, 
        InitEN => InitEN,
        InitVal => Q,
        state => state,
        oe => oe,
        we => we
    );
    tb : PROCESS
    BEGIN
    clk <= '0';
    InitValLFSR <= "101";
    ready <= '0';
    rw <= '0';
    wait for 10ns;
    InitENLFSR <= '1';
    wait for 10ns;
    InitEN <= '0';
    wait for 10ns;
    clk <= '1';
    wait for 10ns;
    clk <= '0';
    wait for 10ns;
    clk <= '1';
    wait for 10ns;
    clk <= '0';
    InitENLFSR <= '0';
    InitEN <= '1';
    
    wait for 10ns;
    clk <= '1';
    wait for 10ns;
    clk <= '0';
    InitEN <= '0';
    wait for 10ns;
    clk <= '1';
    wait for 10ns;
    clk <= '0';
    ready <= '1';
    rw <= '1';
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
    rw <= '0';
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
    wait;
    END PROCESS;
end Behavioral;
