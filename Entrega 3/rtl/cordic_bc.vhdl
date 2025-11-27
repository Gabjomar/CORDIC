--------------------------------------------------
--	Author:      Gabriel João Martins
--	Created:     November 16, 2025
--
--	Project:     Bloco de controle do CORDIC
--	Description: Contém a descrição que representa o bloco de controle (BC) do sistema que realizar o algoritmo CORDIC.
--------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity cordic_bc is
    port(
        clock : in std_logic; -- Borda de subida que é a borda ativa do clock
        reset : in std_logic; -- Reset assíncrono
        start : in std_logic;
        mode : in std_logic; -- Vetorização = 0 e Rotação = 1

        signal_equal_or_higher_than_zero : in std_logic; -- Sinal novo que precisará ser criado
        end_iteration : in std_logic;

        enable_saidas : out std_logic;
        enable_contador : out std_logic;
        enable_entradas : out std_logic;
        reset_i : out std_logic;
        is_input : out std_logic;
        mode_to_datapath : out std_logic; -- Vetorização = 0 e Rotação = 1

        done : out std_logic;
    );
end entity cordic_bc;

architecture behavior of cordic_bc is
	TYPE Tipo_estado IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9);
	SIGNAL EstadoAtual, ProximoEstado: Tipo_estado;

begin

    -- 1) Processo de troca de estado (registrador de estado)
    -- Atualiza o estado da FSM a cada borda de subida do clock ou quando o reset é acionado
    Troca_Estado: PROCESS(clock, reset)
    begin 
        if reset = '1' then
            EstadoAtual <= S0;
        elsif (rising_edge(clock)) then
            EstadoAtual <= ProximoEstado;
        end if;
    end process Troca_Estado;

    -- 2) Lógica de Próximo Estado (LPE)
    -- Define se o circuito está em execução (running) e qual o próximo ciclo
    Logica_Proximo_Estado: PROCESS(start, EstadoAtual, mode)
    BEGIN
        CASE EstadoAtual IS
            WHEN S0 =>
                IF start = '0' THEN
                    ProximoEstado <= S0; 
                ELSIF start = '1' THEN 
                    ProximoEstado <= S1;              
                END IF;
            WHEN S1 =>
                IF mode = '0' THEN
                    ProximoEstado <= S5; 
                ELSIF mode = '1' THEN 
                    ProximoEstado <= S2;              
                END IF;
            WHEN S2 =>
                IF end_iteration = '1' THEN
                    ProximoEstado <= S9; 
                ELSIF signal_equal_or_higher_than_zero = '0' THEN
                    ProximoEstado <= S3;          
                ELSIF signal_equal_or_higher_than_zero = '1' THEN
                    ProximoEstado <= S4;       
                END IF;
            WHEN S3 =>
                ProximoEstado <= S2;    
            WHEN S4 =>
                ProximoEstado <= S2;   
            WHEN S5 =>
                IF end_iteration = '1' THEN
                    ProximoEstado <= S8; 
                ELSIF signal_equal_or_higher_than_zero = '0' THEN
                    ProximoEstado <= S6;          
                ELSIF signal_equal_or_higher_than_zero = '1' THEN
                    ProximoEstado <= S7;       
                END IF;
            WHEN S6 =>
                ProximoEstado <= S5; 
            WHEN S7 =>
                ProximoEstado <= S5;
            WHEN S8 =>
                ProximoEstado <= S9;
            WHEN S9 =>
                ProximoEstado <= S0;                 
        END CASE;
    END PROCESS Logica_Proximo_Estado;

    -- 3) Lógica de Saída (LS)
    -- Calcula o próximo endereço de leitura, quando acionar leitura e início de bloco
    Logica_Saida: PROCESS(EstadoAtual)
    BEGIN
        case EstadoAtual is
            when S0 =>
                enable_saidas <= '0';
                enable_contador <= '0';
                enable_entradas <= '0';
                reset_i <= '0';
                is_input <= '0';
                mode_to_datapath <= '0';
                done <= '0';            
            when S1 =>
                enable_saidas <= '0';
                enable_contador <= '1';
                enable_entradas <= '1';
                reset_i <= '1';
                is_input <= '1';
                mode_to_datapath <= '0';
                done <= '0';
            when S2 =>
                enable_saidas <= '0';
                enable_contador <= '0';
                enable_entradas <= '0';
                reset_i <= '0';
                is_input <= '0';
                mode_to_datapath <= '1';
                done <= '0';  
            when S3 =>
                enable_saidas <= '0';
                enable_contador <= '1';
                enable_entradas <= '0';
                reset_i <= '0';
                is_input <= '0';
                mode_to_datapath <= '1';
                done <= '0';  
            when S4 =>
                enable_saidas <= '0';
                enable_contador <= '1';
                enable_entradas <= '0';
                reset_i <= '0';
                is_input <= '0';
                mode_to_datapath <= '1';
                done <= '0';  
            when S5 =>
                enable_saidas <= '0';
                enable_contador <= '0';
                enable_entradas <= '0';
                reset_i <= '0';
                is_input <= '0';
                mode_to_datapath <= '0';
                done <= '0';  
            when S6 =>
                enable_saidas <= '0';
                enable_contador <= '1';
                enable_entradas <= '0';
                reset_i <= '0';
                is_input <= '0';
                mode_to_datapath <= '0';
                done <= '0';  
            when S7 =>
                enable_saidas <= '0';
                enable_contador <= '1';
                enable_entradas <= '0';
                reset_i <= '0';
                is_input <= '0';
                mode_to_datapath <= '0';
                done <= '0';  
            when S8 =>
                enable_saidas <= '0';
                enable_contador <= '0';
                enable_entradas <= '0';
                reset_i <= '0';
                is_input <= '0';
                mode_to_datapath <= '0';
                done <= '0'; 
            when S9 =>
                enable_saidas <= '1';
                enable_contador <= '0';
                enable_entradas <= '0';
                reset_i <= '0';
                is_input <= '0';
                mode_to_datapath <= '0';
                done <= '1';  
        end case;
    END PROCESS Logica_Saida;

end architecture behavior;

