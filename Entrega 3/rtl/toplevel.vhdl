library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel is
port(

	x_in , y_in , z_in: in std_logic_vector(8 downto 0);
	clock, reset, mode: in std_logic;
	x_out, y_out, z_out: out std_logic_vector(20 downto 0);
	done: out std_logic

);
end toplevel;

architecture behavior of toplevel is

begin

end behavior;
