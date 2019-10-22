# teste

.data
	NUM: .word 0x10010000, 5
.text
	la t0,NUM
	lw t1,4(t0)
	add t1,t1,t1
	add t1,t1,t1
	add t1,t1,t1
