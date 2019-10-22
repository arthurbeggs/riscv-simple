# ####################################### #
# #  Teste da interface RS232		# #
# #   Endereçoos de Acesso:		# #
# #  	Rx: 0xFF20 0120			# #
# #	Tx: 0xFF20 0121			# #
# #	Ctrl: 0xFF20 0122		# #
# ####################################### #
# Usar com os programas em C dados	  #

.data
MEM: .byte 1,2,3,4,5,6,7,8,9,10

.text

####  Definicao dos enderecos
li t0,0xFF200120		# endereco base da RS232
la t2,MEM			# endereco do .data
li t4,10			# numero de elementos
add t3,t2,t4    		# ultimo endereco
li s2,1				# numero 1 para o TXStart

### escolha o programa .c a ser testado descomentando/comentando os j abaixo

j TesteRS232 	### Para testar o testeRS232.c
#j Demo_tx	 ### Para testar o demo_tx.c
#j Demo_rx    	 ### Para testar o demo_rx.c


########### Recebe um byte e transmite o dobro // para ser usado com o testeRS232.c
TesteRS232:
LOOP3t: lb t1,2(t0)
	beq t1,zero, LOOP3t   	# Espera o Ready ir para 1
	lb s1,0(t0)    		# le o byte do RxData
LOOP2t: lb t1,2(t0)
	bne t1,zero, LOOP2t  	# Espera o Ready voltar para 0
	slli s1,s1,1           	# x2
	sb s1,1(t0)           	# coloca byte no TxData
	sb s2,2(t0)	        # aciona o TxStart
	sb zero,2(t0)         	# abaixa o TxStart
LOOP4t: lb t1,2(t0)
	bne t1,zero,LOOP4t	# Espera o Busy ir para 0
j LOOP3t
	nop



############ Transmite $t4 bytes da memoria  // para ser usado com demo_tx.c
Demo_tx:
LOOP1: lb s1,0(t2)  	  	# le o dado a ser transmitido da memoria
	sb s1,1(t0)           	# coloca no TxData
	sb s2,2(t0)	        # aciona o TxStart
	sb zero,2(t0)         	# abaixa o TxStart
LOOP4: lb t1,2(t0)   		
	bne t1,zero,LOOP4	# Espera  o Busy ir para 0
	addi t2,t2,1		# incrementa endereco do dado a ser enviado
	bne t2,t3,LOOP1       	# eh o ultimo? fim senao volta para o LOOP1

FIMT: j FIMT
	nop



#############  Recebe $t4 bytes na memoria  //  para ser usado com o demo_rx.c
Demo_rx:
LOOP3: lb t1,2(t0)
	beq t1,zero, LOOP3  	# Espera o Ready ir para 1
	lb s1,0(t0)    		# le o byte de RxData
LOOP2: lb t1,2(t0)
	bne t1,zero, LOOP2  	# Espera o Ready voltar para 0

	sb s1,0(t2)		# armazena o dado lido
	addi t2,t2,1		# incrementa o endereco
	bne t2,t3,LOOP3		# eh o ultimo?

FIM: j FIM
	nop
