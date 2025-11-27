library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cont is
    generic(
        N : integer := 5   
    );
    port(
        clock   : in  std_logic;
        reset : in  std_logic;  
        enable: in  std_logic;
        saida : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture Behavioral of cont is
    signal conta : unsigned(N-1 downto 0) := (others => '0');
begin

    process(clock)
    begin
        if rising_edge(clock) then
            if reset = '1' then
                conta <= (others => '0');
            elsif enable = '1' then
                conta <= conta + 1;     
            end if;
        end if;
    end process;

    saida <= std_logic_vector(conta);

end architecture;

