library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shift is
    generic(
        N : integer := 21;
        P : integer := 5      
    );
    port(
        valor : in  signed(N-1 downto 0);
        desloc : in  std_logic_vector(P-1 downto 0); 
        saida : out signed(N-1 downto 0)
    );
end entity;

architecture Behavioral of shift is
begin
    saida <= signed(shift_right(valor, to_integer(unsigned(desloc))));
end architecture;

