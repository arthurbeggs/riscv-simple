#################################################
#	Testbench para a ISA RV32IM
#  Baseado no trabalho:
# 
#
# Marcus Vinicius Lamar
# 2019/1
#################################################

# Use o timer da DE1 para ter uma medida do desempenho

.data
MSG:	.string "Endereco do erro : "
MSG2:	.string "RV32IM - Nao ha erros :)"


.include "../macros2.s"

.text		
	M_SetEcall(exceptionHandling)
	li s11, 0	# contador de Loops
	
MAIN: 	li t0, -1
	li t1, -1
	li t2, 1
	mul t0,t0,t1			# testa MUL
	beq t0, t2, PULAERRO1
	jal t0, ERRO

PULAERRO1: li t0, -1
	li t1, -1
	li t2, 0
	mulh t0, t0, t1			# testa MULH
	beq t0, t2, PULAERRO2
	jal t0, ERRO
	
PULAERRO2: li t0, -1
	li t1, -1
	li t2, 0xFFFFFFFE
	mulhu t0, t0, t1		# testa MULHU
	beq t0, t2, PULAERRO3
	jal t0, ERRO

PULAERRO3: li t0, -1
	li t1, -1
	li t2, 0xFFFFFFFF
	mulhsu t0, t0, t1		# testa MULHSU
	beq t0, t2, PULAERRO4
	jal t0, ERRO
	
PULAERRO4: li t0, -7
	li t1, 2
	li t2, -3
	div t0, t0, t1			# testa DIV
	beq t0, t2, PULAERRO5
	jal t0, ERRO
	
PULAERRO5: li t0, -7
	li t1, 2
	li t2, 0x7FFFFFFC
	divu t0, t0, t1			# testa DIVU
	beq t0, t2, PULAERRO6
	jal t0, ERRO
	
PULAERRO6: li t0, -7
	li t1, 2
	li t2, -1
	rem t0, t0, t1			# testa REM
	beq t0, t2, PULAERRO7
	jal t0, ERRO
	
PULAERRO7: li t0, -7
	li t1, 3
	li t2, 0x00000000
	remu t0, t0, t1			# testa REMU
	beq t0, t2, SUCESSO
	jal t0, ERRO


SUCESSO: bgt s11,zero,PULA1
   	li a0, 0x38
   	li a1, 0
	li a7, 148
	M_Ecall
	
	#print string sucesso
	li a3,0x3800
	li a7, 104
	la a0, MSG2
	li a1, 64
	li a2, 0
	li a4, 0
	M_Ecall

PULA1:	mv a0, s11
	li a7, 101
	li a1, 140
	li a2, 120
	li a3, 0x3800
	li a4, 0
	M_Ecall

	addi s11, s11, 1
	j MAIN
	
ERRO:	li a0, 0x07
	li a7, 148
	li a1, 0
	M_Ecall
		
	#Print string erro
	li a7, 104
	la a0, MSG
	li a1, 0
	li a2, 0
	li a3, 0x0700
	li a4, 0
	M_Ecall
	
	#print endereco erro
	addi a0, t0, -12 #Endereco onde ocorreu o erro
	li a7, 134
	li a1, 148
	li a2, 0
	li a3, 0x0700
	li a4, 0
	M_Ecall
	
	#end
END: 	addi a7, zero, 10
	M_Ecall
	
.include "../SYSTEMv13.s"
	
