library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel is
port(

	x_in , y_in , z_in: in std_logic_vector(8 downto 0);
	clock, reset, mode, start: in std_logic;
	x_out, y_out, z_out: out std_logic_vector(20 downto 0);
	done: out std_logic

);
end toplevel;

architecture behavior of toplevel is

	signal mode_to_datapath: std_logic;
	signal enable_contador,enable_saidas,enable_entradas: std_logic;
	signal op_signal: std_logic;
	signal reset_i, is_input: std_logic;
	signal end_iteration: std_logic;
	signal signal_equal_or_higher_than_zero: std_logic;
	signal x_out_signed, y_out_signed, z_out_signed: signed(20 downto 0);
	
begin

	x_out <= std_logic_vector(x_out_signed);
	y_out <= std_logic_vector(y_out_signed);
	z_out <= std_logic_vector(z_out_signed);
	
	datapath: entity work.datapath
	port map(
	
		clock => clock,
		x_in => signed(x_in),
		y_in => signed(y_in),
		z_in => signed(z_in),
		
		x_out => x_out_signed,
		y_out => y_out_signed,
		z_out => z_out_signed,
		--------------------------------
		op_signal => op_signal,
		is_input => is_input, 
		reset_i => reset_i,

		mode => mode_to_datapath,
		enable_contador => enable_contador, 
		enable_entradas => enable_entradas, 
		enable_saidas => enable_saidas,
		end_iteration => end_iteration,
		signal_equal_or_higher_than_zero => signal_equal_or_higher_than_zero
	
	);
	
	controle: entity work.cordic_bc
	port map(
	
		clock => clock,
		reset => reset,
		start => start,
		mode => mode,
		
		done => done,
		-----------------------------------
		end_iteration => end_iteration,
		signal_equal_or_higher_than_zero => signal_equal_or_higher_than_zero,

		enable_contador => enable_contador, 
		enable_entradas => enable_entradas, 
		enable_saidas => enable_saidas,
		mode_to_datapath => mode_to_datapath,
		op_signal => op_signal,
		reset_i => reset_i,
		is_input => is_input
	
	);
	
end behavior;
