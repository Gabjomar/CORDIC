library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity mux_2x1 is
    generic(
        N : integer := 21
    );
    port(
        zero : in  signed(N-1 downto 0);
        one  : in  signed(N-1 downto 0);
        sel  : in  std_logic;
        saida: out signed(N-1 downto 0)
    );
end entity;

architecture Behavioral of mux_2x1 is
begin
    saida <= zero when sel = '0' else one;
end architecture;

