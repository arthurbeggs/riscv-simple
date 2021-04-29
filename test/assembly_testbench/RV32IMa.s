#################################################
#   Testbench para a ISA RV32IM
#  Baseado no trabalho:
#
#
# Marcus Vinicius Lamar
# 2020/1
#################################################

# Versão que usa os contadores do CSR

.data
MSG:    .string "Endereco do erro : "
MSG2:   .string "RV32IM - Nao ha erros :)"

# Include macros (.text inside macros file)
.include "../../system/MACROSv21.s"

    li a0, 0x38
    li a1, 0
    li a7, 148
    ecall

    li a3,0x3800        #print string sucesso
    li a7, 104
    la a0, MSG2
    li a1, 64
    li a2, 0
    li a4, 0
    ecall

    li s11, 3000    # contador de Loops
    rdtime s10  # le o tempo inicial
    rdinstret s8    # le o numero de instruções inicial

MAIN:   li t0, -1
    li t1, -1
    li t2, 1
    mul t0,t0,t1            # testa MUL
    beq t0, t2, PULAERRO1
    jal t0, ERRO

PULAERRO1: li t0, -1
    li t1, -1
    li t2, 0
    mulh t0, t0, t1         # testa MULH
    beq t0, t2, PULAERRO2
    jal t0, ERRO

PULAERRO2: li t0, -1
    li t1, -1
    li t2, 0xFFFFFFFE
    mulhu t0, t0, t1        # testa MULHU
    beq t0, t2, PULAERRO3
    jal t0, ERRO

PULAERRO3: li t0, -1
    li t1, -1
    li t2, 0xFFFFFFFF
    mulhsu t0, t0, t1       # testa MULHSU
    beq t0, t2, PULAERRO4
    jal t0, ERRO

PULAERRO4: li t0, -7
    li t1, 2
    li t2, -3
    div t0, t0, t1          # testa DIV
    beq t0, t2, PULAERRO5
    jal t0, ERRO

PULAERRO5: li t0, -7
    li t1, 2
    li t2, 0x7FFFFFFC
    divu t0, t0, t1         # testa DIVU
    beq t0, t2, PULAERRO6
    jal t0, ERRO

PULAERRO6: li t0, -7
    li t1, 2
    li t2, -1
    rem t0, t0, t1          # testa REM
    beq t0, t2, PULAERRO7
    jal t0, ERRO

PULAERRO7: li t0, -7
    li t1, 3
    li t2, 0x00000000
    remu t0, t0, t1         # testa REMU
    beq t0, t2, SUCESSO
    jal t0, ERRO


SUCESSO: addi s11,s11,-1
     bne s11,zero,MAIN
     rdtime s9
     rdinstret s7

    sub a0,s7,s8
    li a7, 101
    li a1, 0
    li a2, 0
    li a3, 0x3800
    li a4, 0
    ecall

    sub a0,s9,s10
    li a7, 101
    li a1, 272
    li a2, 0
    li a3, 0x3800
    li a4, 0
    ecall

    j END

ERRO:   li a0, 0x07
    li a7, 148
    li a1, 0
    ecall

    #Print string erro
    li a7, 104
    la a0, MSG
    li a1, 0
    li a2, 0
    li a3, 0x0700
    li a4, 0
    ecall

    #print endereco erro
    addi a0, t0, -12 #Endereco onde ocorreu o erro
    li a7, 134
    li a1, 148
    li a2, 0
    li a3, 0x0700
    li a4, 0
    ecall

END:    addi a7, zero, 10
    ecall

.include "../../system/SYSTEMv21.s"

