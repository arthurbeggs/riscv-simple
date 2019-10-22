.include "../macros2.s"

# Inicio da musica do Mario

.text
	M_SetEcall(exceptionHandling)	# Macro de SetEcall - não tem ainda na DE1-SoC
	
	li	a0, 66
	li	a1, 400
	li	a2, 1
	li	a3, 127
	li	a7, 31
	M_Ecall
	li	a0, 76
	li	a1, 400
	li	a2, 4
	li	a3, 127
	li	a7, 33
	M_Ecall
	
	li	a0, 66
	li	a1, 400
	li	a2, 1
	li	a3, 127
	li	a7, 31
	M_Ecall
	li	a0, 76
	li	a1, 400
	li	a2, 4
	li	a3, 127
	li	a7, 33
	M_Ecall
	
	li	a0, 66
	li	a1, 400
	li	a2, 1
	li	a3, 0
	li	a7, 31
	M_Ecall
	li	a0, 76
	li	a1, 400
	li	a2, 4
	li	a3, 0
	li	a7, 33
	M_Ecall
	
	li	a0, 66
	li	a1, 400
	li	a2, 1
	li	a3, 127
	li	a7, 31
	M_Ecall
	li	a0, 76
	li	a1, 400
	li	a2, 4
	li	a3, 127
	li	a7, 33
	M_Ecall
	
	li	a0, 66
	li	a1, 400
	li	a2, 1
	li	a3, 0
	li	a7, 31
	M_Ecall
	li	a0, 76
	li	a1, 400
	li	a2, 4
	li	a3, 0
	li	a7, 33
	M_Ecall
	
	li	a0, 66
	li	a1, 400
	li	a2, 1
	li	a3, 127
	li	a7, 31
	M_Ecall
	li	a0, 72
	li	a1, 400
	li	a2, 4
	li	a3, 127
	li	a7, 33
	M_Ecall

	li	a0, 66
	li	a1, 400
	li	a2, 1
	li	a3, 127
	li	a7, 31
	M_Ecall
	li	a0, 76
	li	a1, 400
	li	a2, 4
	li	a3, 127
	li	a7, 33
	M_Ecall
	
	li	a0, 66
	li	a1, 400
	li	a2, 1
	li	a3, 0
	li	a7, 31
	M_Ecall
	li	a0, 76
	li	a1, 400
	li	a2, 4
	li	a3, 0
	li	a7, 33
	M_Ecall
	
	li	a0, 67
	li	a1, 400
	li	a2, 1
	li	a3, 127
	li	a7, 31
	M_Ecall
	li	a0, 71
	li	a1, 400
	li	a2, 4
	li	a3, 127
	li	a7, 31
	M_Ecall
	
	li	a0, 79
	li	a1, 400
	li	a2, 1
	li	a3, 127
	li	a7, 33
	M_Ecall
	li	a0, 76
	li	a1, 1000
	li	a2, 4
	li	a3, 0
	li	a7, 33
	M_Ecall

	li	a0, 67
	li	a1, 1200
	li	a2, 6
	li	a3, 127
	li	a7, 33
	M_Ecall
	
	
end_loop:	
	li	a7, 10
	M_Ecall

	
.include "../SYSTEMv13.s"
