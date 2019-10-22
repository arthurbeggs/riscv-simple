#	printf function
	.data				#data segment
str: 	.asciiz "Dash Winterson, CSE3666\nPlease input number in(prefix 0b for bin, 0o for oct, 0x for hex):"
		.align 2
str1:	.asciiz "\nprint value %d in: \nbinary: %b\noctal: %o\nhex: %x\nsigned:%d\nunsigned:%u"
		.align 2
str2:	.asciiz "1234567890ABCDEF %x\n"
		.align 2
invalid_string:
		.asciiz "string has invalid characters, cannot be converted"  #for error message from atoi
		.align 2
		.space 34
string_space:
		.space 4
		.align 4
input_string:
		.space 1024

	.text				# Code segment
	.globl	main		# declare main to be global

main:
	la 		$a0,str 
	li 		$v0,4
	syscall
	la 		$a0,input_string
	li		$a1,100
	li 		$v0,8
	syscall
	jal strip_newline
	jal atoi
	move	$a1,$a0
	move 	$a2,$a0
	move 	$a3,$a0
	addiu	$sp,$sp,-12
	sw 		$a0,($sp)
	sw 		$a0,4($sp)
	sw 		$a0,8($sp)
	la 		$a0,str1
	jal	printf

Exit:	li	$v0,10		# System call, type 10, standard exit
	syscall			# ...and call the OS

#printf function:
#syntax: printf(char* string, arg1,arg2,arg3...)
#supports %d %c %s %% %u %o %b %x
	.text
	.globl printf

printf:
	subu $sp, $sp, 36 	# set up the stack frame,
	sw $ra, 32($sp) 		# saving the local environment.
	sw $fp, 28($sp)
	sw $s0, 24($sp)
	sw $s1, 20($sp)
	sw $s2, 16($sp)
	sw $s3, 12($sp)
	sw $s4, 8($sp)
	sw $s5, 4($sp)
	sw $s6, 0($sp)
	addu $fp, $sp, 36
	move $s7,$fp

	# grab the arguments:
	move $s0, $a0 		# fmt string
	move $s1, $a1 		# arg1 (optional)
	move $s2, $a2 		# arg2 (optional)
	move $s3, $a3 		# arg3 (optional)

	li $s4, 0 			# set number of formats = 0

	# sent up the temporay buffer 36 bytes
	# it was defined as a global buffer
	subu $sp, $sp, 36	
	move $s6, $sp
	#la $s6, printf_buf 	# set s6 = base of printf buffer.

printf_loop: 			# process each character in the fmt:
	lb $s5, 0($s0) 		# get the next character, and then
	addu $s0, $s0, 1 	# bump up $s0 to the next character.

	beq $s5, '%', printf_fmt # if the fmt character, then do fmt.
	beq $0, $s5, printf_end  # if zero, then go to end.

printf_putc:
	sb $s5, 0($s6) 		# otherwise, just put this char
	sb $0, 1($s6) 		# into the printf buffer,
	move $a0, $s6 		# and then print it with the
	li $v0, 4 			# print_str syscall
	syscall

	b printf_loop 		# loop on.

printf_fmt:
	lb $s5, 0($s0) 		# see what the fmt character is,
	addu $s0, $s0, 1 	# and bump up the pointer.

	# if we already processed 3 args,
	beq $s4, 6, printf_invalidtag

	# then *ignore* this fmt.
	beq $s5, 'd', printf_int  # if 'd', print as an integer.
	beq $s5, 's', printf_str  # if 's', print as a string.
	beq $s5, 'c', printf_char # if 'c', print as an ASCII char.
	beq $s5, '%', printf_perc # if '%', print a '%'
##############################################
#ADDED CODE
	beq $s5, 'u', printf_unsign
	beq $s5, 'x', printf_hex
	beq $s5, 'o', printf_oct
	beq $s5, 'b', printf_bin
##############################################
	
	# otherwise, just continue.

printf_invalidtag: 		# print out invalid tags
	sb $0, 2($s6) 		# the a null.
	sb $s5, 1($s6) 		# the tag specifier
	li $s5, '%'   		# %,
	sb $s5, 0($s6) 
	move $a0, $s6 		# and then do a print_str syscall
	li $v0, 4 			# on the buffer.
	syscall
	b printf_loop 		# branch to printf_loop

printf_shift_args: 		# shift over the fmt args,
	move 	$s1, $s2 		# $s1 = $s2
	move 	$s2, $s3 		# $s2 = $s3
##############################################
#ADDED CODE
	lw		$s3, ($s7)
	addiu 	$s7,$s7,4
##############################################
	add $s4, $s4, 1 		# increment #args processed.

	b printf_loop 		# and continue the main loop.

printf_int: 			# deal with a %d:
	move $a0, $s1 		# do a print_int syscall of $s1.
	li $v0, 1
	syscall
	b printf_shift_args 	# branch to printf_shift_args

printf_str: 			# deal with a %s:
	move $a0, $s1 		# do a print_string syscall of $s1.
	li $v0, 4
	syscall
	b printf_shift_args 	# branch to printf_shift_args

printf_char: 			# deal with a %c:
	sb $s1, 0($s6) 		# fill the buffer in with byte $s1,
	sb $0, 1($s6) 		# and then a null.
	move $a0, $s6 		# and then do a print_str syscall
	li $v0, 4 			# on the buffer.
	syscall
	b printf_shift_args 	# branch to printf_shift_args
