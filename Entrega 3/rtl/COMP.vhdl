library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparador is
    generic(
        N : integer := 5
    );
    port(
        A  : in  std_logic_vector(N-1 downto 0);
        B  : in  std_logic_vector(N-1 downto 0);
        S : out std_logic               -- S = 1 quando A >= B 
    );
end entity;

architecture Behavioral of comparador is
begin
    S <= '0' when unsigned(A) < unsigned(B) else '1';
end architecture;

