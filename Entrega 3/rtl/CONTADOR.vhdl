library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador_n is
    generic(
        N : integer := 5   
    );
    port(
        clk   : in  std_logic;
        reset : in  std_logic;  
        enable: in  std_logic;
        Q     : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture Behavioral of contador_n is
    signal conta : unsigned(N-1 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                conta <= (others => '0');
            elsif enable = '1' then
                conta <= conta + 1;     
            end if;
        end if;
    end process;

    Q <= std_logic_vector(conta);

end architecture;

