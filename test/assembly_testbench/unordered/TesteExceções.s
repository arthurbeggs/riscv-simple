.data 

Teste1:		.string "Japao"

.text 
la t6,exceptionHandling		# carrega em t6 o endereço base das rotinas do sistema ECALL
csrrsi zero,0,1 		# seta o bit de habilitação de interrupção em ustatus (reg 0)
csrrw zero,5,t6 		# seta utvec (reg 5) para o endereço t6


li a7 141 # num aleatorio em a0
ecall  # teste da causa 8 = enviroment call


li t0 7
remu a0 a0 t0 # a0 = a0 mod 7

li t0 0
beq a0 t0 Case0

li t0 1
beq a0 t0 Case1

li t0 2
beq a0 t0 Case2

li t0 3
beq a0 t0 Case4

li t0 4
beq a0 t0 Case5

li t0 5
beq a0 t0 Case6

li t0 6
beq a0 t0 Case7


Case0: # Instruction address misaligned

li ra 0x0000ffff
jr ra

Case1: #  Instruction access fault 

li ra 0x0000ff00
jr ra

Case2: # Ilegal Instruction (detectada somente na fpga)

wfi #instrução nao implementada na fpga 0x10500073 

Case4: # Load address misaligned 

li t0 0xff00001
lh s0 (t0)

Case5: # Load access fault 

li t0 0xaaaa0000
lh s0 (t0)

Case6: # Store address misaligned 

li t0 0xff00001
sh s0 (t0)

Case7: # Store access fault 

li t0 0xaaaa0000
sh s0 (t0)



li a7 10
ecall

.include "SYSTEMv14.s"
