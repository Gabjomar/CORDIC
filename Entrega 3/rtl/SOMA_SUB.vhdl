library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sum_sub is
    generic(
        N : integer := 21
    );
    port(
        A    : in  signed(N-1 downto 0);
        B    : in  signed(N-1 downto 0);
        sinal: in  std_logic;   -- 1 = soma, 0 = sub
        saida: out signed(N-1 downto 0)
    );
end entity;

architecture Behavioral of sum_sub is
begin
	 saida <= a+b when sinal='1' else a-b;
end architecture;
