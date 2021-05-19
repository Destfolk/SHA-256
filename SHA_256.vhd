library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

library work;
use work.Function_pkg.all;

entity SHA_256 is
    Generic (length : integer := 24);
    Port (clk  : in  std_logic;
          rst  : in  std_logic;
          msg  : in  std_logic_vector(length - 1 downto 0);
          hash : out std_logic_vector(255 downto 0)
          );
end SHA_256;

architecture Behavioral of SHA_256 is
    ---------------------------------
    -- Initail Signals
    ---------------------------------
    signal W       : Array_32x64;
    signal padded  : std_logic_vector(511 downto 0) := (others => '0');
    signal H, X    : Array_32x8  := (X"6a09e667", X"bb67ae85", X"3c6ef372", X"a54ff53a", 
                                     X"510e527f", X"9b05688c", X"1f83d9ab", X"5be0cd19");
    
    ---------------------------------
    -- Compression Function Signals
    ---------------------------------
    signal T3      : std_logic := '1';
    signal done    : std_logic := '0';
    
    signal T1      : std_logic_vector(31  downto 0);
    signal T2      : std_logic_vector(31  downto 0);
    signal kconst  : std_logic_vector(31  downto 0);
    
    
    ---------------------------------
    -- Counters
    ---------------------------------
    signal Z       :integer := 0;
    signal C       :integer := 0;
    signal W_count :integer := 0;
begin
    K_const : entity work.K(Behavioral)
        port map (
           clk      => clk,
           addr     => Z,
           data_out => kconst);
           
    padded(511 downto 511 - length) <= msg & '1' when C < 64 else (others => '0');
    padded(63  downto 0)  <=   int2std64(length) when C < 64 else (others => '0');
   
     
    Scheduler_counter : process(clk)
    begin
        if (rst = '1') then
            C <= 0;
        else
            C <= W_count;
        end if;
    end process;
    
    Scheduler_generation : process(clk)
    begin
        if rising_edge(clk) then
            if (rst = '1' or done = '1') then
                W <= (others=> (others=>'0'));
                W_count <= 0;
            elsif (C < 16) then
                W(C)<=padded(511-(C*32) downto 480-(C*32));
                W_count <= W_count + 1;
            elsif (C < 64) then
                W(C)<=Sigma1(W(C-2)) + W(C-7) + Sigma0(W(C-15)) +W(C-16);
                W_count <= W_count + 1;
            end if;
        end if;            
    end process;
  
    Compression_function  : process(clk)
    begin
        if rising_edge(clk) then
            if (rst = '1') then
                X    <= H;
                Z    <= 0;
                T3   <= '1';
            elsif ( C >= 1 and Z < 64 and T3 = '1') then
                T1   <= X(7) + Sum1(X(4)) + Ch(X(4),X(5),X(6)) + kconst + W(Z);
                T2   <= Sum0(X(0)) + Maj(X(0),X(1),X(2));
                T3   <= '0';
                Z    <= Z + 1;
            elsif (Z < 65 and T3 = '0') then
                X(7) <= X(6);
                X(6) <= X(5);
                X(5) <= X(4);
                X(4) <= X(3) + T1;
                X(3) <= X(2);
                X(2) <= X(1);
                X(1) <= X(0);
                X(0) <= T1 + T2;
                T3   <= '1';
            elsif (Z = 64) then
		      hash   <= x(0)+H(0) & x(1)+H(1) & x(2)+H(2) & x(3)+H(3) & x(4)+H(4) & x(5)+H(5) & x(6)+H(6) & x(7)+H(7);
                X    <= H;
                Z    <= 0;
		    end if;
		    
		    if z = 64 then done <= '1'; else done <= '0'; end if;
		 end if;
    end process;
end Behavioral;
