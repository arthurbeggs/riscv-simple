.data
.include "tela.s"

.text
	li s0,0xFF200604	# seleciona frame 0
	sw zero,0(s0)
	
	li s0,0xFF000000	# Frame0
	li s1,0xFF100000	# Frame1
	la t0,tela		# endereço da imagem
	lw t1,0(t0)		# Numero de linhas
	lw t2,4(t0)		# numero de colunas
	li t3,0			# contador
	mul t4,t1,t2		# numero de pixels
	addi t0,t0,8		# primeiro pixel da imagem
LOOP: 	beq t3,t4,FORA		# Coloca a imagem no Frame0
	lw t5,0(t0)
	sw t5,0(s0)
	not t5,t5		# inverso da cor do pixel
	sw t5,0(s1)	
	addi t0,t0,4
	addi s0,s0,4
	addi s1,s1,4
	addi t3,t3,1
	j LOOP
	
	
FORA:	li s0,0xFF200604	# Escolhe o Frame 0 ou 1
	li t2,0			# inicio Frame 0

LOOP3: 	  sw t2,0(s0)		# seleciona a Frame t2
	  xori t2,t2,0x001
	  li a0,50
	  li a7,32
	  ecall
	  j LOOP3

