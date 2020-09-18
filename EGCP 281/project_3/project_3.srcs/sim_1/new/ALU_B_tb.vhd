

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ALU_B_tb is
--  Port ( );
end ALU_B_tb;

architecture Behavioral of ALU_B_tb is
    component ALU_B_d is 
    Port ( IA: in STD_LOGIC_VECTOR (3 downto 0);
               IB: in STD_LOGIC_VECTOR (3 downto 0);
               ISel: in STD_LOGIC_VECTOR (2 downto 0);
               IO: out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    signal ia, ib: STD_LOGIC_VECTOR (3 downto 0);
    signal isel: STD_LOGIC_VECTOR (2 downto 0);
    signal io: STD_LOGIC_VECTOR (6 downto 0);
begin
    dut: ALU_B_d port map (
        IA => ia,
        IB => ib,
        ISel => isel,
        IO => io
    );
    process
    begin
    ia <= "0110";
    ib <= "0010";
    isel <= "000";
    wait for 50ns;
    ia <= "1000";
    ib <= "0111";
    wait for 50ns;
    ia <= "0111";
    isel <= "001";
    wait for 50ns;
    ia <= "0000";
    wait for 50ns;
    isel <= "010";
    ia <= "1000";
    ib <= "0011";
    wait for 50ns;
    ib <= "1000";
    wait for 50ns;
    isel <= "011";
    wait for 50ns;
    isel <= "100";
    ia <= "0110";
    ib <= "1000";
    wait for 50ns;
    ia <= "0001";
    ib <= "0000";
    wait for 50ns;
    ia <= "0000";
    ib <= "0001";
    wait for 50ns;
    isel <= "101";
    ia <= "0000";
    wait for 50ns;
    ia <= "0110";
    wait for 50ns;
    isel <= "110";
    ia <= "0001";
    ib <= "0000";
    wait for 50 ns;
    ia <= "0000";
    ib <= "0010";
    wait for 50ns;
    isel <= "111";
    ib <= "0001";
    wait for 50ns;
    ia <= "0001";
    
    wait;
    end process;

end Behavioral;
