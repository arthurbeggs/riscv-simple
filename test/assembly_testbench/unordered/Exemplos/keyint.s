####################################################
#  Programa de exemplo de interrupçao do teclado   #
#  usando o Keyboard Display MMIO Tool		   #
#  ISC Nov 2017				           #
#  Marcus Vinicius			           #
####################################################

NÃO FUNCIONA E NÃO ENTENDI AINDA PORQUE.

.text
# programa do usuário
	li t1,0xFF200000	# Endereço de controle do KDMMIO
	li t0,0x02		# bit 1 habilita/desabilita a interrupção
	sw t0,0(t1)   		# Habilita interrupção do teclado

 	la t0,KDInterrupt	# carrega em t0 o endereço base das rotinas do sistema ECALL
 	csrrw zero,5,t0 	# seta utvec (reg 5) para o endereço t0
 	csrrsi zero,0,1 	# seta o bit de habilitação de interrupção em ustatus (reg 0)
 
	li s0,0		# zera contador
CONTA:	   	# incrementa contador
	j CONTA			# volta ao loop
	

# rotina de tratamento da interrupção
KDInterrupt: 	li t1,0xFF200000		# carrega o endereço base do KDMMIO
  		lw t2,4(t1)  			# le a tecla
		sw t2,12(t1) 			# escreve no display

E_FIM:	csrrw t0, 65, zero	# le o valor de EPC salvo no registrador uepc (reg 65)
	addi t0, t0, 4		# soma 4 para obter a instrução seguinte ao ecall
	csrrw zero, 65, t0	# coloca no registrador uepc
	uret			# retorna PC=uepc		
