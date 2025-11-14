# Atividade Prática 3

## Nome do Grupo

AP3-02208A-Grupo-C

## Nome dos Integrantes do Grupo

Gabriel João Martins
Lucas Soares Ramos
Luiz Fernando Mina Gonzaga da Silva
Nathan Santana Schunk
Thiago Ferreira de Castro

## Descrição

Iremos criar um sistema digital que implementa o CORDIC. O CORDIC é um algoritmo que utiliza rotações para calcular um amplo número de funções elementares de forma altamente eficiente no hardware.

Para o algoritmo ser eficiente, ele só utiliza somas, subtrações e shifts. Por exemplo, a função seno e cosseno podem ser calculadas sem utilizar pontos flutuantes, o que deixaria o hardware mais custoso. Outros métodos para calcular essas funções utilizam multiplicações, o que pode deixar o hardware muito ineficiente.

O algoritmo base possui dois modos de operação: Rotação e Vetorização. No modo Rotação, é fornecido um ângulo, a partir dele são computados os valores de seu seno e cosseno. No modo Vetorização, é dado a coordenada (x,y), a partir dela são computados arctan(y/x) (o ângulo entre x e y) e |v| (a norma/extensão do vetor (x,y)).

## Descrição Detalhada da Implementação
Abaixo está o detalhamento dos blocos que compõem o sistema CORDIC.

### Diagrama Top-Level (toplevel.pdf)
A entidade principal CORDIC define a interface do sistema.

* Entradas:
    - clock, reset: Sinais de controle síncrono.
    - x_in, y_in, z_in [9 bits]: Entradas de dados em Q4.5.
    - start [1 bit]: Sinal para iniciar a operação.
    - mode [1 bit]: Seleciona o modo (1 para Rotação, 0 para Vetorização).

* Saídas:
    - x_out, y_out, z_out [21 bits]: Saídas de dados em representação de ponto fixo Q5.16.
    - done [1 bit]: Sinaliza o término do cálculo.

### Bloco de Controle - FSM (FSM.pdf)
O controle é feito por uma Máquina de Estados Finitos (FSM) com 10 estados (S0 a S9).

#### Caminho sempre realizado:
* S0: Estado inicial (idle). Aguarda o sinal start. Zera o contador i e done.
* S1: Estado de decisão: os valores x_in, y_in e z_in são carregados nos registradores e se verifica o bit mode. Caso mode = 1, vai ao estado S2, caso contrário, ao estado S5.

#### Caminho Rotação (mode=1):
* S2: Estado de verificação. Checa a condição z_i >= 0 e se i < 16.
* S3/S4: Estados de iteração. Realizam as operações CORDIC de rotação e incrementam i.
* S9: Estado final da Rotação. Atribui x_out = cos(z) e y_out = sin(z), define done=1 e retorna a S0.

#### Caminho Vetorização (mode=0):
* S5: Estado de verificação. Checa a condição y_i >= 0 e se i < 16.
* S6/S7: Estados de iteração. Realizam as operações CORDIC de vetorização e incrementam i.
* S8: Estado de ajuste. Aplica a multiplicação pela constante K (0.6072...) ao x_i final.
* S9: Estado final da Vetorização. Atribui x_out = magnitude e z_out = arctan(y/x), define done=1 e retorna a S0.

### Bloco Operacional - Datapath (datapath.pdf)
O datapath contém os componentes necessários para os cálculos, controlados pela FSM.

* Registradores: Quatro registradores principais: X_reg, Y_reg, Z_reg e I_reg (contador de iteração).

* Multiplexadores (MUX): Quatro MUXs (MUX_X, MUX_Y, MUX_Z, MUX_I) selecionam se os registradores carregarão os valores iniciais (de x_in, y_in, z_in, 0 ou K) ou o próximo valor calculado (x_next, y_next, z_next, i+1).

* Unidades Lógicas e Aritméticas (ULAs):
    - Somador/Subtrator(es) +/-: Realizam as somas e subtrações necessárias para cada iteração do CORDIC.
    - Shifters (>> i): Implementam a divisão por 2^i (multiplicação por 2^-i) através de deslocamento de bits.
    - Incrementador (+1): Incrementa o contador i.

* Memória/LUT:
    - LUT de Ângulos (ROM): Uma memória Read-Only que armazena os 16 valores pré-calculados de arctan(2^-i).

* Lógica de Multiplicação por K: Um bloco de lógica combinacional (detalhado à direita no diagrama) que multiplica o resultado x pela constante K usando apenas shifters (x_i >> 1, x_i >> 4, etc.) e somadores, evitando um multiplicador de hardware.
