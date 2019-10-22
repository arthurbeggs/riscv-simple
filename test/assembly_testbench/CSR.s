#################################################
#	Testbench para a ISA RV32IMF
#  Baseado no trabalho:
#
# 2019/1
# Pedro Luis
#
#
# Marcus Vinicius Lamar
# 2019/1
#################################################

# Use o timer da DE1 para ter uma medida do desempenho

.data


MSG:	.string "Endereco do erro : "
MSG2:	.string "Control Status - Nao ha erros :)"


.text
	la t6,exceptionHandling		# carrega em t6 o endereço base das rotinas do sistema ECALL
	csrrsi zero,0,1 		# seta o bit de habilitação de interrupção em ustatus (reg 0)
	csrrw zero,5,t6 		# seta utvec (reg 5) para o endereço t6
	
	
	li s11, 0	# contador de Loops
	
MAIN:	

	
PULAERRO1:   #csrrw

		li t0 15
		li t1 15

		csrrw t0 5 t0  # t0 = csr e csr = t0
		csrrw t0 5 t0
		csrrw t0 5 t0
		csrrw t0 5 t0
		beq t0 t1 PULAERRO2
		jal t0, ERRO
	   
PULAERRO2: #csrrs

		li t0 1
		li t1 1

		csrrs t0 64 t0  # t0 = csr e csr = csr||t0	
		csrrs t0 64 t0

		beq t0 t1 PULAERRO3
		jal t0, ERRO

	   
	   
PULAERRO3: #csrrc

		li t0 7
		li t1 8

		csrrwi zero 65 0xf  # t0 = csr e csr = csr & ~t0
		csrrc t0 65 t0
		csrrc t0 65 t0
		

		beq t0 t1 PULAERRO4
		jal t0, ERRO

	    
	   
PULAERRO4: #csrrwi
	
		
		li t1 20

		csrrwi t0 66 10
		csrrwi t0 66 15
		csrrwi t0 66 20
		csrrwi t0 66 25
		
		beq t0 t1 PULAERRO5
		
	    	jal t0, ERRO
	   
PULAERRO5: #csrrsi

		
		li t1 1

		csrrsi t0 67 1
		csrrsi t0 67 1

		
		beq t0 t1 PULAERRO6


	    	jal t0, ERRO

PULAERRO6: #csrrci


		li t1 8

		csrrwi zero 68 0xf
		csrrci t0 68 7
		csrrci t0 68 7
		
		beq t0 t1 SUCESSO


	    	jal t0, ERRO
	   

SUCESSO: bgt s11,zero,PULA1
   	li a0, 0x38
   	li a1, 0
	li a7, 148
	ecall
	
	#print string sucesso
	li a3,0x3800
	li a7, 104
	la a0, MSG2
	li a1, 64
	li a2, 0
	li a4, 0

	ecall

PULA1:	mv a0, s11
	li a7, 101
	li a1, 140
	li a2, 120
	li a3, 0x3800
	li a4, 0
	ecall

	addi s11, s11, 1
	j MAIN
	
ERRO:	li a0, 0x07
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
	
	#end
END: 	addi a7, zero, 10
	ecall
	
.include "..\SYSTEMv14.s"
	
