library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Q45_to_Q516 is
    port(
        entrada  : in  signed(8 downto 0);  
        saida : out signed(20 downto 0)  
    );
end entity;

architecture Behavioral of Q45_to_Q516 is
begin
    process(entrada)
        variable temp : signed(20 downto 0);
    begin
        temp := resize(entrada, 21) sll 11;  
        saida <= temp;
    end process;

end architecture;

