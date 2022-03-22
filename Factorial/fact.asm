.data


.text
	main:
	
	addi $v0,$zero, 1
	addi $a0,$zero, 5
	jal fact
	

	move $t0,$v0	#moving the result of factorial in t0
	#printing the result
	li $v0, 1
	move $a0, $t0
	syscall

	
	
	#end of the program
	li $v0, 10
	syscall
	
	fact:
	addi $sp,$sp, -8 	#allocating space for 2 int
	sw $a0, 0($sp)		#storing argument in stack
	sw $ra, 4($sp)		#stroing return address
	slti $t0, $a0,1		#if ( n < 1 ) t0 = 1 or t0 = 0 ; base case
	beq $t0, $zero,cont	#if ( n > 1 ) return n * (n - 1 )
	addi $sp,$sp,8		#deleting allocated memory
	jr $ra 	
	cont: 
	addi $a0,$a0,-1		#decreamenting size ( n - 1 )
	jal fact		#recursive calling
	lw $a0, 0($sp) 		#taking data from stack 
	lw $ra, 4($sp)		#restoring prev calling function address
	addi $sp,$sp,8		#deleting allocated memory
	mul $v0, $v0,$a0	#multiplying values
	jr $ra 			#going back to caller function

