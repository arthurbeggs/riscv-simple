.data

	dados: .word 0x00000100
	dados2: .ascii"abcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdabcdxyzw"	#4 bytes para quantidade de bytes na string/ARQUIVO
	arqOutput: .asciiz "computador_rs232_mips.acbnna"
	dados3: .word 0
	vetor: .word
.text
	
	la $a0, dados
	la $a1, vetor
	
	jal UART_READ
	
	#N�O FUNCIONA
	#la $a0, dados3
	#jal UART_READ
	
	j EXIT
	
	###########################################
	# Depois de ter lido byte a byte o que foi passado pelo computador, escrever resultados em arqOutput
	# 
	###########################################
	la $s0, dados3
	add $s1, $zero, $v0 #pega quantidade de bytes para serem escritos
	
	###############################################################
	# Open (for writing) a file that does not exist
	li   $v0, 13       # system call for open file
	la   $a0, arqOutput     # output file name
	li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
	li   $a2, 0        # mode is ignored
	syscall            # open a file (file descriptor returned in $v0)
	move $s6, $v0      # save the file descriptor 
	###############################################################
	# Write to file just opened
	li   $v0, 15       # system call for write to file
	move $a0, $s6      # file descriptor 
	lbu   $a1, ($s0)   # address of buffer from which to write
	add   $a2, $zero, $s1       # hardcoded buffer length
	syscall            # write to file
	###############################################################
	# Close the file 
	li   $v0, 16       # system call for close file
	move $a0, $s6      # file descriptor to close
	syscall            # close file
	###############################################################
	
	
	#lw $s0, 0($s0)

EXIT:
	li $v0, 10
	syscall
	
UART_WRITE:
###################
# a0: endere�o dos bytes a serem escritos
# t0: endere�o do rs232
#
# t1: setar start
# t2: quantidade de bytes a serem lidos
# t7: byte lido
###################
	addi	$sp, $sp, -4		# Aloca na Pilha
	sw	$ra, 0 ($sp)		# Guarda na Pilha o ra
	
	li 	$t1, 1
	lw 	$t2, 0($a0)		# Le o numero de bytes a serem transmitidos
	addi	$a0, $a0, 4		# Pula para os dados a serem mandados
	la 	$t0, 0xFFFF0120		# Endere�o de interface da RS 232

	#la 	$t0, dados3
	#li $t2, 26  			#isso aqui n�o deve estar aqui
	#j UART_WRITE_LOOP 		#isso aqui n�o deve estar aqui

	add 	$t7, $zero, $t2	
	
	sb 	$t7, 1($t0) 		# byte 1
	sb 	$t1, 2($t0) 		# controle: start 1
	sb 	$zero, 2($t0)		# start 0
	andi 	$s0, $t7, 0x00ff	# Pega o byte menos significativo
	#add $s0,$s0,$t7

	jal	SLEEP			# SLEEP
	
	
	srl 	$t7, $t7, 8		# alinha os proximos bytes na menor posicao de memoria
	sb 	$t7, 1($t0)		# byte 2
	sb 	$t1, 2($t0) 		# controle: start 1
	sb 	$zero, 2($t0) 		# start 0
	andi 	$t4, $t7, 0x00FF	# Pega o byte menos significativo
	sll  	$t4, $t4, 8		# Alinha para a concatenacao
	add  	$s0, $s0,$t4		# Soma no registrador debug

	jal	SLEEP			# SLEEP
	
	srl 	$t7, $t7, 8
	sb 	$t7, 1($t0) 		# byte 3
	sb	$t1, 2($t0) 		# controle: start 1
	sb 	$zero, 2($t0) 		# start 0
	andi 	$t4, $t7, 0x00FF	# Pega o byte menos significativo
	sll  	$t4, $t4, 16		# Alinha para a concatenacao
	add  	$s0, $s0,$t4		# Soma no registrador debug
	
	jal	SLEEP			# SLEEP
	
	srl 	$t7, $t7, 8
	sb 	$t7, 1($t0) 		#byte 4
	sb 	$t1, 2($t0) 		#controle: start 1
	sb 	$zero, 2($t0) 		#start 0
	andi 	$t4, $t7, 0x00FF	# Pega o byte menos significativo
	sll  	$t4, $t4, 24		# Alinha para a concatenacao
	add  	$s0, $s0,$t4		# Soma no registrador debug

	jal	SLEEP			# SLEEP
	
	UART_WRITE_LOOP:	
		lb $t7, 0($a0)
		
		sb $t7, 1($t0) 		#dado
		sb $t1, 2($t0) 		#controle: start 1
		sb $zero, 2($t0) 	#start 0
		
		jal	SLEEP		# Sleep 
		
		
		addi $t2, $t2, -1
		addi $a0, $a0, 1	# Proximo byte
		
		bne $t2, $zero, UART_WRITE_LOOP
	
	lw	$ra, 0($sp)		# Valor de retorno
	addi	$sp, $sp, 4		# Desaloca
	jr 	$ra


