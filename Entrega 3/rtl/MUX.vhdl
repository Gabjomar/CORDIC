library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_n_bits is
    generic(
        N : integer := 21
    );
    port(
        A   : in  std_logic_vector(N-1 downto 0);
        B   : in  std_logic_vector(N-1 downto 0);
        sel : in  std_logic;
        Y   : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture Behavioral of mux_n_bits is
begin
    Y <= A when sel = '0' else B;
end architecture;

