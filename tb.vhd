library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb is
end tb;

architecture Behavioral of tb is
    
    constant T  : time := 10 ns;
    
    signal clk  : std_logic;
    signal rst  : std_logic;
    signal msg  : std_logic_vector(23 downto 0);
    signal hash : std_logic_vector(255 downto 0);
    
begin
    SHA_DUT : entity work.SHA_256(Behavioral)
        port map(
            clk  => clk, 
            rst  => rst, 
            --
            msg  => msg, 
            hash => hash);

    process
    begin
        clk <= '0';
        wait for T/2;
   
        clk <= '1';
        wait for T/2;   
    end process; 
    
    process
    begin
        rst <= '1';
        wait for 1 us;   
        rst <= '0';
        
        msg <= X"616263";
        wait for 3 us;   
        
        msg <= X"616161";
        wait for 3 us;
           
        msg <= X"636261";
        wait for 3 us;
           
        msg <= X"626262";
        wait for 3 us;
           
        msg <= X"636263";
        wait for 3 us;
    end process;
end Behavioral;
