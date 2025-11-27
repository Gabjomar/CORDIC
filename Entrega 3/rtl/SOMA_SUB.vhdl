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
        --Cout: out std_logic
    );
end entity;

architecture Behavioral of sum_sub is
    --signal B_mod : std_logic_vector(N-1 downto 0);
    --signal Cin   : std_logic;
    --signal temp  : unsigned(N downto 0);
begin
	 saida <= a+b when sinal='1' else a-b;
	 
    --B_mod <= B xor (N-1 downto 0 => op);
    --Cin   <= op;

    --temp <= unsigned(A) + unsigned(B_mod) + unsigned(Cin);

    --S    <= std_logic_vector(temp(N-1 downto 0));
    --Cout <= temp(N);

end architecture;

