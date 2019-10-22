.data
.include "tela.s"


.text
	li s0,0xFF000000	# Frame0
	la t0,tela		# endereço da imagem
	lw t1,0(t0)		# Numero de linhas
	lw t2,4(t0)		# numero de colunas
	li t3,0			# contador
	mul t4,t1,t2		# numero de pixels
	addi t0,t0,8		# primeiro pixel da imagem
LOOP: 	beq t3,t4,FORA		# Coloca a imagem no Frame0
	lw t5,0(t0)
	sw t5,0(s0)
	addi t0,t0,4
	addi s0,s0,4
	addi t3,t3,1
	j LOOP
	
FORA: 	li s0,0xFF100000	# Frame 1
	la t0,tela
	lw t1,0(t0)
	lw t2,4(t0)
	li t3,0
	mul t4,t1,t2
	addi t0,t0,8
LOOP2: 	beq t3,t4,FORA2	
	lw t5,0(t0)
	not t5,t5		# inverso do pixel
	sw t5,0(s0)
	addi t0,t0,4
	addi s0,s0,4
	addi t3,t3,1
	j LOOP2
	
FORA2:	li s3,200
	li s0,0xFF200604	# Escolhe o Frame 0 ou 1
	li s1,0xFF200510	# StopWatch
	li s2,0xFF200514	# randomico
	li t2,0			# inicio Frame 0

FORALOOP: sw t2,0(s0)		# seleciona a Frame t1
	lw t1,0(s1)		# le o tempo
	lw t2,0(s2)		# le um numero randomico
	remu t2,t2,s3		# randomico entre 0 e 199
	add t1,t1,t2		# soma com o tempo
	
LOOP3:	bge t2,t1,FORALOOP	# aguarda t2 segundos
	lw t2,0(s1)
	j LOOP3




