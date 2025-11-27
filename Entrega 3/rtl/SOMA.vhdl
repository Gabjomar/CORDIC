library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sum is
    generic(
        N : integer := 21 
    );
    port(
        A    : in  signed(N-1 downto 0);
        B    : in  signed(N-1 downto 0);
        saida: out signed(N-1 downto 0)
        --Cout: out std_logic
    );
end entity;

architecture Behavioral of sum is
    --signal temp : unsigned(N downto 0);
begin
    --temp <= unsigned(A) + unsigned(B);
    --S    <= std_logic_vector(temp(N-1 downto 0));
    --Cout <= temp(N);
	 saida <= a + b;
	 
end architecture;

