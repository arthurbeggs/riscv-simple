# Este teste permite investigar o comportamento das 3 formas de acesso ao teclado
# através da visualização em tempo real dos registradores associados conforme abaixo

.text
	li s0,0xFF200100  	#BUFFER1
	li s1,0xFF200104	#BUFFER2
	li a0,0xFF200520	#KEY0
	li a1,0xFF200524	#KEY1
	li a2,0xFF200528	#KEY2
	li a3,0xFF20052C	#KEY3
	li a4,0xFF200004	#Data
	li a5,0xFF200000	#Ctrl
	
LOOP:	lw s8,0(s0)
	lw s9,0(s1)
	lw s10,0(a0)
	lw s11,0(a1)
	lw t3,0(a2)
	lw t4,0(a3)
	lw t5,0(a4)
	lw t6,0(a5)
	j LOOP
	
