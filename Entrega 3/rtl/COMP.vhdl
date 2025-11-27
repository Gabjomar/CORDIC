library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comp_unsigned is
    generic(
        N : integer := 5
    );
    port(
        A     : in  std_logic_vector(N-1 downto 0);
        B     : in  std_logic_vector(N-1 downto 0);
        saida : out std_logic -- S = 1 quando A >= B 
    );
end entity;

architecture Behavioral of comp_unsigned is
begin
    saida <= '1' when A = B else '0';
end architecture;