##############################################
#ADDED CODE
printf_unsign:
	li 	 	$t0,10		#radix
	la 		$a0,string_space #pointer at end of string, will fill backwards
	jal 	translate
	li $v0, 4
	syscall
	b printf_shift_args

printf_hex:
	li 	 	$t0,16		#radix
	la 		$a0,string_space #pointer at end of string, will fill backwards
	jal 	translate
	li $v0, 4
	syscall
	b printf_shift_args

printf_oct:
	li 	 	$t0,8		#radix
	la 		$a0,string_space #pointer at end of string, will fill backwards
	jal 	translate
	li $v0, 4
	syscall

	b printf_shift_args

printf_bin:
	li 		$t0,2
	la 		$a0,string_space
	jal 	translate
	li $v0, 4
	syscall
	b printf_shift_args
##############################################


printf_perc: 			# deal with a %%:
	li $s5, '%' 		# (this is redundant)
	sb $s5, 0($s6) 		# fill the buffer in with byte %,
	sb $0, 1($s6) 		# and then a null.
	move $a0, $s6 		# and then do a print_str syscall
	li $v0, 4 			# on the buffer.
	syscall
	b printf_loop 		# branch to printf_loop

printf_end:
	subu $sp, $fp, 36	
	lw $ra, 32($sp) 		# restore the prior environment:
	lw $fp, 28($sp)
	lw $s0, 24($sp)
	lw $s1, 20($sp)
	lw $s2, 16($sp)
	lw $s3, 12($sp)
	lw $s4, 8($sp)
	lw $s5, 4($sp)
	lw $s6, 0($sp)
	addu $sp, $sp, 36 	# release the stack frame.
	jr $ra 			# return.

	## end of printf sample code
##############################################
#ADDED CODE
translate:
	addiu	$a0,$a0,-1

	divu 	$s1,$t0
	mflo	$s1
	mfhi	$t1

	bgt 	$t1,9,char
	addiu 	$t1,$t1,48
	j 		finish
char:
	addiu	$t1,$t1,55

finish:
	sb 		$t1,($a0)

	bgtz 	$s1,translate
	jr 		$ra
##############################################


#atoi(char* string)
atoi:
	lh 		$s0,($a0)
	li 		$t7,0x7830			#decimal value for x0 in ascii
	li 		$t6,0x6f30			#decimal value for o0 in ascii
	li 		$t5,0x6230			#decimal value for b0 in ascii
	li 		$s3,10 				#default radix is 10
	beq 	$s0,$t5,atoi_bin	#0b
	beq 	$s0,$t6,atoi_oct	#0o
	beq 	$s0,$t7,atoi_hex  #0x
	j 		atoi_process
atoi_bin:
	addiu 	$a0,$a0,2
	li 		$s3,2
	j 		atoi_process
atoi_oct:
	addiu 	$a0,$a0,2
	li 		$s3,8
	j 		atoi_process
atoi_hex:
	addiu 	$a0,$a0,2
	li 		$s3,16
	#no need to jump


atoi_process:
	#li 		$s1,0 				#boolean for sign bit, multiply by -1 later  ######NO LONGER NEED IT
	li 		$s0,0 				#zero out s0
	li 		$s2,1 				#s2 for counter (for figuring base 10 position ie. 10^$s2)
	li 		$s4,-1 				#for flipping when sign is negative with mult
	li 		$s0,0 				#make sure s0 is set to zero, will be final val
	move 	$s6,$a0
loopend:
	addiu 	$s6,$s6,1 #traversing backwards will be faster
	lb 		$s0,($s6)
	bgtz 	$s0,loopend
loop:
	addiu 	$s6,$s6,-1
	lb		$s0,($s6)
	bgt 	$s0,96,atoi_char_upper 		#checks to see if is lower case a-f
	bgt 	$s0,57,atoi_char 			#checks to see if upper case a-f
	addiu	$s0,$s0,-48 					#otherwise treat as 0-9 
	j 		atoi_continue 
atoi_char:
	addiu 	$s0,$s0,-55
	j 		atoi_continue
atoi_char_upper:
	addiu  	$s0,$s0,-87

atoi_continue:
	beq 	$s0,-3,atoi_sign
	bltz 	$s0,atoi_invalid 		#check to make sure is in bottom range and
	bge 	$s0,$s3,atoi_invalid  #if number is greather than radix or less than zero (and not the negative sign) string is invalid
	mult 	$s0,$s2
	mflo 	$s0
	addu 	$s5,$s5,$s0
	mult 	$s2,$s3
	mflo 	$s2
	j 		atoi_continue2
atoi_sign:
	mult 	$s5,$s4
	mflo 	$a0
	jr 		$ra
atoi_continue2:
	blt 	$a0,$s6,loop 
	move 	$a0,$s5
	jr 		$ra
atoi_invalid:
	la 		$a0,invalid_string
	li		$v0,4
	syscall
	li 		$v0,10
	syscall
	
strip_newline:
	lb 		$t0,($a0)
	li 		$t1,0x0a #newline char
	beq 	$t0,$t1,strip_setnull
	beqz 	$t0,strip_setnull
	j 		strip_continue
strip_setnull:
	sb  	$0,($a0)
	la 		$a0,input_string
	jr 		$ra
strip_continue:
	addiu 	$a0,$a0,1
	b 		strip_newline