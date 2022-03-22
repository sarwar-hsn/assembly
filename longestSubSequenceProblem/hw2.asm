.data
	fileName : .asciiz "C:/Users/swr/Desktop/asm/input.txt"
	buffer : .space 1024
	newLine : .asciiz "\n"
	array : .word 
	sequence: .word 1:200
	divider: .asciiz "\n---------------\n"
	space: .asciiz " "
	lSeq: .asciiz "longest increasing sequence :"
.text
	main:
		
	#load the file
	li $v0, 13		#syscall to load file 
	la $a0, fileName 	#specifying file name
	li $a1, 0		#syscall to read file (0), write file (1)
	syscall			#executing
	move $s0 , $v0		#saving file to register
	
	#read file
	li $v0, 14 		#syscall to read from file
	move $a0, $s0		#give the file handler
	la $a1, buffer 		#contents of the file 
	la $a2, 1024		#hardcoded file length
	syscall
	
	
	#read charecter from buffer
	addi $t0, $zero , 0	#index of file buffer
	addi $t6, $zero , 0 	#index of array
	lb $t1, buffer($t0)	#char at index 0
	li $s3, ' '		#loading a reg with space to compare
	li $s1, '-'
	addi $s2 , $zero , 0  	#isNegetive 0 for false 1 for true
	addi $t3, $zero , 0    #temp number
	while: beqz $t1, endWhile #while not the end of string 
		beq $t1, $s1 , negetiveFlag
		beq $t1, $s3, spaceDetected
			
			#converting char to int
			addi $t4, $zero , 48
			sub $t4, $t1, $t4
			
			#concatenating to interger nunber
			mul $t5 , $t3, 10 #10 * temp
			add $t3, $t4, $t5 # temp = int +(10 * temp)
			j endIf
			
		spaceDetected:
			beqz $s2,positiveNum
				mul $t3, $t3, -1
				sw $t3, array($t6)	#add in the array
				addi $t6, $t6, 4 	#increase the array index by one word
				addi $t3, $zero , 0 	#make temp number 0 again
				addi $s2, $zero , 0 	#reseting negetive flag
				j endIf
				
				positiveNum: 
				sw $t3, array($t6)	#add in the array
				addi $t6, $t6, 4 	#increase the array index by one word
				addi $t3, $zero , 0 #make temp number 0 again
				addi $s2, $zero , 0 #reseting negetive flag
				j endIf
		negetiveFlag: 
			addi $s2, $zero , 1 #set negetive flag to true
		endIf:
		addi $t0, $t0, 1 #increase index by one
		lb $t1, buffer($t0) #loading the next charecter	
		j while
	endWhile: 
		beqz $s2,lastPosNum
			mul $t3, $t3, -1
			sw $t3, array($t6)	#add in the array
			j end
		lastPosNum:
			sw $t3, array($t6)	#add in the array
	end:
		addi $s3, $t6, 0	#index of array saved in s3
	#close file 
	li $v0, 16
	move $a0, $s0
	syscall
	
	#doubling the size of the array and add 1 in there
	addi $t0,$s3,4
	addi $t1, $zero, 1
	mul $s4,$s3,2
	addi $s4,$s4,4 #lenght of sequence array
		
	initSeq:
		bgt $t0,$s4 endSeq
		lw $t1,array($t0)
		addi $t0, $t0,4
		j initSeq
	endSeq:
	
	#subsquence in array
	addi $t1, $zero, 0
	add $s5,$s4,$s3
	addi $s5,$s5,4 #lenght of sequence array
	addi $t0, $s4,4
	
	#getting the longest subseq value
	#s3 registor has the lenght of the array
	
	addi $t0, $zero, 0	#index j
	outerloop: 
		bgt $t0, $s3,endouterloop
		add $t1, $zero, 0	#index i
		
		innerloop: 
			bgt $t1, $t0, endinnerloop
				lw $t2, array($t0) #array[j]
				lw $t3, array($t1) #array[i]
			
				bgt $t2,$t3,increaseSeq 	#if array[j](t2) > array[i](t3) 
					j endincreaseIf
				increaseSeq:
					add $t6 ,$s3,$t1
					addi $t6,$t6,4 #index i for seq
					lw $t2,array($t6) #temp = seq(i)
					addi $t2,$t2,1 #temp = temp + 1   
					
					add $t6,$s3,$t0
					addi $t6,$t6,4 #index j for seq
					lw $t3,array($t6) #seq[j]
					bgt $t2,$t3, doIncrease #temp > seq[j]
						j endseqIf
					doIncrease:
						sw $t2,array($t6)
					endseqIf:
					
					bge $t2,$t3, subseqIndex #if (seq[j](t3) <= temp(t2))
						j endsubseqIndex
					subseqIndex:
						addi $t6,$s4,4
						add $t6,$t6,$t0
						sw $t1,array($t6)
						
					endsubseqIndex:
			endincreaseIf:
			
			addi $t1,$t1,4 #increase index of array
			j innerloop
		endinnerloop:
		addi $t0,$t0,4	#incresing outerloop index
		j outerloop
	endouterloop:

	
	addi $t0,$s3,4 # i = 0
	addi $t1,$zero,0 #highest index
	addi $t0,$t0,4 #increase index by 1 i =1
	
	highestIndex: bgt $t0,$s4,endHI #i starts from i+1
		lw $t2,array($t0) #seq[i]
		lw $t3, array($t1)#higest value
		bgt $t2,$t3,newValue	#if  seq[i] > highestvalue
			j endHiIf
		newValue:
			addi $t1,$t0,0 #updated highest index
		endHiIf:
		addi $t0,$t0,4
		j highestIndex
	endHI:
	
	move $s0,$t1 #highet index in terms of subsequence array
	
	#longest increasing sequence 
	li $v0,4
	la $a0,lSeq
	syscall
	li $v0,1
	lw $a0,array($s0)
	syscall
	jal printLine

	
	#end of the program 
	li $v0, 10
	syscall
	
	
printLine: 
	li $v0, 4
	la $a0, newLine
	syscall
	jr $ra

	
printDivider:
	li $v0, 4
	la $a0, divider
	syscall
	jr $ra
	
printSpace:
	li $v0, 4
	la $a0, space
	syscall
	jr $ra
