----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2019 05:05:45 PM
-- Design Name: 
-- Module Name: FSM - Behavioral
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

entity FSM is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ready : in STD_LOGIC;
           rw : in STD_LOGIC;
           oe : out STD_LOGIC;
           we : out STD_LOGIC);
end FSM;

architecture Behavioral of FSM is
    signal state_reg, state_next: std_logic_vector (2 downto 0);
    -- 000 <= Idle
    -- 001 <= Decision
    -- 011 <= read
    -- 111 <= Write
begin
    process (clk, rst)
    begin
        if (rst = '1') then
            state_reg <= "000";
        elsif (rising_edge(clk)) then
            state_reg <= state_next;
        end if;
    end process;
    
    process (state_reg)
    begin
    case state_reg is
        when "000" =>
            if ( ready = '1' ) then
                state_next <= "001";
            else 
                state_next <= "000";
            end if;
        when "001" =>
            if ( rw = '1' ) then
                state_next <= "011";
            else
                state_next <= "111";
            end if;
       when "011" =>
            if (ready = '1') then
                state_next <= "000";
            else 
                state_next <= "011";
            end if;
       when "111" =>
            if ( ready = '1') then
                state_next <= "000";
            else
                state_next <= "111";
            end if;
       when others =>
                state_next <= "000";  
       end case;
    end process;
    
    process (state_reg)
    begin
    case state_reg is
    when "000" =>
        oe <= '0';
        we <= '0';
    when "001" =>
        oe <= '0';
        we <= '0';
    when "011" =>
        oe <= '0';
        we <= '1';
    when "111" =>
        oe <= '1';
        we <= '0';
    end case;
    end process;

end Behavioral;
