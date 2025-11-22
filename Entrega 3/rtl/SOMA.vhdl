library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity somador_n is
    generic(
        N : integer := 21 
    );
    port(
        A   : in  std_logic_vector(N-1 downto 0);
        B   : in  std_logic_vector(N-1 downto 0);
        S   : out std_logic_vector(N-1 downto 0);
        Cout: out std_logic
    );
end entity;

architecture Behavioral of somador_n is
    signal temp : unsigned(N downto 0);
begin
    temp <= unsigned(A) + unsigned(B);
    S    <= std_logic_vector(temp(N-1 downto 0));
    Cout <= temp(N);
end architecture;

