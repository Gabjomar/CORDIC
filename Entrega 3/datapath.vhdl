library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
port(

	x_in , y_in , z_in: in signed(8 downto 0);
	clock, mode, is_input, is_x_fnal, reset_i, enable_contador, enable_entradas, enable_saidas: in std_logic;

	x_out, y_out, z_out: out signed(20 downto 0);
	end_iteration: out std_logic

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
	signal i:                               unsigned(4 downto 0);
	signal i_mux:                           unsigned(4 downto 0);
	signal sum_sub_sig,op_signal:           std_logic;

	-- LUT
	type lut_array is array (0 to 15) of signed(20 downto 0);
	constant lut_angles : lut_array := (
		"000001100100100001111", -- q5.16 arctan(2^0)
		"000000111011010110001", -- q5.16 arctan(2^-1)
		"000000011111010110110", -- q5.16 arctan(2^-2)
		"000000001111111010101", -- q5.16 arctan(2^-3)
		"000000000111111111010", -- q5.16 arctan(2^-4)
		"000000000011111111111", -- q5.16 arctan(2^-5)
		"000000000001111111111", -- q5.16 arctan(2^-6)
		"000000000000111111111", -- q5.16 arctan(2^-7)
		"000000000000011111111", -- q5.16 arctan(2^-8)
		"000000000000001111111", -- q5.16 arctan(2^-9)
		"000000000000000111111", -- q5.16 arctan(2^-10)
		"000000000000000011111", -- q5.16 arctan(2^-11)
		"000000000000000001111", -- q5.16 arctan(2^-12)
		"000000000000000000111", -- q5.16 arctan(2^-13)
		"000000000000000000101", -- q5.16 arctan(2^-14)
		"000000000000000000001"  -- q5.16 arctan(2^-15)
	);

begin

	-- contador
	mux_cont: entity work.mux_2x1
	generic map(
		n=>5
	)
	port map(
		zero => i,
		one  => (others=>'0'),
		sel  => reset_i,
		saida => i_mux
	);
	contador_i: entity work.cont
	generic map(
		n=>5
	)
	port map(
		entrada => i_mux,
		saida   => i
	);
	comp_i_16: entity work.comp_unsigned
	generic map(
		n=>5
	)
	port map(
		a     => i,
		b     => to_unsigned(16,5),
		saida => end_iteration
	);

	-- sinal para decider de soma ou subtrai x/y/z
	sum_sub_sig <= mode xnor op_signal;

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

	-- se y (mode=0) ou z (mode=1) é >= 0
	comp_y_or_z: entity work.comp_signed
	generic map(
		n=>21
	)
	port map(
		a => y_or_z_mux,
		b => (others=>'0'),
		saida => op_signal
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
	desloc_x: entity work.desloc
	generic map(
		n=>21,
		p=>5
	)
	port map(
		valor  => x_reg,
		desloc => i,
		saida  => x_shift
	);
	desloc_y: entity work.desloc
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
		sinal => sum_sub_sig
	);
	op_y: entity work.sum_sub
	generic map(
		n=>21
	)
	port map(
		a => y_reg,
		b => x_shift,
		saida => y_calc,
		sinal => not sum_sub_sig
	);
	op_z: entity work.sum_sub
	generic map(
		n=>21
	)
	port map(
		a => z_reg,
		b => lut_angles(to_integer(i)),
		saida => z_calc,
		sinal => sum_sub_sig
	);

	-- ajustar x para o caso mode=0
	A <= x_reg sra 1;
	B <= x_reg sra 3;
	C <= x_reg sra 6;
	D <= x_reg sra 9;
	E <= x_reg sra 12;
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
