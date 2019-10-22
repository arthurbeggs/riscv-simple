# Teste para verificacao da simulacao por forma de onda no Quartus-II
# O programa verifica automaticamente se tem a FPU implementada
# testas as instrucoes criticas fsqrt.s e div
# os registradores 8 : s0 e fs0 são as saidas, total de 21 instrucoes

.data
NUM: 	.word 5
F1: 	.float 3.5

.text	
	fabs.s fa0,fa1
	la s1,NUM		# s1 = Endereco NUM
	lw s0,0(s1)		# s0 = numero 5
	sw s0,8(s1)		# grava número em NUM+8 na memória
	lw s0,8(s1)		# Le o numero gravado
	li s1,5			# define s1=5
	bne s0,s1,ERRO  	# caso o numero lido seja diferente de 5 é porque deu ruim em algum lugar
	la s1,F1
	flw fs0,0(s1)		# carrega fs0=3.5
	fmv.x.s s0,fs0		# passa para s0
	lui s1,0x40600		#  define s1=3.5 0x40600000
	bne s0,s1,SEMFPU	# indica que nao tem FPU
	fmv.s fs1,fs0		# copia para fs1=3.5
	fadd.s fs0,fs0,fs1	# fs0=7.0
	fmul.s fs0,fs0,fs0	# fs0=49.0
	fsqrt.s fs0,fs0		# fs0=7.0
	fadd.s fs1,fs1,fs1	# fs1=7.0
	feq.s s1,fs0,fs1	# compara  7.0==7.0?
	fcvt.w.s s0,fs0		# converte para inteiro
	bne s1,zero,SEMFPU	# se for verdadeiro PULA
ERRO:	li s0,0xEEEE		# sinaliza que houve EEEErro
FIM:	jal zero,FIM		# trava o processador
SEMFPU:	li s0,7			
	li s1,0x958c96d5	# s1
	jal ra,PROC		# testa jal
	jal zero,FIM		# resultado esperado FocaFofa
PROC:	div s0,s1,s0		# testa div
	jalr zero,ra,0		# testa jalr
