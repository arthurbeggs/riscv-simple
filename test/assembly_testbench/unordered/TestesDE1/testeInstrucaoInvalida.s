# testa a exceção de instrução inválida
# só funciona em máquina Von Neummann - Rars -> self-modifying code

.text
MAIN:	la t0,MAIN
	li t1,0xFFFFFFFF  # instrução inválida
	sw t1,24(t0)
	nop
	nop
	nop		  #local da instrução inválida
	nop

FIM:  	j FIM
