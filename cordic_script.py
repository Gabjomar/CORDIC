from math import atan

def str_to_float(string):
    try: float(string); return True
    except ValueError: return False

def str_to_int(string):
    try: int(string); return True
    except ValueError: return False

def invalido():
    print('input invalido\n')

# valores constantes
I_FINAL = 16
ARCTANS = [int(atan(2**(-i)) * 2**16) for i in range(I_FINAL)]


while True:

    modo = None

    while True:
        print('0: rotação','1: vetorização',sep='\n')
        print('modo',end=': ')

        modo = input()

        print('')

        if str_to_int(modo):
            modo = int(modo)
            if modo == 0 or modo == 1:
                break
        else:
            invalido()

    x, y, z = None,None,None

    if modo == 0:

        while True:
            print('ângulo θ (em radianos)',end=': ')
            z = input()
            if str_to_float(z):
                z = float(z)
                break
            else:
                invalido()

        # -------------------------
        # Algoritmo do modo Rotação
        # -------------------------

        x = int(0.6072529351 * 2**16)
        y = 0
        z = z * 2**16
        i = 0

        for i in range(I_FINAL):

            if z >= 0:
                x_prox = x - (y>>i)
                y_prox = y + (x>>i)
                z_prox = z - ARCTANS[i]
            else:
                x_prox = x + (y>>i)
                y_prox = y - (x>>i)
                z_prox = z + ARCTANS[i]

            x,y,z = x_prox, y_prox, z_prox

        # convertendo de Q5.16 para número real (debug)
        x_real = x/(2**16)
        y_real = y/(2**16)

        print('')
        print(f'seno(θ) = {y_real}')
        print(f'cosseno(θ) = {x_real}')
        input()

    else:

        while True:
            print('Escreva os valores de x e y separados por um espaço, exemplo: "(x,y): 3 3"')
            print('(x,y)',end=': ')
            x, y = input().split()
            if str_to_float(x) or str_to_float(y):
                x = float(x)
                y = float(y)
                break
            else:
                invalido()

        # -----------------------------
        # Algoritmo do modo Vetorização
        # -----------------------------

        x = int(x * 2**16)
        y = int(y * 2**16)
        z = 0
        i = 0

        for i in range(I_FINAL):

            if y >= 0:
                x_prox = x + (y>>i)
                y_prox = y - (x>>i)
                z_prox = z + ARCTANS[i]
            else:
                x_prox = x - (y>>i)
                y_prox = y + (x>>i)
                z_prox = z - ARCTANS[i]

            x,y,z = x_prox, y_prox, z_prox

        # x vezes K
        x = ( (x >> 1) + (x >> 3) ) - ( ( (x >> 6) + (x >> 9) ) + (x >> 12) )

        # convertendo de Q5.16 para número real (debug)
        x_real = x/(2**16)
        z_real = z/(2**16)

        print('')
        print(f'arctan(y/x) = {z_real} (radianos)')
        print(f'|v| = {x_real}')
        input()
