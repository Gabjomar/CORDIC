library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shift_right_n is
    generic(
        N : integer := 21;
        M : integer := 5      
    );
    port(
        x : in  std_logic_vector(N-1 downto 0);
        i : in  std_logic_vector(M-1 downto 0); 
        y : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture Behavioral of shift_right_n is
begin
    y <= std_logic_vector(shift_right(unsigned(x), to_integer(unsigned(i))));
end architecture;

