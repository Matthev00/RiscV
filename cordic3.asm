.data
prompt:	.asciz	"\n"
.text
.globl _start

_start:
    # inicjalizacja zmiennych
    li a0, 0x4305       # x = 0.5236 w Q15
    li a1, 20         # n = 20
    mv s0, zero       # y = 0 w Q15
    mv s1, a0         # z = x w Q15
    li s2, 0x1921F    # PI w Q15
    li s3, 0x8000     # factor = 1 w Q15

loop:
    # obliczenie k�ta dla aktualnej iteracji
    slli t0, s3, 1     # 2 * factor
    div s7, s2, t0    # atan(2^-i) w Q15
    
    # sprawdzenie znaku z
    slt t1, s1, zero
    bne t1, zero, neg

pos:
    # je�li z >= 0, dodaj k�t do y, odejmij sin(k�ta) od z
    add s0, s0, s7    # y += factor * atan(2^-i)
    mul t2, s7, s3    # factor * sin(atan(2^-i))
    sub s1, s1, t2    # z -= factor * sin(atan(2^-i))
    j cont

neg:
    # je�li z < 0, odejmij k�t od y, dodaj sin(k�ta) do z
    sub s0, s0, s7    # y -= factor * atan(2^-i)
    mul t2, s7, s3    # factor * sin(atan(2^-i))
    add s1, s1, t2    # z += factor * sin(atan(2^-i))

cont:
    # przesu� factor o 1 bit w prawo
    srli s3, s3, 1

    # powtarzaj p�tl� dla pozosta�ych iteracji
    addi a1, a1, -1
    bnez a1, loop

    # wypisz wyniki
    mv a0, s0         # sin(x)
    li a7, 1   # wywo�anie funkcji print
    ecall
    la a0, prompt    # separator nowej linii
    li a7, 4     # wywo�anie funkcji print
    ecall
    sub s0, s2, a0    # PI/2 - x w Q15
    mv a0, s0         # cos(x)
    li a7, 1     # wywo�anie funkcji print
    ecall
    la a0, prompt    # separator nowej linii
    li a7, 4     # wywo�anie funkcji print
    ecall

end:
    # zako�czenie programu
    li a7, 10
    ecall
 
