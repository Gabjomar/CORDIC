library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
port(

	x_in , y_in , z_in: in signed(8 downto 0);
	clock, mode, is_input, op_signal, reset_i, enable_contador, enable_entradas, enable_saidas: in std_logic;

	x_out, y_out, z_out: out signed(20 downto 0);
	end_iteration, signal_equal_or_higher_than_zero: out std_logic

);
end datapath;

architecture behavior of datapath is

	signal x_21,y_21,z_21:                  signed(20 downto 0);
	signal x_reg,y_reg,z_reg:               signed(20 downto 0);
	signal x_mux, y_mux, z_mux:             signed(20 downto 0);
	signal x_shift, y_shift:                signed(20 downto 0);
	signal x_calc, y_calc, z_calc:          signed(20 downto 0);
	signal x_out_mux, y_out_mux, z_out_mux: signed(20 downto 0);
	signal A,B,C,D,E,AB,CD,CDE,x_ajustado:  signed(20 downto 0);
	signal y_or_z_mux:                      signed(20 downto 0);
	signal i:                               std_logic_vector(4 downto 0);
	signal i_mux:                           std_logic_vector(4 downto 0);
	signal arctan:                          signed(20 downto 0);   
	
begin

	-- contador	
	contador_i: entity work.cont
	generic map(
		n=>5
	)
	port map(
		clock => clock,
		enable => enable_contador,
		reset => reset_i,
		saida => i
	);
	
	comp_i_16: entity work.comp_unsigned
	generic map(
		n=>5
	)
	port map(
		a     => i,
		b     => "10000",
		saida => end_iteration
	);

	-- decidir se compara x ou y no comparador (>= 0)
	mux_x_or_y: entity work.mux_2x1
	generic map(
		n=>21
	)
	port map(
		zero  => y_reg,
		one   => z_reg,
		sel   => mode,
		saida => y_or_z_mux
	);

	-- se y (mode_to_datapath=0) ou z (mode_to_datapath=1) é >= 0
	comp_y_or_z: entity work.comp_signed
	generic map(
		n=>21
	)
	port map(
		a => y_or_z_mux,
		b => (others=>'0'),
		saida => signal_equal_or_higher_than_zero
	);

	-- 9bits para 21bits
	expand_x: entity work.q45_to_q516
	port map(
		entrada => x_in,
		saida   => x_21
	);
	expand_y: entity work.q45_to_q516
	port map(
		entrada => y_in,
		saida   => y_21
	);
	expand_z: entity work.q45_to_q516
	port map(
		entrada => z_in,
		saida   => z_21
	);

	-- input ou iteração
	mux_x_in_or_not: entity work.mux_2x1
	generic map(
		n=>21
	)
	port map(
		zero  => x_calc,
		one   => x_21,
		sel   => is_input,
		saida => x_mux
	);
	mux_y_in_or_not: entity work.mux_2x1
	generic map(
		n=>21
	)
	port map(
		zero  => y_calc,
		one   => y_21,
		sel   => is_input,
		saida => y_mux
	);
	mux_z_in_or_not: entity work.mux_2x1
	generic map(
		n=>21
	)
	port map(
		zero  => z_calc,
		one   => z_21,
		sel   => is_input,
		saida => z_mux
	);

	-- registradores em que se armazenam os resultados da iteração
	reg_para_x: entity work.reg
	generic map(
		n=>21
	)
	port map(
		entrada => x_mux,
		saida   => x_reg,
		clock   => clock,
		enable  => enable_entradas
	);
	reg_para_y: entity work.reg
	generic map(
		n=>21
	)
	port map(
		entrada => y_mux,
		saida   => y_reg,
		clock   => clock,
		enable  => enable_entradas
	);
	reg_para_z: entity work.reg
	generic map(
		n=>21
	)
	port map(
		entrada => z_mux,
		saida   => z_reg,
		clock   => clock,
		enable  => enable_entradas
	);

	-- x>>i; y>>i
	desloc_x: entity work.shift
	generic map(
		n=>21,
		p=>5
	)
	port map(
		valor  => x_reg, --unsigned
		desloc => i, --std_logic_vector
		saida  => x_shift --unsigned
	);
	desloc_y: entity work.shift
	generic map(
		n=>21,
		p=>5
	)
	port map(
		valor  => y_reg,
		desloc => i,
		saida  => y_shift
	);

	-- operações +/-
	op_x: entity work.sum_sub
	generic map(
		n=>21
	)
	port map(
		a => x_reg,
		b => y_shift,
		saida => x_calc,
		sinal => op_signal
	);
	
	op_y: entity work.sum_sub
	generic map(
		n=>21
	)
	port map(
		a => y_reg,
		b => x_shift,
		saida => y_calc,
		sinal => not op_signal
	);
	
	op_z: entity work.sum_sub
	generic map(
		n=>21
	)
	port map(
		a => z_reg,
		b => arctan,
		saida => z_calc,
		sinal => op_signal
	);

	--LUT
	rom: entity work.cordic_rom
   port map(
        addr => i,  
        data => arctan   
   );
	
	
	-- ajustar x para o caso mode_to_datapath=0
	A <= shift_right(x_reg, 1);
	B <= shift_right(x_reg, 3);
	C <= shift_right(x_reg, 6);
	D <= shift_right(x_reg, 9);
	E <= shift_right(x_reg, 12);
	
	sum_A_B: entity work.sum
	generic map(
		n=>21
	)
	port map(
		a     => A,
		b     => B,
		saida => AB
	);
	sum_C_D: entity work.sum
	generic map(
		n=>21
	)
	port map(
		a     => C,
		b     => D,
		saida => CD
	);
	sum_CD_E: entity work.sum
	generic map(
		n=>21
	)
	port map(
		a     => CD,
		b     => E,
		saida => CDE
	);
	sub_AB_CDE: entity work.sub
	generic map(
		n=>21
	)
	port map(
		a     => AB,
		b     => CDE,
		saida => x_ajustado
	);

	-- muxes das saídas
	mux_x_out: entity work.mux_2x1
	generic map(
		n=>21
	)
	port map(
		zero  => x_ajustado,
		one   => x_reg,
		sel   => mode,
		saida => x_out_mux
	);
	mux_y_out: entity work.mux_2x1
	generic map(
		n=>21
	)
	port map(
		zero  => (others=>'0'),
		one   => y_reg,
		sel   => mode,
		saida => y_out_mux
	);
	mux_z_out: entity work.mux_2x1
	generic map(
		n=>21
	)
	port map(
		zero  => z_reg,
		one   => (others=>'0'),
		sel   => mode,
		saida => z_out_mux
	);

	-- saídas

	reg_x_out: entity work.reg
	generic map(
		n=>21
	)
	port map(
		entrada => x_out_mux,
		saida   => x_out,
		clock   => clock,
		enable  => enable_saidas
	);
	reg_y_out: entity work.reg
	generic map(
		n=>21
	)
	port map(
		entrada => y_out_mux,
		saida   => y_out,
		clock   => clock,
		enable  => enable_saidas
	);
	reg_z_out: entity work.reg
	generic map(
		n=>21
	)
	port map(
		entrada => z_out_mux,
		saida   => z_out,
		clock   => clock,
		enable  => enable_saidas
	);

end behavior;
