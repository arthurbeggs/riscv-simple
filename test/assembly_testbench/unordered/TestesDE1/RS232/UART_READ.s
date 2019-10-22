.data
	##############################################
	# Endere�os do RS232
	# parameter RS232_READ = 32'hFFFF0120;
	# parameter RS232_WRITE = 32'hFFFF0121;
	# parameter RS232_CONTROL = 32'hFFFF0122;
	###############################################
	
	##############################################
	# Protocolo
	# primeiros 4 bytes do arquivo: quantidade de bytes a serem lidos/transmitidos
	###############################################

	dados: .word 0
.text	
	#READ
	la $a0, dados
	jal UART_READ
	
	la $a0, dados
	lw $s0, 0($a0)
	lw $s1, 4($a0)
	lw $s2, 252($a0)
	

EXIT:
	j EXIT
	

UART_READ:
###################
# t0: endere�o para leitura
# t1: indica quando byte est� pronto para ser lido
# t2: byte lido
# t3: contador do protocolo rs232 definido (primeiros 4 bytes indicam quantidade de bytes a serem lidos do arquivo)
###################
	
	la $t0, 0xFFFF0120
	la $t9, 0xFFFF0122
	move $t3, $zero	
	move $t6, $zero
	addi $t8, $zero, 8 	# n�mero 8
	li $t4, 4	#contador de 4 bytes
	
	
	###########################################
	# M�todo para pegar os 4 primeiros bytes e associ�-los a um contador de bytes do arquivo
	# 
	###########################################
	CONTADOR_BYTES_ARQ: 
		CHECK_READY1_CONTADOR:
			lw $t1, 0($t9) 	#0xFFFF0122
			srl $t1, $t1, 2

			beq $t1, $zero, CHECK_READY1_CONTADOR

		lw $t2, 0($t0)	
		mult $t6, $t8
		mflo $t5 	#quantos shifts ser�o necess�rios para colocar este byte na posi��o certa
		sllv $t2, $t2, $t5
		or $t3, $t3, $t2 #coloca no t3 o resultado da soma com shift
		addi $t4, $t4, -1
		addi $t6, $t6, 1
		
		CHECK_READY0_CONTADOR:
			lw $t1, 0($t9) 	#0xFFFF0122
			srl $t1, $t1, 2

			bne $t1, $zero, CHECK_READY0_CONTADOR
		
		
		bne $t4, $zero, CONTADOR_BYTES_ARQ	
	
	###########################################
	# Baseado na quantidade de bytes, espera receber $t3 bytes do arquivo e escreve na mem�ria
	# 
	###########################################
	move $v0, $t3
	li $t4, 4	#contador de uma word
	move $t6, $zero
	addi $t8, $zero, 8 	# n�mero 8
	
	BYTES_ARQ:
		beq $t3, $zero, FIM_UART_READ
		CHECK_READY1:
			lw $t1, 0($t9) 	#0xFFFF0122
			srl $t1, $t1, 2
			beq $t1, $zero, CHECK_READY1
			
		lw $t2, 0($t0)	
		mult $t6, $t8
		mflo $t5 	#quantos shifts ser�o necess�rios para colocar este byte na posi��o certa
		sllv $t2, $t2, $t5
		or $t7, $t7, $t2 #coloca no t3 o resultado da soma com shift

		addi $t4, $t4, -1
		addi $t6, $t6, 1
		
		addi $t3, $t3, -1
		
		CHECK_READY0:
			lw $t1, 0($t9) 	#0xFFFF0122
			srl $t1, $t1, 2
			bne $t1, $zero, CHECK_READY0
		
		bne $t4, $zero, BYTES_ARQ
		
		li $t4, 4
		sw $t7, 0($a0)
		addi $a0, $a0, 4		
		move $t7, $zero
		move $t6, $zero
		
		j BYTES_ARQ
	
	FIM_UART_READ:
		beq $t7, $zero, FIM_UART_READ_JUMP
		sw $t7, 0($a0)
	FIM_UART_READ_JUMP: 		
		jr $ra













