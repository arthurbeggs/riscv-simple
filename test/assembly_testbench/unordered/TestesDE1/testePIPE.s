# Teste para verificação da simulação por forma de onda no Quartus Prime
# A execução deve ser a mesma do Rars e na DE1-SoC
# Se for diferente deve ser devido a hazards não tratados no hardware
# Onde colocar nops de forma a corrigir os hazards?

.data
	NUM: .word 5
.text
INICIO: addi 	t0,zero,100
	nop
	addi 	sp,sp,-4
	sw	t0,0(sp)
	lw	t0,0(sp)
	addi 	sp,sp,4
	ori 	t0,t0,1
	ori	t0,t0,4
	add 	t0,t0,t0
    	mul     t0,t0,t0
    	add     t0,t0,t0
    	addi    t0,t0,7  
	addi 	t0,t0,-1
	lui 	tp,0x014
	addi    tp,tp,0xfffffece
	bne 	t0, tp,ERRO
	la 	t1,NUM
	lw 	t0,0(t1)
	add	t0,t0,t0
	sw 	t0,4(t1)	
	lw 	t0,4(t1)
	li 	tp,0xA	
	beq 	t0,tp,LABEL1
	j 	ERRO

LABEL1:	li 	tp,0x20
	blt 	t0,tp,LABEL2
	j 	ERRO

LABEL2: li	tp,1
	bgt 	t0,tp,LABEL3
	mv	t0,zero

LABEL3:	jal LABEL4
	div 	t1,t1,t0
	addi 	t1,t1,1
	add 	t0,t1,t0
	li	tp,0x00ccd9ae
	beq 	t0,tp, LABEL5
	j ERRO

LABEL4:	slli 	t0,t0,2
	srli 	t0,t0,1
	li 	tp,0x14
	bne 	t0,tp,ERRO
	jr ra

LABEL5:	la 	t0, CERTO
	jr 	t0
	lui 	t0,0x0000
	j 	ERRO	

CERTO:	li	t0,0xCCCCCCCC

	li t0,0
LOOP:	addi t0,t0,1
	j LOOP
	
ERRO:	li 	t0,0xEEEEEEEE
FIM: 	li a7,10
	ecall	


	
