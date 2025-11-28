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

		------------------------------------------
		-- Testar modo Vetorização (mode = '0') --
		------------------------------------------

		x_in <= std_logic_vector(to_signed(96,  9)); -- 3 em Q4.5
		y_in <= std_logic_vector(to_signed(128, 9)); -- 4 em Q4.5
		z_in <= std_logic_vector(to_signed(0,   9));

		mode <= '0';
		wait for 20 ns;

		-- start
		start <= '1';
		wait for 10 ns;
		start <= '0';

		-- wait until done = '1'
		wait until done = '1';

		wait for 50 ns;

		report "";
		report "MODO VETORIZACAO (mode = 0)";
		report "";
		report "    Entradas:";
		report "        em decimal (Q4.5):";
		report "            x_in = " & integer'image(to_integer(signed(x_in)));
		report "            y_in = " & integer'image(to_integer(signed(y_in)));
		report "            z_in = " & integer'image(to_integer(signed(z_in))) & " (tanto faz o valor aqui)";
		report "        em valor real:";
		report "            x_in = " & real'image(real(to_integer(signed(x_in))) / 32.0);
		report "            y_in = " & real'image(real(to_integer(signed(y_in))) / 32.0);
		report "            z_in = " & real'image(real(to_integer(signed(z_in))) / 32.0);
		report "";
		report "    Saidas:";
		report "        em decimal (Q5.16):";
		report "            x_out = " & integer'image(to_integer(signed(x_out)));
		report "            y_out = " & integer'image(to_integer(signed(y_out)));
		report "            z_out = " & integer'image(to_integer(signed(z_out)));
		report "        em valor real:";
		report "            x_out = " & real'image(real(to_integer(signed(x_out))) / 65536.0); -- 2^(-16) = 65536
		report "            y_out = " & real'image(real(to_integer(signed(y_out))) / 65536.0); -- 2^(-16) = 65536
		report "            z_out = " & real'image(real(to_integer(signed(z_out))) / 65536.0); -- 2^(-16) = 65536
		report "";
		report "    Interpretação dos valores:";
		report "        x_out:";
		report "            1) x_out = ||v|| = sqrt(x^2 + y^2) = hipotenusa";
		report "            2) nesse caso, os catetos foram 3 e 4, e cálculo da hipotenusa foi " & real'image(real(to_integer(signed(x_out))) / 65536.0) & " que é o valor aproximado para 5 que o algorítmo conseguiu calcular";
		report "        y_out:";
		report "            1) y_out = arctan(y/x)";
		report "            1) nesse caso, o ângulo referente calculado foi " & real'image(real(to_integer(signed(y_out))) / 65536.0) & ", tirando da notação cientifica fica representado como aproximadamente 0.927307 radianos, o que se refere ao ângulo aproximado de 53.13°";

		-- --------------------------------------
		-- -- Testar o modo Rotação (mode = 1) --
		-- --------------------------------------

		x_in <= std_logic_vector(to_signed(0, 9));
		      y_in <= std_logic_vector(to_signed(0, 9));
		      z_in <= std_logic_vector(to_signed(25, 9)); -- 0.78125 radianos em Q4.5 (aproximadamente 45° graus).

		      mode <= '1';  -- Rotação
		      wait for 20 ns;

		      -- start
		      start <= '1';
		      wait for 10 ns;
		      start <= '0';

		      -- wait until done = '1'
		      wait until done = '1';

		wait for 50 ns;

		report "";
		report "MODO ROTACAO (mode = 1)";
		report "";
		report "    Entradas:";
		report "        em decimal (Q4.5):";
		report "            x_in = " & integer'image(to_integer(signed(x_in))) & " (tanto faz o valor aqui)";
		report "            y_in = " & integer'image(to_integer(signed(y_in))) & " (tanto faz o valor aqui)";
		report "            z_in = " & integer'image(to_integer(signed(z_in)));
		report "        em valor real:";
		report "            x_in = " & real'image(real(to_integer(signed(x_in))) / 32.0);
		report "            y_in = " & real'image(real(to_integer(signed(y_in))) / 32.0);
		report "            z_in = " & real'image(real(to_integer(signed(z_in))) / 32.0);
		report "";
		report "    Saidas:";
		report "        em decimal (Q5.16):";
		report "            x_out = " & integer'image(to_integer(signed(x_out)));
		report "            y_out = " & integer'image(to_integer(signed(y_out)));
		report "            z_out = " & integer'image(to_integer(signed(z_out)));
		report "        em valor real:";
		report "            x_out = " & real'image(real(to_integer(signed(x_out))) / 65536.0); -- 2^(-16) = 65536
		report "            y_out = " & real'image(real(to_integer(signed(y_out))) / 65536.0); -- 2^(-16) = 65536
		report "            z_out = " & real'image(real(to_integer(signed(z_out))) / 65536.0); -- 2^(-16) = 65536
		report "";
		report "    Interpretação dos valores:";
		report "        x_out:";
		report "            1) x_out = cos(z_in)";
		report "            2) representando sem a notação cientifica, cos(z_in) = 0.7100372314453125, o que é aproximadamente sqrt(2)/2";
		report "        y_out:";
		report "            1) y_out = sen(z_in)";
		report "            2) representando sem a notação cientifica, sen(z_in) = 0.704132080078125, o que é aproximadamente sqrt(2)/2";

		finish;

    end process;

end architecture sim;
