library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity somador_subtrator is
    generic(
        N : integer := 21
    );
    port(
        A   : in  std_logic_vector(N-1 downto 0);
        B   : in  std_logic_vector(N-1 downto 0);
        op  : in  std_logic;   -- 0 = soma, 1 = sub
        S   : out std_logic_vector(N-1 downto 0);
        Cout: out std_logic
    );
end entity;

architecture Behavioral of somador_subtrator is
    signal B_mod : std_logic_vector(N-1 downto 0);
    signal Cin   : std_logic;
    signal temp  : unsigned(N downto 0);
begin

    B_mod <= B xor (N-1 downto 0 => op);
    Cin   <= op;

    temp <= unsigned(A) + unsigned(B_mod) + unsigned(Cin);

    S    <= std_logic_vector(temp(N-1 downto 0));
    Cout <= temp(N);

end architecture;

