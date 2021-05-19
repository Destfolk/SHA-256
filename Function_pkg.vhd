library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;

package Function_pkg is

    function std2int   ( val : std_logic_vector ) return integer;
    function int2std64 ( length : integer ) return std_logic_vector;
     
    function Ch     ( A, B, C : std_logic_vector(31 downto 0)) return std_logic_vector;
    function Maj    ( A, B, C : std_logic_vector(31 downto 0)) return std_logic_vector;
    function SUM0   ( A : std_logic_vector(31 downto 0))       return std_logic_vector;
    function SUM1   ( A : std_logic_vector(31 downto 0))       return std_logic_vector;
    function Sigma0 ( A : std_logic_vector(31 downto 0))       return std_logic_vector;
    function Sigma1 ( A : std_logic_vector(31 downto 0))       return std_logic_vector;
    
    type Array_32x8   is array (0 to  7) of std_logic_vector(31 downto 0);
    type Array_32x16  is array (0 to 15) of std_logic_vector(31 downto 0);
    type Array_32x64  is array (0 to 63) of std_logic_vector(31 downto 0);

end Function_pkg;

package body Function_pkg is

    function int2std64 ( length : integer ) return std_logic_vector is
    begin
        return std_logic_vector(to_unsigned(length, 64));
    end int2std64;  
    
    function std2int (val : std_logic_vector ) return integer is
    begin
        return to_integer(unsigned(val));
    end std2int;  
    
    function Ch ( A, B, C : std_logic_vector(31 downto 0)) return std_logic_vector is
    begin
        return std_logic_vector((A and B) xor (not A and C));
    end Ch;

    function Maj ( A, B, C : std_logic_vector(31 downto 0)) return std_logic_vector is
    begin
        return std_logic_vector((A and B) xor (A and C) xor (B and C));
    end Maj;
    
    function SUM0 ( A : std_logic_vector(31 downto 0)) return std_logic_vector is
    begin
        return std_logic_vector((A(1 downto 0) & A(31 downto 2)) xor (A(12 downto 0) & A(31 downto 13)) xor (A(21 downto 0) & A(31 downto 22)));
    end SUM0;
    
    function SUM1 ( A : std_logic_vector(31 downto 0)) return std_logic_vector is
    begin
        return std_logic_vector((A(5 downto 0) & A(31 downto 6)) xor (A(10 downto 0) & A(31 downto 11)) xor (A(24 downto 0) & A(31 downto 25)));
    end SUM1;  
    
    function Sigma0 ( A : std_logic_vector(31 downto 0)) return std_logic_vector is
    begin
        return std_logic_vector((A(6 downto 0) & A(31 downto 7)) xor (A(17 downto 0) & A(31 downto 18)) xor ("000" & A(31 downto 3)));
    end Sigma0;
    
    function Sigma1 ( A : std_logic_vector(31 downto 0)) return std_logic_vector is
    begin
        return std_logic_vector((A(16 downto 0) & A(31 downto 17)) xor (A(18 downto 0) & A(31 downto 19)) xor ("0000000000" & A(31 downto 10)));
    end Sigma1;
    
end package body;
