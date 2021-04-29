#################################################
#   Testbench para a ISA RV32I
#  Baseado no trabalho:
#
# Versão que usa os contadores do CSR
#
# Marcus Vinicius Lamar
# 2020/1
#################################################


.data
N:      .word 5
N2:     .word 10
N3:     .word 0
NH:     .half 2
NH1:    .half 0
NB:     .byte 2
NB1:    .byte 0
MSG:    .string "Endereco do erro : "
MSG2:   .string "RV32I - Nao ha erros :)"

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

    li s11,1000 # contador de loop
    rdtime s10  # le o tempo inicial
    rdinstret s8    # le o numero de instruções inicial

MAIN:   la t1, N    # t1 = N  testa AUIPC e ADDI
    lw t0, 0(t1)    # testa LW
    sw t0, 8(t1)    # testa SW
    lw t0, 8(t1)    # testa LW
    bne t0, zero, PULAERRO1 #testa BNE
    jal t0, ERRO    # testa JAL

PULAERRO1: li t1, 10
    add t0, t0, t0  #t0 = 5 + 5 # testa ADD
    beq t0, t1, PULAERRO2
    jal t0, ERRO

PULAERRO2: sub t0, t0, t0 #t0 = 0   # testa SUB
    beq t0, zero, PULAERRO3
    jal t0, ERRO

PULAERRO3: li t0, 5
    and t0, t0, zero #and t0, 0 = 0 # testa AND
    beq t0, zero, PULAERRO4
    jal t0, ERRO

PULAERRO4: li t0, 1
    li t1, 0
    li t2, 1
    or t0, t0, t1 #or, t0, t1 = 1   # testa OR
    beq t0, t2, PULAERRO5
    jal t0, ERRO

PULAERRO5: li t0, 1
    li t1, 1
    li t2, 0
    xor t0, t0, t1 #xor, t0, t1 = 0 # testa XOR
    beq t0, t2, PULAERRO6
    jal t0, ERRO

PULAERRO6: li t0, 5
    li t1, 3
    slt t0, t0, t1 #t0 < t1 = 0 # testa SLT
    beq t0, zero, PULAERRO7
    jal t0, ERRO

PULAERRO7: li t0, -5
    li t1, 3
    li t2, 1
    sltu t0, t1, t0 #t1 < t0 = 1    # testa SLTU
    beq t0, t2, PULAERRO8
    jal t0, ERRO

PULAERRO8: li t0, 4
    li t1, 1
    li t2, 8
    sll t0, t0, t1 #t0 = t0 << t1   # testa SLL
    beq t0, t2, PULAERRO9 #t0 = 8

PULAERRO9: li t0, 4
    li t1, 1
    li t2, 2
    srl t0, t0, t1          # testa SRL
    beq t0, t2, PULAERRO10
    jal t0, ERRO

PULAERRO10: li t0, 4
    li t1, 1
    li t2, 2
    sra t0, t0, t1          # testa SRA
    beq t0, t2, PULAERRO11
    jal t0, ERRO

PULAERRO11: li t0, 5
    li t2, 10
    addi t0, t0, 5          # testa ADDI
    beq t0, t2, PULAERRO12
    jal t0, ERRO

PULAERRO12: andi t0, zero, 1        # testa ANDI
    beq t0, zero, PULAERRO13
    jal t0, ERRO

PULAERRO13: li t0, 1
    li t2, 1
    xori t0, t0, 0          # testa XORI
    beq t0, t2, PULAERRO14
    jal t0, ERRO

PULAERRO14: li t0, 2
    slti t0, t0, 1 #t0 = t0 < 1 # testa SLTI
    beq t0, zero, PULAERRO15
    jal t0, ERRO

PULAERRO15: li t0, -2
    sltiu t0, t0, 1         # testa SLTIU
    beq t0, zero, PULAERRO16
    jal t0, ERRO

PULAERRO16: li t0, 2
    li t1, 4
    slli t0, t0, 1          # testa SLLI
    beq t0, t1, PULAERRO17
    jal t0, ERRO

PULAERRO17: li t0, 2
    li t2, 1
    srai t0, t0, 1          # testa SRAI
    beq t0, t2, PULAERRO18
    jal t0, ERRO

PULAERRO18: auipc t0, 0 #PC
    auipc t1, 0 #PC + 4     # testa AUIPC
    li t2, 4
    sub t1, t1, t2 #t1 = t1 - 4
    beq t0, t1, PULAERRO19
    jal t0, ERRO

PULAERRO19: li t0, 0
    lui t0, 1 #t0 = 4096        # testa LUI
    li t1, 4096
    beq t0, t1, PULAERRO20
    jal t0, ERRO

PULAERRO20: li t0, 0
    beq zero, t0, PULAERRO21    # testa BEQ
    jal t0, ERRO

PULAERRO21: li t0, 5
    bne zero, t0, PULAERRO22    # testa BNE
    jal t0, ERRO

PULAERRO22: li t0, 5
    li t1, 2
    bge t0, t1, PULAERRO23      # testa BGE
    jal t0, ERRO

PULAERRO23: li t0, -5
    li t1, 7
    bgeu t0, t1, PULAERRO24     # testa BGEU
    jal t0, ERRO

PULAERRO24: li t0, 5
    li t1, 2
    blt t1, t0, PULAERRO25      # testa BLT
    jal t0, ERRO

PULAERRO25: li t0, -5
    li t1, 2
    bltu t1, t0, PULAERRO26     # testa BLTU
    jal t0, ERRO

PULAERRO26: la t2, ERRO
    jal PULAERRO27
    jalr t0, t2, 0          # testa JALR

PULAERRO27: la t2, PULAERRO28
    jalr t0, t2, 0          # testa JALR
    jal t0, ERRO

PULAERRO28: la t1, NB
    lb t0, 0(t1)            # testa LB SB
    sb t0, 1(t1)
    lb t0, 1(t1)
    bne t0, zero, PULAERRO29
    jal t0, ERRO

PULAERRO29: la t1, NB
    lbu t0, 0(t1)           # testa LBU
    sb  t0, 1(t1)
    lbu t0, 1(t1)
    bne t0, zero, PULAERRO30
    jal t0, ERRO

PULAERRO30: la t1, NH
    lh t0, 0(t1)            # testa LH SH
    sh t0, 2(t1)
    lh t0, 2(t1)
    bne t0, zero, PULAERRO31
    jal t0, ERRO

PULAERRO31: la t1, NH
    lhu t0, 0(t1)           # testa LHU
    sh  t0, 2(t1)
    lhu t0, 2(t1)
    bne t0, zero, SUCESSO
    jal t0, ERRO

SUCESSO: addi s11,s11,-1
     bne s11,zero, MAIN
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

