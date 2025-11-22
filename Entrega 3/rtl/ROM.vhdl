library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cordic_rom is
    port(
        addr : in  unsigned(4 downto 0);    
        data : out signed(20 downto 0)      
    );
end entity;

architecture Behavioral of cordic_rom is

    type rom_type is array(0 to 31) of signed(20 downto 0);

    constant tabela : rom_type := (
        0  => to_signed(51472, 21),
        1  => to_signed(30386, 21),
        2  => to_signed(16055, 21),
        3  => to_signed(8150,  21),
        4  => to_signed(4091,  21),
        5  => to_signed(2047,  21),
        6  => to_signed(1024,  21),
        7  => to_signed(512,   21),
        8  => to_signed(256,   21),
        9  => to_signed(128,   21),
        10 => to_signed(64,    21),
        11 => to_signed(32,    21),
        12 => to_signed(16,    21),
        13 => to_signed(8,     21),
        14 => to_signed(4,     21),
        15 => to_signed(2,     21),
        others => to_signed(0, 21)
    );

begin
    data <= tabela(to_integer(addr));
end architecture;

