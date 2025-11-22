library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity subtrator_n is
    generic(
        N : integer := 21 
    );
    port(
        A   : in  std_logic_vector(N-1 downto 0);
        B   : in  std_logic_vector(N-1 downto 0);
        D   : out std_logic_vector(N-1 downto 0);
        Bout: out std_logic
    );
end entity;

architecture Behavioral of subtrator_n is
    signal temp : signed(N downto 0);
begin
    temp <= signed(A) - signed(B);
    D    <= std_logic_vector(temp(N-1 downto 0));
    Bout <= temp(N);  -- overflow
end architecture;

