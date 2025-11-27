library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comp_signed is
    generic(
        N : integer := 21
    );
    port(
        A     : in  signed(N-1 downto 0);
        B     : in  signed(N-1 downto 0);
        saida : out std_logic -- S = 1 quando A >= B 
    );
end entity;

architecture Behavioral of comp_signed is
begin
    saida <= '0' when A < B else '1';
end architecture;

