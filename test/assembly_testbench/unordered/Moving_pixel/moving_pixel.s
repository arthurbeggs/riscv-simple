.macro LOAD_COOR(%coor_adress,%rdx,%rdy)
	lh %rdx 0(%coor_adress)
	lh %rdy 2(%coor_adress)
.end_macro 

.eqv FRAME_0 0xFF000000
.eqv FRAME_1 0xFF100000
.eqv MAX_SPEED 0x000007FF	# Maior velocidade positiva: 11 bits 1	
.eqv ADC_CH0 0xFF200200
.eqv ADC_CH1 0xFF200204
.eqv ADC_CH2 0xFF200208
.eqv ADC_CH3 0xFF20020C
.eqv ADC_CH4 0xFF200210
.eqv ADC_CH5 0xFF200214
.eqv ADC_CH6 0xFF200218
.eqv ADC_CH7 0xFF20021C

.data 
	SPEED_IN: .half 0xd10,0xd10 	#{20[0]}12,{20[0]}12 bits - PARA TESTES SEM O ADC
	SPEED: .half 0,0	#(speed h, speed y) -> sinal[15] magnitude[14:0]
	SPEED_I:.half 0,0
	.align 2	
	DIR: .half 1,1		# Direção: (h,v); h,v e {-1,0,+1}
	COOR: .half 0,120		#(x,y)
.text

# Configurar utvect
la t0,exceptionHandling		# t0 = &rotinas
csrrw zero,5,t0 		# UTVECT = t0
csrrsi zero,0,1 		# ustatus = 1

la s0 COOR
la s1 SPEED
la s2 SPEED_I
la s3 DIR
#li s4 ADC_CH0
#li s5 ADC_CH1
la s4 SPEED_IN
la s5 SPEED_IN
addi s5 s5 2

#CLS
li a0 0x00	# preto
li a7 148
ecall

MAIN_LOOP:
	# Recebe input
	mv a0 s1
	mv a1 s3
	mv a2 s4
	mv a3 s5
	#jal ra GET_SPEED	# void GET_SPEED(&SPEED,&DIR)
	
	# Converte input para velociade correta
	#a0 carregado
	#a1 carregado
	jal ra CVT_TO_SPEED	# void GET_SPEED(&SPEED_IN,&DIR)
	
	
	# Apaga posição anterior
	mv a0 s0
	li a1 FRAME_0
	add a2 zero s6
	jal ra PRINT_PIXEL	# void PRINT_PIXEL(&coordendas,&frame,cor)
	
	addi s6 s6 1
	
	
	# Aplica velocidade / altera coordenada
	mv a0 s0
	mv a1 s1
	mv a2 s2
	mv a3 s3
	jal ra APPLY_SPEED	# void APPLY_SPEED(&coordenadas,&speed,&speed_i,&dir)
	
	# Coloca pixel
	mv a0 s0
	li a1 FRAME_0
	addi a2 zero 0xFF
	jal ra PRINT_PIXEL	# void PRINT_PIXEL(&coordendas,&frame,cor)
	
	#SLEEP
	li a0 10	# 100 ms
	li a7 132
	ecall
j MAIN_LOOP

# FINISH
addi a7 zero 10
ecall
# FIM DA MAIN
#######################################
# a0 = &SPEED a1 = &dir  | a2 = &ADC_CHx | a3 = &ADC_CHy
GET_SPEED:
	lh t1 0(a2)	# Speed x
	lh t2 0(a3)	# Speed y
	
	
	
	csrrw zero 1 t1
	csrrw zero 2 t2
	
	# Aplica offset
	li t3 -2467
	li t4 -2512
	add t1 t1 t3
	add t2 t2 t4
	
	addi t3 zero 0	# Direcao
	# Dados de x
	bge t1 zero GET_SPEED$elseif1
		# Direção
		li t4 0x0000FFFF
		or t3 t4 t3
		# Velocidade
		xori t1 t1 -1
		addi t1 t1 1
	GET_SPEED$elseif1:
	beq t1 zero GET_SPEED$else1
		# Direcao
		ori t3 t3 1
	GET_SPEED$else1:
	# Dados de y
	bge t2 zero GET_SPEED$elseif2
		# Direção
		li t4 0xFFFF0000
		or t3 t4 t3
		# Velocidade
		xori t2 t2 -1
		addi t2 t2 1
	GET_SPEED$elseif2:
	beq t2 zero GET_SPEED$else2
		# Direcao
		lui t4 0x10
		or t3 t3 t4
	GET_SPEED$else2:
	# Guarda velocidades
	sh t1 0(a0)
	sh t2 2(a0)
	# Guarda direcao
	sw t3 0(a1)
	# Ret: void
	ret
