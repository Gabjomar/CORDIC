library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.finish;

entity toplevel_tb is
end toplevel_tb;

architecture sim of toplevel_tb is

    -- DUT inputs
    signal clock  : std_logic := '0';
    signal reset  : std_logic := '0';
    signal start  : std_logic := '0';
    signal mode   : std_logic := '0';   -- 0 = vectoring, 1 = rotation
    signal x_in   : std_logic_vector(8 downto 0) := (others => '0');
    signal y_in   : std_logic_vector(8 downto 0) := (others => '0');
    signal z_in   : std_logic_vector(8 downto 0) := (others => '0');

    -- DUT outputs
    signal x_out  : std_logic_vector(20 downto 0);
    signal y_out  : std_logic_vector(20 downto 0);
    signal z_out  : std_logic_vector(20 downto 0);
    signal done   : std_logic;

begin

    dut: entity work.toplevel
    port map(
        x_in => x_in,
        y_in => y_in,
        z_in => z_in,
        clock => clock,
        reset => reset,
        mode => mode,
        start => start,
        x_out => x_out,
        y_out => y_out,
        z_out => z_out,
        done => done
    );

    -- clock: 10 ns
    clock <= not clock after 5 ns;

    -- estimulo
    stim: process
    begin
        -- reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 10 ns;

		-- teste input
        x_in <= std_logic_vector(to_signed(100, 9));
        y_in <= std_logic_vector(to_signed(100, 9));
        z_in <= std_logic_vector(to_signed(0,   9));

        mode <= '0';  -- vetorização
        wait for 20 ns;

        -- start
        start <= '1';
        wait for 10 ns;
        start <= '0';

        -- wait until done = '1'
        wait until done = '1';

        finish;

    end process;

end architecture sim;
