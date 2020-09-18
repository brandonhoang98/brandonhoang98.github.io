library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BFSM is
    Port ( clk : in STD_LOGIC;
           ready : in STD_LOGIC;
           rw : in STD_LOGIC;
           InitEN: in STD_LOGIC;
           InitVal: in STD_LOGIC_VECTOR (2 downto 0);
           state: out STD_LOGIC_VECTOR (2 downto 0);
           oe : out STD_LOGIC;
           we : out STD_LOGIC);
end BFSM;

architecture Behavioral of BFSM is
    signal state_reg, state_next: std_logic_vector (2 downto 0);
    -- 000 <= Idle
    -- 001 <= Decision
    -- 011 <= read
    -- 111 <= Write
begin
    process (clk, InitEN)
    begin
        if (InitEN = '1') then
            state_reg <= InitVal;
        elsif (rising_edge(clk)) then
            state_reg <= state_next;
        end if;
    end process;
    
    process (state_reg)
    begin
    case state_reg is
        when "000" =>
            if ( ready = '1' and rw = '1' ) then
                state_next <= "001";
            elsif (ready = '0' and rw = '1') then
                state_next <= "000";
            else 
                state_next <= "110";
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
       when "010" =>
            state_next <= "100";
       when "100" =>
            state_next <= "101";
       when "101" =>
            state_next <= "110";
       when "110" =>
            if (rw = '1') then
                state_next <= "000";
            else
                state_next <= "010";
            end if;
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
    when others =>
        oe <= '1'; 
        we <= '1';
    end case;
    end process;
    
    state <= state_reg;

end Behavioral;