SLEEP:	
###########################################
# Metodo sleep necessario para a RS232 acompanhar o clock do mips
# 
###########################################
		#jr	$ra		# Para o debug
		li 	$t9, 1000
slp_loop:	addi 	$t9, $t9, -1
		bne 	$t9, $zero, slp_loop
		jr	$ra
		
SLEEPIZINHO:	
###########################################
# Metodo sleep necessario para a RS232 acompanhar o clock do mips
# 
###########################################
		#jr	$ra		# Para o debug
		li 	$t9, 10
slp_loopizinho:	addi 	$t9, $t9, -1
		bne 	$t9, $zero, slp_loopizinho
		jr	$ra
	

################################################################
# a0 : endere�o onde se escreve dados
# v0 : quantidade de bytes do arquivo
################################################################

UART_READ:
###################
# t0: endere�o para leitura
# t1: indica quando byte est� pronto para ser lido
# t2: byte lido
# t3: contador do protocolo rs232 definido (primeiros 4 bytes indicam quantidade de bytes a serem lidos do arquivo)
###################
	
	la $t0, 0xFFFF0120
	move $t5, $zero	
	addi $t8, $zero, 8 	# n�mero 8
	li $t4, 4	#contador de 4 bytes
	
	li $t8, 0xA		# \n
	li $t9, 0x20		# espaco
	li $t2, 0
	CHECK_READY_CONTADOR:
		lbu $t1, 0($t0)
		beq $t1, $zero, CHECK_READY_CONTADOR
		sb $t1, 0($a0)
		addi $a0, $a0, 4
		addi $t2, $t2, 1
		beq $t1, $t8, END_CHECK_READY
		j CHECK_READY_CONTADOR
		
		
		li $t3, 0
		li $s1, 0
		la $a0, dados
	END_CHECK_READY:
		beq $t3, $t2, END_LOOP
		li $t4, 0
	LOOP:
		lbu $t1, 0($a0)
		beq $t1, $t9, ESPACO
		addi $t4, $t4, 1
		addi $a0, $a0, 4
		addi $t3, $t3, 1
		j LOOP
		
		
	END_LOOP:
		
		
	ESPACO:
		add $s0, $zero, $zero
	LOOP_ESPACO:
		beq $t4, -1, END_ESPACO
		mul $t5, $t4, 4
		addi $t4, $t4, -1
		sub $a0, $a0, $t5
		lbu $t1, 0($a0)
		addi $t1, $t1, -48
		mul $t6, $t4, 10
		mul $t1, $t1, $t6
		add $s0, $s0, $t1
		addi $t4, $t4, -1
		j LOOP_ESPACO
		
	END_ESPACO:
		addi $s1, $s1, 1
		addi $a0, $a0, 4
		sw $s0, 0($a1)
		addi $a1, $a1, 4
		addi $t3, $t3, 1
		j END_CHECK_READY
		
		
		
		
		
	
	###########################################
	# M�todo para pegar os 4 primeiros bytes e associ�-los a um contador de bytes do arquivo
	# 
	###########################################
	CONTADOR_BYTES_ARQ: 
		
		#j BYTES_ARQ   #DEBUG
		#li $t9, 0x61
		#CHECK_READY_CONTADOR:
		#	lbu $t8, 0($t0) 	#0xFFFF0122
		#	srl $t1, $t8, 2
		#	beq $t1, $t9, CHECK_READY_CONTADOR
	
		lbu $t2, 0($t0)
		mult $t5, $t8
		mflo $t6 	#quantos shifts ser�o necess�rios para colocar este byte na posi��o certa
		sllv $t2, $t2, $t6
		add $t3, $t3, $t2
		addi $t4, $t4, -1
		addi $t5, $t5, 1

		
		bne $t4, $zero, CONTADOR_BYTES_ARQ
	
	###########################################
	# Baseado na quantidade de bytes, espera receber $t3 bytes do arquivo e escreve na mem�ria
	# 
	###########################################
	move $v0, $t3
	BYTES_ARQ:
		beq $t3, $zero, FIM_UART_READ
		#CHECK_READY:
		#	lbu $t1, 2($t0) 	#0xFFFF0122
		#	srl $t1, $t1, 2
		#	jal	SLEEPIZINHO		# Sleep 
		#	beq $t1, $zero, CHECK_READY
			
		lbu $t2, 0($t0)
		sb $t2, 0($a0)
		addi $a0, $a0, 1 #pr�ximo byte
		addi $t3, $t3, -1
		j BYTES_ARQ
	
	FIM_UART_READ:
		jr $ra













