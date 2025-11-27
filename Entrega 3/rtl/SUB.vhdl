library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sub is
    generic(
        N : integer := 21 
    );
    port(
        A    : in  signed(N-1 downto 0);
        B    : in  signed(N-1 downto 0);
        saida: out signed(N-1 downto 0)
        --Bout: out std_logic
    );
end entity;

architecture Behavioral of sub is
    --signal temp : signed(N downto 0);
begin
    --temp <= signed(A) - signed(B);
    --D    <= std_logic_vector(temp(N-1 downto 0));
    --Bout <= temp(N);  -- overflow
	 saida <= a - b;
end architecture;

