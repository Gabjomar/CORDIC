library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg is
    generic(
        N : integer := 21
    );
    port(
        clock    : in  std_logic;
        enable : in  std_logic;
        entrada: in  signed(N-1 downto 0);
        saida  : out signed(N-1 downto 0)
    );
end entity;

architecture Behavioral of reg is
    signal Q_reg : signed(N-1 downto 0);
begin

    process(clock)
    begin
        if rising_edge(clock) then
            --if reset = '1' then
            --    Q_reg <= (others => '0');
            if enable = '1' then
                Q_reg <= entrada;
            end if;
        end if;
    end process;

    saida <= Q_reg;

end architecture;

