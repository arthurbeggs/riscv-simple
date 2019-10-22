# ####################################### #
# #   Teste de tocar arquivo de IO de Audio # #
# ####################################### #
# Usar caixas de som ou fone de ouvido!!!!	  #

.eqv AudioBase		0xFF200160

.data
.include "som5.s" 

.text


Main: li t0,AudioBase	# Endereco base
li s0,3			#  os dois canais 011
la t4,WAV		# endereço do buffer
li t5,56098		# numero de amostras
li s1,3			# para ajustar a taxa de amostragem

Inicio: sw zero,20(t0)	# Aviso ao CODEC que pode iniciar

J1:	lw t1,16(t0)	# Aguarda que as amostras L e R estejam prontas
	bne t1,s0,J1

	lh t2,0(t4)	# le a amostra do buffer
	sw t2,8(t0)  	# Escreve no Canal R 
	sw t2,12(t0)  	# Escreve no canal L

	sw s0,20(t0)   # Avisa ao CODEC que está tudo lido e escrito
	
J2:	lw t3,16(t0)	# Aguarda o CODEC reconhecer
	bne t3,zero,J2

	addi s1,s1,-1
	bne s1,zero, Inicio	# Loop de adequação da taxa de amostragem
	
	li s1,3
	addi t4,t4,2
	addi t5,t5,-1
	bge t5,zero,Inicio
	
FIM:	j FIM
