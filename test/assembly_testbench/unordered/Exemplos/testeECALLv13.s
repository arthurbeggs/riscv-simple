# Teste dos syscalls 1xx que usam o SYSTEMv13.s
# Conectar o BitMap Display e o KD MMIO para executar
# na DE1-SoC e no Rars deve ter o mesmo comportamento sem alterar nada desde que 
# a instrução ecall e a ISA RV32imF  tenham sido implementadas.
# 2019/1

.include "../macros2.s"


.data
FLOAT: 	.float 	3.14159265659
msg1: 	.string "Organizacao Arquitetura de Computadores 2019/1 !"
msg2: 	.string "Digite seu Nome:"
msg3: 	.string "Digite sua Idade:"
msg4: 	.string "Digite seu peso:"
msg5: 	.string "Numero Randomico:"
msg6: 	.string "Tempo do Sistema:"
buffer: .string "                                "

.text
	M_SetEcall(exceptionHandling)	# Macro de SetEcall - não tem ainda na DE1-SoC
																																																				
																																																																																																																																																																					
	jal CLS
	jal PRINTSTR1
	jal INPUTSTR
	jal INPUTINT
	jal INPUTFP
	jal RAND
	jal TIME
	jal TOCAR
	jal SLEEP
	jal DRAW
	
	li a7,10
	M_Ecall
				
# CLS Clear Screen
CLS:	li a0,0x00
	li a7,148
	li a1,0
	M_Ecall
	ret
				
# syscall print string
PRINTSTR1: li a7,104
	la a0,msg1
	li a1,0
	li a2,0
	li a3,0x0038
	li a4,0
	M_Ecall
	ret		
	
INPUTSTR: li a7,104
	la a0,msg2
	li a1,0
	li a2,24
	li a3,0x0038
	li a4,0
	M_Ecall
	
# syscall read string
	li a7,108
	la a0,buffer
	li a1,32
	M_Ecall
	
# syscall print string	
	li a7,104
	la a0,buffer
	li a1,144
	li a2,24
	li a3,0x0038
	li a4,0
	M_Ecall
	ret
	
# syscall read int
# syscall print string	
INPUTINT: li a7,104
	la a0,msg3
	li a1,0
	li a2,32
	li a3,0x0038
	li a4,0
	M_Ecall

	# syscall read int
	li a7,105
	M_Ecall
	mv t0,a0

# syscall print int	
PRINTINT: li a7,101
	mv a0,t0
	li a1,152
	li a2,32
	li a3,0x0038
	li a4,0
	M_Ecall
	ret
	
# syscall read float
# syscall print string	
INPUTFP: li t0,0 
	la t1,FLOAT
	flw f0,0(t1)
	fmv.x.s t0,f0
	beq t0,zero,FORAFP  # testa para ver se tem a FPU
  	li a7,104
	la a0,msg4
	li a1,0
	li a2,40
	li a3,0x0038
	li a4,0
	M_Ecall

	li a7,106
	M_Ecall
	
	# syscall print float
	li a7,102
	li a1,144
	li a2,40
	li a3,0x0038
	li a4,0
	M_Ecall

		
FORAFP:	ret
	
# Contatos imediatos do terceiro grau
TOCAR:	li a0,62
	li a1,500
	li a2,16
	li a3,127
	li a7,133
	M_Ecall
	li a0,64
	li a1,500
	li a2,16
	li a3,127
	li a7,133
	M_Ecall
	li a0,61
	li a1,500
	li a2,16
	li a3,127
	li a7,133
	M_Ecall
	li a0,50
	li a1,500
	li a2,16
	li a3,127
	li a7,133
	M_Ecall
	li a0,55
	li a1,800
	li a2,16
	li a3,127
	li a7,131
	M_Ecall
	ret
			
# syscall rand
# syscall print string	
RAND:	li a7,104
	la a0,msg5
	li a1,0
	li a2,48
	li a3,0x0038
	li a4,0
	M_Ecall
	# syscall Rand
	li a7,141
	M_Ecall
	# print int em hex
	li a7,134
	li a1,148
	li a2,48
	li a3,0x0038
	li a4,0
	M_Ecall
	ret
		
# syscall time
# syscall print string	
TIME:	li a7,104
	la a0,msg6
	li a1,0
	li a2,56
	li a3,0x0038
	li a4,0
	M_Ecall
	li a7,130
	M_Ecall
	mv t0,a0
	mv t1,a1
	
#print int
	mv a0,t0
	li a7,101
	li a1,148
	li a2,56
	li a3,0x0038
	li a4,0
	M_Ecall
	#print int
	mv a0,t1
	li a7,101
	li a1,244
	li a2,56
	li a3,0x0038
	li a4,0
	M_Ecall
	ret
	
# syscall sleep
SLEEP:	li t0,5
LOOPHMS:li a0,1000   # 1 segundo
	li a7,132
	M_Ecall
	addi t0,t0,-1
	#print seg
	mv a0,t0
	li a7,101
	li a1,120
	li a2,120
	li a3,0x0038
	li a4,0
	M_Ecall
	bne t0,zero,LOOPHMS	
	ret
	
# CLS Clear Screen Randomico
CLSV:	li a7,141
	M_Ecall
	li a7,148
	li a1,0
	M_Ecall
	j CLSV

# DrawLines Bresenham
DRAW:	li t2,0	
	li t0,1
	li s4,320
	li s5,240
LOOPDRAW: li t1,0
	  li s0,0
	  li s1,0
	  li s2,319
	  li s3,239
	li t1,0	  
FOR1:	bge t1,s4, SAI1
	mv a0,s0
	mv a1,s1
	mv a2,s2
	mv a3,s3
	mv a4,t2
	li a5,0
	li a7,47
	M_Ecall
	addi s0,s0,1
	addi s2,s2,-1
	add t2,t2,t0
	addi t1,t1,1
	j FOR1

SAI1:	li s2,0
	li s1,0
	li s0,319
	li s3,239
	li t1,0
FOR2:	bge t1,s5, SAI2
	mv a0,s0
	mv a1,s1
	mv a2,s2
	mv a3,s3
	mv a4,t2
	li a5,0
	li a7,47
	M_Ecall
	addi s1,s1,1
	addi s3,s3,-1
	add t2,t2,t0
	addi t1,t1,1
	j FOR2
SAI2:	addi t0,t0,1
	j LOOPDRAW


.include "../SYSTEMv13.s"






