#################################################
#	Testbench para a ISA RV32IMF
#  Baseado no trabalho:
#
# 2018/2
# Igor Figueira Pinheiro da Silva
# Antonio Henrique de Moura Rodrigues
# Gabriel Patrick Alcantara Mourao
# Tiago
#
#
# Marcus Vinicius Lamar
# 2019/1
#################################################

# Use o timer da DE1 para ter uma medida do desempenho

.data
F0:       .float 3.0
F1:       .float 4.0
FSOMA:    .float 7.0
FSUB:     .float 1.0
FMUL:     .float 12.0
FDIV:     .float 0.75
FSQRT:    .float 2.0
FCVTSW:   .word  4
FCVTSWU:  .word  4
FLW_E_SW: .float 0
FSGNJN:   .float -3.0
MSG:	.string "Endereco do erro : "
MSG2:	.string "RV32IMF - Nao ha erros :)"


.text
	la t6,exceptionHandling		# carrega em t6 o endereço base das rotinas do sistema ECALL
	csrrsi zero,0,1 		# seta o bit de habilitação de interrupção em ustatus (reg 0)
	csrrw zero,5,t6 		# seta utvec (reg 5) para o endereço t6
	
	li s11, 0	# contador de Loops
	
MAIN:	la t1, F0
	flw ft0, 0(t1)
	flw ft1, 4(t1)
	
	fadd.s ft10, ft0, ft1 # resultado da soma
	flw ft11, 8(t1)
	feq.s t0, ft10, ft11
	bne t0, zero, PULAERRO1
	jal t0, ERRO
	
PULAERRO1: fsub.s ft10, ft1, ft0 # teste subtracao
	   flw ft11, 12(t1)
	   feq.s t0, ft10, ft11
	   bne t0, zero, PULAERRO2
	   jal t0, ERRO
	   
PULAERRO2: fmul.s ft10, ft0, ft1 # teste multiplicacao
	   flw ft11, 16(t1)
	   feq.s t0, ft10, ft11
	   bne t0, zero, PULAERRO3
	   jal t0, ERRO
	   
PULAERRO3: fdiv.s ft10, ft0, ft1 # teste divisao
	   flw ft11, 20(t1)
	   feq.s t0, ft10, ft11
	   bne t0, zero, PULAERRO4
	   jal t0, ERRO
	   
PULAERRO4: fsqrt.s ft10, ft1 # teste sqrt
	   flw ft11, 24(t1)
	   feq.s t0, ft10, ft11
	   bne t0, zero, PULAERRO5
	   jal t0, ERRO
	   
PULAERRO5: fcvt.w.s t2, ft1  # teste cvt w s
	   lw t3, 28(t1)
	   beq t2, t3, PULAERRO6
	   jal t0, ERRO

PULAERRO6: fcvt.wu.s t2, ft1 # teste cvt wu s
	   lw t3, 32(t1)
	   beq t2, t3, PULAERRO7
	   jal t0, ERRO
	   
PULAERRO7: li t2, 4        # teste cvt s w
	   fcvt.s.w ft10, t2
	   nop				# Bug na unidade Forward
	   feq.s t0, ft10, ft1
	   bne t0, zero, PULAERRO8
	   jal t0, ERRO

PULAERRO8: li t2, 4      # teste cvt s wu
	   fcvt.s.wu ft10, t2
	   nop				# Bug na unidade Forward
	   feq.s t0, ft10, ft1
	   bne t0, zero, PULAERRO9
	   jal t0, ERRO
	   
PULAERRO9: li t2, 0x40400000 # teste mv s x
	   fmv.s.x ft10, t2 
	   feq.s t0, ft0, ft10
	   bne t0, zero, PULAERRO10
	   jal t0, ERRO
	   
PULAERRO10: li t2, 0x40800000 # teste mv x s
	    fmv.x.s t3, ft1 
	    beq t2, t3, PULAERRO11
	    jal t0, ERRO

PULAERRO11: feq.s t0, ft0, ft0 # teste feq
	    bne t0, zero, PULAERRO12
	    jal t0, ERRO
	    
PULAERRO12: fle.s t0, ft0, ft1 # teste fle
	    bne t0, zero, PULAERRO13
	    jal t0, ERRO
	    
PULAERRO13: flt.s t0, ft0, ft1 # teste flt
	    bne t0, zero, PULAERRO14
	    jal t0, ERRO

PULAERRO14: flw ft2, 0(t1) # testes flw e fsw
	    fsw ft2, 36(t1)
	    flw ft2, 36(t1)
	    fmv.x.s t0, ft2
	    bne t0, zero, PULAERRO15
	    jal t0, ERRO
	    	    
PULAERRO15: fsgnj.s ft10, ft0, ft1 # teste fsgnj
	    feq.s t0, ft10, ft0
	    bne t0, zero, PULAERRO16
	    jal t0, ERRO
	    
PULAERRO16: fsgnjn.s ft10, ft0, ft1 # teste fsgnjn
	    flw ft11, 40(t1)
	    feq.s t0, ft11, ft10
	    bne t0, zero, PULAERRO17
	    jal t0, ERRO
	    
PULAERRO17: fsgnjx.s ft10, ft0, ft1 # teste fsgnjx
	    feq.s t0, ft10, ft0
	    bne t0, zero, PULAERRO18
	    jal t0, ERRO
	    
PULAERRO18: fmax.s ft10, ft0, ft1 # teste fmax
	    feq.s t0, ft10, ft1
	    bne t0, zero, PULAERRO19
	    jal t0, ERRO

PULAERRO19: fmin.s ft10, ft0, ft1 # teste fmin
	    feq.s t0, ft10, ft0
	    bne t0, zero, SUCESSO
	    jal t0, ERRO


SUCESSO: bgt s11,zero,PULA1
   	li a0, 0x38
   	li a1, 0
	li a7, 148
	ecall
	
	#print string sucesso
	li a3,0x3800
	li a7, 104
	la a0, MSG2
	li a1, 64
	li a2, 0
	li a4, 0
	ecall

PULA1:	mv a0, s11
	li a7, 101
	li a1, 140
	li a2, 120
	li a3, 0x3800
	li a4, 0
	ecall

	addi s11, s11, 1
	j MAIN
	
ERRO:	li a0, 0x07
	li a7, 148
	li a1, 0
	ecall
		
	#Print string erro
	li a7, 104
	la a0, MSG
	li a1, 0
	li a2, 0
	li a3, 0x0700
	li a4, 0
	ecall
	
	#print endereco erro
	addi a0, t0, -12 #Endereco onde ocorreu o erro
	li a7, 134
	li a1, 148
	li a2, 0
	li a3, 0x0700
	li a4, 0
	ecall
	
	#end
END: 	addi a7, zero, 10
	ecall
	
.include "..\SYSTEMv14.s"
	
