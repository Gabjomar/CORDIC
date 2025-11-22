library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Q45_to_Q516 is
    port(
        x_in  : in  signed(8 downto 0);  
        y_out : out signed(20 downto 0)  
    );
end entity;

architecture Behavioral of Q45_to_Q516 is
begin
    process(x_in)
        variable temp : signed(20 downto 0);
    begin
        temp := resize(x_in, 21) sll 11;  
        y_out <= temp;
    end process;

end architecture;