#FIM: GET_SPEED


# a0 = &velocidades inteiras POSITIVAS | # a1 = &DIR
CVT_TO_SPEED:
	# Carrega velocidades
	lhu t0 0(a0)
	lhu t1 2(a0)	
	# Obtém max em float
	addi t2 zero MAX_SPEED
	# Obter o inverso das velocidades invertidas
	divu t0 t2 t0	# 1/(max/v) = v (vale 1 se v = max)
	divu t1 t2 t1	# 1/(max/v) = v (vale 1 se v = max)
	# OBS: DIVISÃO POR 0 SINALIZA NOS REGS CSRR
	# Guarda resultado
	sh t0 0(a0)
	sh t1 2(a0)
	# Ret: void
	ret
# FIM: CVT_TO_SPEED

# a0 = &coordenadas (x,y) | a1 = &speed | a2 = &speed_i | a3 = &dir
APPLY_SPEED:
	# Salva registradores
	addi sp sp -8
	sw s0 0(sp)
	sw s1 4(sp)
	# Carrega coordenadas
	#lh t0 0(a0)	# t0 = x
	#lh t1 2(a0)	# t1 = y
	LOAD_COOR(a0,t0,t1)
	# Carrega velocidades
	lhu t2 0(a1)
	lhu t3 2(a1)
	# Carrega contadores de velocidade
	lhu t4 0(a2)	# t4 = contador x
	lhu t5 2(a2)	# t5 = contador y
	# Carrega direcoes:
	lh s0 0(a3)	# Passo h
	lh s1 2(a3)	# Passo v

	# Soma coordenadas às velocidade
	bltu t4 t2 APPLY_SPEED$IF1	# Caso a velocidade seja igual ou menor que o contador, entra no if
	 	addi t4 zero 0 # Zera contador
	 	# Move coordenada
	
	 	add t0 t0 s0	# t0 = x + h

		j APPLY_SPEED$JUMP1
	APPLY_SPEED$IF1:	
		addi t4 t4 1 # Soma um no contador e nao altera coordenada
	
	APPLY_SPEED$JUMP1:
	bltu t5 t3 APPLY_SPEED$IF2	# Caso a velocidade seja igual ao contador, entra no if
	 	addi t5 zero 0 # Zera contador
	 	# Move coordenada
	
	 	sub t1 t1 s1	# t1 = y - v
		addi t3 t3 100
		sh t3 2(a1)
		j APPLY_SPEED$JUMP2	
	APPLY_SPEED$IF2:
		addi t5 t5 1 # Soma um no contador e nao altera coordenada
		
	APPLY_SPEED$JUMP2:
	# Guarda contadores
	sh t4 0(a2)
	sh t5 2(a2)
	# Aplica mod nas coordendas
	addi t2 zero 320
	addi t3 zero 240
	# Para x:
	add t0 t0 t2	# t0 = (x+320)
	rem t0 t0 t2	# t0 = (x+320)%320 = x
	# Para y:
	add t1 t1 t3	# t0 = (y+240)
	rem t1 t1 t3	# t0 = (y+240)%240 = y
	# Guarda coordenadas
	sh t0 0(a0)
	sh t1 2(a0)
	# Recupera registradores
	lw s0 0(sp)
	lw s1 4(sp)
	addi sp sp 8
	# ret: void
	ret
# END: APPLY_SPEED

# a0 = &coordenadas (x,y) | a1 = frame (endereço) | a2 = cor
PRINT_PIXEL:
	# Carrega coordenadas
	#lh t0 0(a0)	# t0 = x
	#lh t1 2(a0)	# t1 = y
	LOAD_COOR(a0,t0,t1)
	# Dimensões do bitmap
	addi t2 zero 320
	# Calcula deslocamento
	mul t2 t2 t1	# t2 = y*320
	add t2 t2 t0	# t2 = y*320 + x
	# Calcular endereço
	add t0 t2 a1	# t2 = frame + (y*320 + x)
	# Colocar pixel
	sb a2,0(t0)	# Coloca pixel branco
	# Ret: void
	ret
# FIM: PRINT_PIXEL


.include "../SYSTEMv14.s"
