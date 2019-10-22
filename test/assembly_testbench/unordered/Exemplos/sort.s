.eqv N 10

.data
vetor:  .word 5,8,3,4,7,6,8,0,1,9
newl:	.string "\n"
tab:	.string "\t"


.text	
MAIN:	la a0,vetor
	li a1,N
	jal show

	la a0,vetor
	li a1,N
	jal sort

	la a0,vetor
	li a1,N
	jal show

	li a7,10
	ecall


swap:	slli t1,a1,2
	add t1,a0,t1
	lw t0,0(t1)
	lw t2,4(t1)
	sw t2,0(t1)
	sw t0,4(t1)
	ret

sort:	addi sp,sp,-20
	sw ra,16(sp)
	sw s3,12(sp)
	sw s2,8(sp)
	sw s1,4(sp)
	sw s0,0(sp)
	mv s2,a0
	mv s3,a1
	mv s0,zero
for1:	bge s0,s3,exit1
	addi s1,s0,-1
for2:	blt s1,zero,exit2
	slli t1,s1,2
	add t2,s2,t1
	lw t3,0(t2)
	lw t4,4(t2)
	bge t4,t3,exit2
	mv a0,s2
	mv a1,s1
	jal swap
	addi s1,s1,-1
	j for2
exit2:	addi s0,s0,1
	j for1
exit1: 	lw s0,0(sp)
	lw s1,4(sp)
	lw s2,8(sp)
	lw s3,12(sp)
	lw ra,16(sp)
	addi sp,sp,20
	ret

show:	mv t0,a0
	mv t1,a1
	mv t2,zero

loop1: 	beq t2,t1,fim1
	li a7,1
	lw a0,0(t0)
	ecall
	li a7,4
	la a0,tab
	ecall
	addi t0,t0,4
	addi t2,t2,1
	j loop1

fim1:	li a7,4
	la a0,newl
	ecall
	ret
