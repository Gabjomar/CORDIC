library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cordic_rom is
    port(
        addr : in std_logic_vector(4 downto 0);
        data : out signed(20 downto 0)
    );
end entity;

architecture Behavioral of cordic_rom is

    type rom_type is array(0 to 31) of signed(20 downto 0);

    constant tabela : rom_type := (
        0  => to_signed(51471, 21),
        1  => to_signed(30385, 21),
        2  => to_signed(16054, 21),
        3  => to_signed(8149,  21),
        4  => to_signed(4090,  21),
        5  => to_signed(2047,  21),
        6  => to_signed(1023,  21),
        7  => to_signed(511,   21),
        8  => to_signed(255,   21),
        9  => to_signed(127,   21),
        10 => to_signed(63,    21),
        11 => to_signed(31,    21),
        12 => to_signed(15,    21),
        13 => to_signed(7,     21),
        14 => to_signed(3,     21),
        15 => to_signed(1,     21),
        others => to_signed(0, 21)
    );

begin
    data <= tabela(to_integer(unsigned(addr)));
end architecture;
