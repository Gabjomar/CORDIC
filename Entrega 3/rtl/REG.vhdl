library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registrador_n is
    generic(
        N : integer := 21
    );
    port(
        clk   : in  std_logic;
        reset : in  std_logic;             
        enable: in  std_logic;
        D     : in  std_logic_vector(N-1 downto 0);
        Q     : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture Behavioral of registrador_n is
    signal Q_reg : std_logic_vector(N-1 downto 0);
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                Q_reg <= (others => '0');
            elsif enable = '1' then
                Q_reg <= D;
            end if;
        end if;
    end process;

    Q <= Q_reg;

end architecture;

