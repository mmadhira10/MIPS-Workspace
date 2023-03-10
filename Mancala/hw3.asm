# Mihir Madhira
# mmadhira
# 112805894

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text

load_game:
	addi $sp, $sp, -16		# preserve save registers
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	move $s2, $a0	# newAddress = garbageAddress
	
	li $v0, 13	# get the file 
	move $a0, $a1	# openFile(Boardfile_name)
	li $a1, 0	# readFile
	syscall
	move $s1, $v0	
	addi $sp, $sp, -4	# make room on stack
	
	bltz $s1, wrgFile	# Wrong File name was given
	

	li $t0, 0		# t0 = lines visited
	loopLinesFile:
	  li $t3, 6		# total amount of bites
	  beq $t0, $t3, returnPart1	# if t0 == 6, return 
	  
	  li $t4, 3	
	  bge $t0, $t4, loopFiveLine # if t0 == 0, check secondLine
	  loopFourLine:
	    li $v0, 14		# v0 = 14, read command
	    move $a0, $s1	# a0 = the file descriptor
	    move $a1, $sp 	# a1 = the address for holding the char
	    li $a2, 1		# a2 = read 1 character
	    syscall 
	    lb $t1, 0($sp)	# get first char stored on stack
	    addi $t1, $t1, -48	# int($t1) => first char to int
	    
	    li $v0, 14		# v0 = 14, read command
	    move $a0, $s1	# a0 = the file descriptor
	    move $a1, $sp 	# a1 = the address for holding the char
	    li $a2, 1		# a2 = read 1 character
	    syscall
	    lb $t2, 0($sp)	# get second char stored on stack
	    li $t9, 48
	    
	    blt $t2, $t9 oneDigitNumber1	# go to the first checker for indent
	    addi $t2, $t2, -48	# int($t2) => second char to int
	    li $t5, 10		
	    mul $t1, $t1, $t5	# multiply first char(t1) by 10
	    add $t1, $t1, $t2	# add the ones places(t2) and put into t1
	    
	    checkFirstLine:
	      bne $t0, $0, checkSecondLine	# if t0 == 0; are we at the right line
	      sb $t1, 1($s2)	# store contents of t1 into s2
	      j nextCharInFile
	      
	    checkSecondLine:
	      li $t5, 1		# t5 = 1
	      bne $t0, $t5, checkThirdLine	# if t0 == 1; are we at line 1
	      sb $t1, 0($s2)	# store contents of t1 into s2
	      j nextCharInFile	
	      
	    checkThirdLine:
	      sb $t1, 2($s2)	# store contents of t1 into s2 1
	      sb $t1, 3($s2)	# store contents of t1 into s2
	      j nextCharInFile
	    
	    nextCharInFile:
	      li $v0, 14	# v0 = 14, read command
	      move $a0, $s1	# a0 = the file descriptor
	      move $a1, $sp 	# a1 = the address for holding the char
	      li $a2, 1		# a2 = read 1 character
	      syscall
	      lb $t2, 0($sp)	# get second char stored on stack
	      j checkR1		# check to see if its \r or \n
	    
	    oneDigitNumber1:
	      bne $t0, $0, checkOneSecondLine	# if t0 == 0; are we at the right line
	      sb $t1, 1($s2)	# store contents of t1 into s2
	      j checkR1		# check to see if its \r or \n
	      
	    checkOneSecondLine:
	      li $t5, 1		# t5 = 1
	      bne $t0, $t5, checkOneThirdLine	# if t0 == 1; are we at line 1
	      sb $t1, 0($s2)	# store contents of t1 into s2
	      j checkR1		# check to see if its \r or \n
	      
	    checkOneThirdLine:
	      sb $t1, 2($s2)	# store contents of t1 into s2 1
	      sb $t1, 3($s2)	# store contents of t1 into s2
	    
	    checkR1:
	      li $t1, 13		# t2 = \r
	      bne $t2, $t1, checkN1	# checks to see if it equals \r
	      li $v0, 14	# v0 = 14, read command
	      move $a0, $s1	# a0 = the file descriptor
	      move $a1, $sp 	# a1 = the address for holding the char
	      li $a2, 1		# a2 = read 1 character
	      syscall
	      lb $t2, 0($sp)	# get \n char stored on stack
	      j checkN1
	    
	    checkN1: 
	      li $t1, 10		# t2 = \n
	      bne $t2, $t1,incFileCount # chceks to see the tab
	      j incFileCount
	    
	  loopFiveLine:
	    li $t4, 3			# t3 = 3
	    bne $t0, $t4, loopSixLine	# if t0 == 3, then jump to loopSixLine
	    sb $0, 4($s2)		# set the 
	    j incFileCount
	    
	  loopSixLine:
	    li $t4, 4			# t3 = 4
	    bne $t0, $t4, loopSevenLine	# if t0 == 4, then jump to loopSixLine
	    li $t1, 'B'			# first player to play
	    sb $t1, 5($s2)		# set the 
	    j incFileCount
	  
	  loopSevenLine:
	    li $t4, 5
	    bne $t0, $t4, incFileCount
	    li $s0, 0			# s0 = total stones
	    lb $t1, 1($s2)		# t1 = stones in top mancala
	    lb $t2, 0($s2)		# t2 = stones in bot mancala
	    add $s0, $t1, $t2		# s0 = t1(top stones) + t2(bot stones)
	    
	    li $t5, 10			# t5 = 10 for dividing
	    
	    div $t1, $t5		# divide to get tens
	    mfhi $t1			# t1 = remainder
	    mflo $t6			# t6 = quotient to put in memory
	    addi $t6, $t6, 0x30		# t6 = quotient(ascii rep)
	    sb $t6, 6($s2)		# store first digit in memory'
	    addi $t1, $t1, 0x30		# ones place into integer
	    sb $t1, 7($s2)		# store first digit in memory
	    
	    addi $s3, $s2, 8		# s3 = address of game board
	    loopThruBoard:		# loop thru game board characters
	      beq $v0, $0, incFileCount	# if reach end of file then increment
	      
	      li $v0, 14	# v0 = 14, read command
	      move $a0, $s1	# a0 = the file descriptor
	      move $a1, $sp 	# a1 = the address for holding the char
	      li $a2, 1		# a2 = read 1 character
	      syscall
	      
	      lb $t6, 0($sp)	# t6 = next char
	      li $t7, 48	# 0-9 char
	      blt $t6, $t7, checkR2	# checks to see if char is not number
	      sb $t6, 0($s3)	# store digit into memory
	      
	      addi $t8, $t6, -48# int(t6) change char into int
	      li $t7, 10	# get tens value of the int
	      mul $t8, $t7, $t8	# t8 = t8 * 10 get the tens value
	      addi $s3, $s3, 1	# get next adress in mancala
	      
	      li $v0, 14	# v0 = 14, read command
	      move $a0, $s1	# a0 = the file descriptor
	      move $a1, $sp 	# a1 = the address for holding the char
	      li $a2, 1		# a2 = read 1 character
	      syscall
	      
	      lb $t6, 0($sp)	# t6 = next char
	      sb $t6, 0($s3)	# store digit into memory
	      addi $t9, $t6, -48# int(t6) change char into int
	      addi $s3, $s3, 1	# get next adress in mancala
	      
	      add $t9, $t8, $t9	# add the values together 
	      add $s0, $s0, $t9 # add to the total amount of stones
	      j loopThruBoard
	      
	    checkR2:
	      li $t7, 13		# t2 = \r
	      bne $t6, $t7, checkN2	# checks to see if it equals \r
	      li $v0, 14	# v0 = 14, read command
	      move $a0, $s1	# a0 = the file descriptor
	      move $a1, $sp 	# a1 = the address for holding the char
	      li $a2, 1		# a2 = read 1 character
	      syscall
	      lb $t6, 0($sp)	# get \n char stored on stack
	      j checkN2
	    
	    checkN2: 
	      li $t7, 10		# t2 = \n
	      bne $t6, $t7,incFileCount # chceks to see the tab
	      j loopThruBoard
	     	  
	  incFileCount:
	    addi $t0, $t0, 1
	    j loopLinesFile
	     
	wrgFile:
	  li $v0, -1
	  li $v1, -1 
	  j end_Part1
	
	returnPart1:
	  li $t5, 10			# t5 = 10 for dividing
	  div $t2, $t5			# divide to get tens
	  mfhi $t2			# t2 = remainder
	  mflo $t6			# t6 = quotient to put in memory
	  addi $t6, $t6, 0x30		# t6 = quotient(ascii rep)
	  sb $t6, 0($s3)		# store first digit in memory
	  addi $t2, $t2, 0x30		# turn ones into ascii
	  sb $t2, 1($s3)		# store first digit in memory
	  
	  li $t5, 99			# check to see if there is 99 stones
	  bgt $s0, $t5, moreStones	# check if there is more 99 
	  li $v0, 1			# valid # of stones
	  j checkPockets
	  
	moreStones:
	  li $v0, 0 			# invalid # of stones
	  
	checkPockets:
	  lb $t1, 2($s2)		# load the pockets
	  li $t6, 2
	  mul $t1, $t1, $t6		# t6 = t6 * 2
	  li $t5, 98
	  bgt $t1, $t5, morePockets	# if t1 <= 98 then return stones
	  move $v1, $t1			# v1 = # of stones
	  j end_Part1
	  
	morePockets:
	  li $v1, 0
	
	end_Part1:
	  move $t1, $v0
	  li $v0, 16			# close file 
	  move $a0, $s1
	  syscall
	  addi $sp, $sp, 4		# return sp back to normal
	  move $v0, $t1
	  
	  lw $s0, 0($sp)			# restore registers
	  lw $s1, 4($sp)
	  lw $s2, 8($sp)
	  lw $s3, 12($sp)
	  addi $sp, $sp, 16
	  jr $ra
	
get_pocket:
	addi $sp, $sp, -16		# preserve save registers
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	move $s0, $a0			# save the base address into s0
	
	lb $s1, 2($s0)			# get the amount of pockets
	bge $a2, $s1, invalid_Dist_Player# check to see if invalid dist
	bltz $a2, invalid_Dist_Player
	add $s1, $s1, $s1		# s1 = s1 * 2 
	
	li $t0, 'B'			# set the B
	li $t1, 'T'			# set the T
	addi $t2, $s0, 6		# get address of board
	addi $t2, $t2, 2		# offset from top mancal
	bne $a1, $t0, check_T_Player	# check to see if a1 == B
	
	add $t3, $s1, $t2		# get last pocket of top row
	add $t3, $s1, $t3		# get last pocket of bot row
	addi $t3, $t3, -1 		# get to last mancala
	li $t4, 2			# multiply by 2 to get dist
	mul $a2, $a2, $t4		# turn dist into bytes
	sub $t3, $t3, $a2		# get ones element in dist
	lb $t4, 0($t3) 			# first digit
	addi $t4, $t4, -48		# int(t4)
	addi $t5, $t3, -1		# get tens digit
	lb $t5, 0($t5)			# get next digit
	addi $t5, $t5, -48		# int(t6)
	li $t6, 10			# tens value
	mul $t5, $t6, $t5		# turn it into tens
	add $t6, $t5, $t4		# t6 = t4 + t5
	move $v0, $t6			# set it to return value
	j return_Part2
	
	check_T_Player:
	  bne $a1, $t1, invalid_Dist_Player	# check to see if a1 == T
	  add $t3, $t2, $a2		# t3 = t2 + 2 * a2
	  add $t3, $t3, $a2
	  lb $t4, 0($t3)		# get the char at t3
	  addi $t4, $t4, -48		# int(t4)
	  li $t5, 10
	  mul $t4, $t5, $t4		# t4 = t4 * 10
	  addi $t3, $t3, 1		# get the next digit
	  lb $t6, 0($t3)		# t6 = next digit
	  addi $t6, $t6, -48		# int(t6)
	  add $t7, $t4, $t6		# get the int value of top row
	  move $v0, $t7			# return the value in top row
	  j return_Part2
	  
	invalid_Dist_Player:
	  li $v0, -1 			# return error for dist or player
	  
	return_Part2:
	lw $s0, 0($sp)			# restore registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	jr $ra
	
set_pocket:
	addi $sp, $sp, -24		# preserve save registers
	sw $s5, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	move $s0, $a0			# save the address of state
	lb $s1, 2($s0)			# get the amount of pockets
	
	bge $a2, $s1, invalid_Dist_Player_Pt3# check to see if invalid dist
	add $s1, $s1, $s1		# get pockets in bytes
	
	li $t0, 99			# check for 99 stones
	bgt $a3, $t0, invalid_Size_Pt3# branch to error stones > 99
	bltz $a3, invalid_Size_Pt3	# branch to error stones < 0
	
	li $t0, 'B'			# used check of players
	li $t1, 'T' 
	addi $t2, $s0, 6		# get address of board
	addi $t2, $t2, 2		# offset from top mancal
	bne $a1, $t0, check_T_Player_Pt3	# check to see if a1 == B
	
	add $t3, $s1, $t2		# get last pocket of top row
	add $t3, $s1, $t3		# get last pocket of bot row
	addi $t3, $t3, -1 		# get to last mancala
	li $t4, 2			# multiply by 2 to get dist
	mul $a2, $a2, $t4		# turn dist into bytes
	sub $t3, $t3, $a2		# get ones element in dist
	
	li $t4, 10			# divide by 10	
	div $a3, $t4			# get ones and tens to write 
	mfhi $t4			# get ones place
	addi $t4, $t4, 0x30		# turn into ascii
	sb $t4, 0($t3)			# write digit into ones place
	
	addi $t3, $t3, -1		# move to tens digit
	mflo $t4			# set remainder
	addi $t4, $t4, 0x30		# turn into ascii
	sb $t4, 0($t3)			# write digit into tens place
	move $v0, $a3			# return size
	j return_Part3
	
	check_T_Player_Pt3:
	  bne $a1, $t1, invalid_Dist_Player_Pt3	# check to see if a1 == T
	  add $t3, $t2, $a2		# t3 = t2 + 2 * a2
	  add $t3, $t3, $a2
	  
	  li $t4, 10			# divide by 10	
	  div $a3, $t4			# get ones and tens to write 
	  mflo $t4			# get ones place
	  addi $t4, $t4, 0x30		# turn into ascii
	  sb $t4, 0($t3)		# write digit into tens place
	 
	  addi $t3, $t3, 1		# move to ones digit
	  mfhi $t4			# set remainder
	  addi $t4, $t4, 0x30		# turn into ascii
	  sb $t4, 0($t3)		# write digit into tens place
	  move $v0, $a3			# return size
	  j return_Part3
	
	invalid_Dist_Player_Pt3:
	  li $v0, -1
	  j return_Part3
	  
	invalid_Size_Pt3:
	  li $v0, -2
	  j return_Part3
	  	
	return_Part3:
	lw $s0, 0($sp)			# restore registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	addi $sp, $sp, 24
	jr $ra
	
collect_stones:
	addi $sp, $sp, -24		# preserve save registers
	sw $s5, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	move $s0, $a0			# s0 = base address
	lb $s1, 2($s0)			# get the amount of pockets
	add $s1, $s1, $s1		# get the pockets in bytes
	
	blez $a2, invalid_Stones_Pt4	# invalid number stones
	
	li $t0, 'B'			# used to check player
	li $t1, 'T'		
	addi $t2, $s0, 6		# get address of board
	bne $a1, $t0, check_T_Player_Pt4# check to see if a1 == B
	
	add $t2, $s1, $t2		# add pockets to get last mancala
	add $t2, $s1, $t2		
	addi $t2, $t2, 2		# offset once more for mancala
	
	lb $t3, 0($t2)			# get first char
	addi $t3, $t3, -48		# int(t3)
	li $t4, 10
	mul $t3, $t3, $t4		# make it into tens
	
	lb $t4, 1($t2)			# get next char
	addi $t4, $t4, -48		# int(t4)
	add $t4, $t3, $t4		# add values 
	add $t4, $t4, $a2		# add with the stones
	move $v0, $t4			# set t4 to return type
	sb $t4, 0($s0)			# add it to bottom mancala
	
	li $t3, 10			
	div $t4, $t3			# divide by ten to get quotient/remainder 
	mflo $t4			# get quotient
	mfhi $t3			# get remainder
	addi $t4, $t4, 0x30 		# int(tens)
	addi $t3, $t3, 0x30		# int(ones)
	sb $t4, 0($t2)			# store tens place
	sb $t3, 1($t2)			# store ones place
	j return_Part4	
	
	check_T_Player_Pt4:
	  bne $a1, $t1, invalid_Player_Pt4 	# check to see if a1 == T
	  lb $t3, 0($t2)		# get first char
	  addi $t3, $t3, -48		# int(t3)
	  li $t4, 10
	  mul $t3, $t3, $t4		# make it into tens
	
	  lb $t4, 1($t2)		# get next char
	  addi $t4, $t4, -48		# int(t4)
	  add $t4, $t3, $t4		# add values 
	  add $t4, $t4, $a2		# add with the stones
	  move $v0, $t4			# set t4 to return type
	  sb $t4, 1($s0)		# add it to top mancala
	
	  li $t3, 10
	  div $t4, $t3			# divide by ten to get quotient/remainder 
	  mflo $t4			# get quotient
	  mfhi $t3			# get remainder
	  addi $t4, $t4, 0x30 		# int(tens)
	  addi $t3, $t3, 0x30		# int(ones)
	  sb $t4, 0($t2)		# store tens place
	  sb $t3, 1($t2)		# store ones place
	  j return_Part4

	invalid_Player_Pt4:
	  li $v0, -1
	  j return_Part4
	
	invalid_Stones_Pt4:	
	  li $v0, -2
	  j return_Part4
	  
	return_Part4:	
	lw $s0, 0($sp)			# restore registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	addi $sp, $sp, 24
  
	jr $ra
	
verify_move:
	addi $sp, $sp, -16		# preserve save registers
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	move $s0, $a0			# s0 = base address
	lb $s1, 2($s0)			# get the amount of pockets
	bge $a1, $s1, invalid_Pocket_Pt5# invalid pocket
	bltz $a1, invalid_Pocket_Pt5	# invalid pocket
	add $s1, $s1, $s1		# get the pockets in bytes
	li $t0, 99			# check 99 distance

	beq $a2, $t0, ninety_nine_Pt5 # jump to edge case
	
	move $s1, $a2			# save distance
	move $a2, $a1			# move argument of origin pocket to dist
	lb $a1, 5($s0)			# second argument for calling
	addi $sp, $sp, -4		# store the ra
	sw $ra, 0($sp)			# store ra on the stack
	
	jal get_pocket			# call get_pocket function
	
	move $t0, $v0			# get stones in pocket
	beqz $t0, zero_Pt5		# if 0 stones in pocket
	beqz $s1, dist_Zero_Or_Neq_Pt5	# if distance == 0
	bne $s1, $t0, dist_Zero_Or_Neq_Pt5# if dist != stones
	li $v0, 1
	j fix_register_Pt5			
	
	invalid_Pocket_Pt5:
	  li $v0, -1
	  j return_Part5
	
	ninety_nine_Pt5:
	  lb $t1, 4($s0)		# get moves
	  addi $t1, $t1, 1		# increment moves
	  sb $t1, 4($s0)		# store new increment moves count
	  lb $t1, 5($s0)		# get player turn
	  li $t2, 'T'			# top player
	  bne $t1, $t2, switchBot_Pt5
	    li $t2, 'B'
	    sb $t2, 5($s0)		# store Bottom player turn
	    j ninetynine_return_Pt5
	    
	  switchBot_Pt5:	
	  li $t2, 'T'
	  sb $t2, 5($s0)		# store Top player turn
	  
	  ninetynine_return_Pt5:
	  li $v0, 2
	  j return_Part5
	  
	zero_Pt5:
	  li $v0, 0
	  j fix_register_Pt5
	  
	dist_Zero_Or_Neq_Pt5:
	  li $v0, -2
	  j fix_register_Pt5
	
	fix_register_Pt5:
	lw $ra, 0($sp)			# store the return address
  	addi $sp, $sp, 4
  	
  	return_Part5:
	lw $s0, 0($sp)			# restore registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	jr  $ra
	
execute_move:
	addi $sp, $sp, -28		# preserve save registers
	sw $s6, 24($sp)
	sw $s5, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	move $s0, $a0			# s0 = a0 save base address
	move $s1, $a1			# s1 = a1 save the origin pocket
	lb $s2, 5($s0)			# s2 = current turn 
	
	li $t0, 'B'
	bne $s2, $t0, check_Player_T_Pt6# check which player it is to get stones
	lb $s3, 0($s0)			# s3 = bottom mancala stones
	j get_curr_Stones_Pt6
	
	check_Player_T_Pt6:
	lb $s3, 1($s0)			# s3 = bottom mancala stones
	
	get_curr_Stones_Pt6:
	move $t0, $s2			# turn changer 
	
	addi $sp, $sp, -4		# store the ra
	sw $ra, 0($sp)			# store ra on the stack
	
	move $a0, $s0			# first arg = base addr
	move $a1, $t0			# sec arg = curr player turn
	move $a2, $s1			# thrid arg = dist/pocket
	
	jal get_pocket 			# get stones in current pocket
	
	move $t0, $a1			# set current turn again 
	move $s4, $v0			# get stones of curr mancala
	
	move $a0, $s0			# first arg = base addr
	move $a1, $t0			# sec arg = curr player turn
	move $a2, $s1			# thrid arg = dist/pocket
	move $a3, $0			# fourth set to 0

	jal set_pocket			# set the current pocket to 0
	
	move $t0, $a1			# set current turn again
	
	loop_thru_Pockets_Pt6:		# loop thru the pcokets
	beq $s4, $0, return_values_Pt6	# end loop and jump to end
	  
	  beqz $s1, at_A_Mancala_Pt6	# pointer at mancala
	  
	    addi $s1, $s1, -1		# decrement count
	  
	    move $a0, $s0		# first arg = base addr
	    move $a1, $t0		# sec arg = curr player turn
	    move $a2, $s1		# thrid arg = dist/pocket
	
	    jal get_pocket 		# get stones in current pocket
	 
	    move $t0, $a1		# set current turn again 
	    move $s5, $v0		# get stones from current
	    addi $s5, $s5, 1		# add a stones to current
	  
	    move $a0, $s0		# first arg = base addr
	    move $a1, $t0		# sec arg = curr player turn
	    move $a2, $s1		# thrid arg = dist/pocket
	    move $a3, $s5		# fourth set to inc value
	  
	    jal set_pocket		# set the pocket to new value
	  
	    move $t0, $a1		# set current turn again
	    
	  j decrement_stones_Pt6
	  
	  at_A_Mancala_Pt6:
	  bne $t0, $s2 change_side_Pt6	# if the current player is on their side of the board
	  
	    move $a0, $s0		# arg1 = state
	    move $a1, $t0		# arg2 = player
	    li $a2, 1			# arg3 = increase
	    
	    jal collect_stones		# call collect stones
	    
	    move $t0, $a1		# set the turn player back to normal 
	    addi $s4, $s4, -1		# decrement stones
	    
	    bne $s4, $0, change_side_Pt6# check to see if it equals 0 to set v1
	    	li $v1, 2
	    
	    change_side_Pt6:
	    li $t1, 'B'
	    beq $t0, $t1, b_Side_Pt6
	    li $t0, 'B'			# change from T to B
	    lb $s1, 2($s0)		# get rows
	    
	    j loop_thru_Pockets_Pt6
	  
	    b_Side_Pt6:
	    li $t0, 'T'
	    lb $s1, 2($s0)		# get rows
	    
	    j loop_thru_Pockets_Pt6

	  decrement_stones_Pt6:
	  addi $s4, $s4, -1		# decrement the amount of stones
	  bne $s4, $0, loop_back_Pt6	# check to see if stones eq 0
	    li $t1, 1			
	    bne $s5, $t1, last_v1_Pt6	# if one stone in curr pocket 
	      li $v1, 1			# v1 = 1, in empty spot on board
	    j loop_back_Pt6
	    
	    last_v1_Pt6:		# if the stones were placed anywhere
	      li $v1, 0
	      
	  loop_back_Pt6:
	  j loop_thru_Pockets_Pt6
	
	return_values_Pt6:
	li $t1, 'T'
	bne $s2, $t1, b_Mancala_Value_Pt6
	lb $t1, 1($s0)			# get values in T mancala
	j v0_value_Pt6
	
	  b_Mancala_Value_Pt6:
	  lb $t1, 0($s0)		# get values in B mancala
	  
	v0_value_Pt6:
	sub $v0, $t1, $s3		# get values in current mancal
	
	lb $t8, 4($s0)			# increase the moves 
	addi $t8, $t8, 1
	sb $t8, 4($s0)
	
	li $t8, 'T'			# switch player turn
	bne $s2, $t8, switch_turn_Part6 # if curr_player != T
	li $s2, 'B'
	sb $s2, 5($s0)
	j return2_Part6
	
	switch_turn_Part6:
	li $s2, 'T'
	sb $s2, 5($s0)
	
	return2_Part6:
	lw $ra, 0($sp)			# bring back the $ra
	addi $sp, $sp, 4		# store the ra
	
	lw $s0, 0($sp)			# restore registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	addi $sp, $sp, 28
	
	jr $ra
	
steal:
	addi $sp, $sp, -28		# preserve save registers
	sw $s6, 24($sp)
	sw $s5, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	move $s0, $a0			# save base address
	move $s1, $a1			# save destination address
	
	lb $s2, 5($s0)			# get the turn
	li $t0, 'T'
	bne $s2, $t0, check_B_Pt7 	# if s2 == t0 then s2 = B
	  li $s2, 'B'
	  j get_dist_Pt7
	  
	check_B_Pt7: 			# else s2 = T
	li $s2, 'T'
	  
	get_dist_Pt7:
	lb $s3, 2($s0)			# get the amount of pockets
	addi $s3, $s3, -1		# last index pocket 
	
	sub $s3, $s3, $s1 
	lb $s4, 5($s0)			# get the other side of board
	
	first_method_Pt7:
	addi $sp, $sp, -4		# store return address
	sw $ra, 0($sp)			
	
	move $a0, $s0			# arg 1 = state
	move $a1, $s2			# arg 2 = player
	move $a2, $s1			# arg 3 = destination pocket
	
	jal get_pocket			# get the pocket from previous move
	
	move $s5, $v0			# t8 = return of get pocket
	
	move $a0, $s0			# arg 1 = state
	move $a1, $s2			# arg 2 = player
	move $a2, $s1			# arg 3 = destination pocket
	move $a3, $0			# set value to 0
	
	jal set_pocket			# set the pocket from previous move

	move $a0, $s0			# arg 1 = state
	move $a1, $s4			# arg 2 = player
	move $a2, $s3			# arg 3 = adjacent pocket
	
	jal get_pocket			# get the pocket from adjacent
	
	move $s6, $v0			# t8 = return of get pocket for adj
	
	move $a0, $s0			# arg 1 = state
	move $a1, $s4			# arg 2 = player
	move $a2, $s3			# arg 3 = adjacent pocket
	move $a3, $0			# set value to 0
	
	jal set_pocket			# set the pocket for adjacent pocket
	
	move $a0, $s0			# arg 1 = state
	move $a1, $s2			# arg 2 = prev player
	add $a2, $s5, $s6		# arg 3 = amount of stones to input
	
	jal collect_stones
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	lw $s0, 0($sp)			# restore registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	addi $sp, $sp, 28
	jr $ra
	
check_row:
	addi $sp, $sp, -16		# preserve save registers
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	move $s0, $a0 			# $s0 = $a0
	lb $s1, 2($s0)			# last index in either row
	addi $s1, $s1, -1
	li $s2, 'T'			# Top player goes first
	
	addi $sp, $sp, -4		# store return address
	sw $ra, 0($sp)
	
	loop_thru_pockets_Pt8:
	blt $s1, $0, which_empty_row_Pt8
	  
	  move $a0, $s0			# arg 1 = base addr
	  move $a1, $s2			# arg 2 = player, T
	  move $a2, $s1			# arg 3 = distance
	  
	  jal get_pocket
	  
	  bne $v0, $0, loop_thru_pockets2_Pt8
	   addi $s1, $s1, -1		# subtract the index	
	   j loop_thru_pockets_Pt8
	   
	loop_thru_pockets2_Pt8:
	lb $s1, 2($s0)			# last index in either row
	addi $s1, $s1, -1
	li $s2, 'B'			# Top player goes first
	
	loop_thru_pockets3_Pt8:
	blt $s1, $0, which_empty_row_Pt8
	  
	  move $a0, $s0			# arg 1 = base addr
	  move $a1, $s2			# arg 2 = player, B
	  move $a2, $s1			# arg 3 = distance
	  
	  jal get_pocket
	  
	  bne $v0, $0, no_empty_row_Pt8
	   addi $s1, $s1, -1		# subtract the index	
	   j loop_thru_pockets3_Pt8
	
	which_empty_row_Pt8:
	lb $s1, 2($s0)			# last index in either row
	addi $s1, $s1, -1
	li $t0, 'T'			# check Top player
	bne $s2, $t0, pick_other_Pt8	# if T == T then set s2 = B
	  li $s2, 'B'
	  j loop_thru_nonempty_Pt8
	  
	pick_other_Pt8:			# else set s2 = T
	li $s2, 'T'
	
	loop_thru_nonempty_Pt8:		# loop thru non empty row
	blt $s1, $0, return_v0_Part8
	  move $a0, $s0			# arg 1 = state
	  move $a1, $s2			# arg 2 = player
	  move $a2, $s1   		# arg 3 = distance
	  
	  jal get_pocket
	  
	  move $a0, $s0			# arg 1 = state
	  move $a1, $s2			# arg 2 = player
	  move $a2, $v0			# arg 3 = stones
	  
	  jal collect_stones
	  
	  move $a0, $s0			# arg 1 = state
	  move $a1, $s2			# arg 2 = player
	  move $a2, $s1			# arg 3 = stones
	  move $a3, $0			# arg 4 = replace with 0 stones
	  
	  jal set_pocket
	  
	  addi $s1, $s1, -1
	  j loop_thru_nonempty_Pt8
	  
	return_v0_Part8:
	li $v0, 1
	j return_v1_Part8
	
	no_empty_row_Pt8:
	li $v0, 0
	j return_v1_Part8
	
	return_v1_Part8:
	lb $t0, 1($s0)
	lb $t1, 0($s0)
	bne $t0, $t1, top_greater_Part8
	  li $v1, 0
	j return_Part8 
	  
	top_greater_Part8:
	blt $t0, $t1, bot_greater_Part8
	  li $v1, 2
	j return_Part8
	 
	bot_greater_Part8:
	li $v1, 1
	
	return_Part8:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	lw $s0, 0($sp)			# restore registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16

	jr $ra
	
load_moves:
	addi $sp, $sp, -16		# preserve save registers
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	move $s0, $a0	# newAddress = garbageAddress
	
	li $v0, 13	# get the file 
	move $a0, $a1	# openFile(Boardfile_name)
	li $a1, 0	# readFile
	syscall
	move $s1, $v0
	addi $sp, $sp, -4	# make room on stack
	
	bltz $s1, wrg_file_Pt9

	li $s2, 0		# number of \n
	
	loop_thru_row_col_Pt9:	# loop thru to get rows and cols
	li $t0, 2		# number of possible new lines
	beq $s2, $t0, moves_Pt9 # after 2 new lines we break
	
	  li $v0, 14
	  move $a0, $s1 	# file descriptor
	  move $a1, $sp		# the input buffer
	  li $a2, 1		# reads the first char
	  syscall
	  lb $t4, 0($sp)	# get first char from stack
	  
	  li $t2, 48		# ascii bounds for int 
	  li $t3, 57
	  
	  blt $t4, $t2,check_R1_Pt9# if int not in the bounds then branch
	  bgt $t4, $t3,check_R1_Pt9
	  
	  addi $t4, $t4, -48	# int($s3)
	  
	  bne $s2, $0, row_file_Pt9
	    move $s3, $t4
	    
	  row_file_Pt9:
	  li $v0, 14
	  move $a0, $s1 	# file descriptor
	  move $a1, $sp		# the input buffer
	  li $a2, 1		# reads the first char
	  syscall
	  lb $t1, 0($sp)	# get first char from stack
	  
	  li $t2, 48		# ascii bounds for int 
	  li $t3, 57
	  
	  blt $t1, $t2,check_R1_Pt9# if int not in the bounds then branch
	  bgt $t1, $t3,check_R1_Pt9

	  bne $s2, $0, row_file2_Pt9
	    addi $t1, $t1, -48	# int(t1)
	    li $t2, 10		# 10 for multiplication
	    mul $t4, $t4, $t2	# to turn s3 in tens
	    add $s3, $t4, $t1	# add to get total number 
	  
	  row_file2_Pt9:
	  li $v0, 14
	  move $a0, $s1 	# file descriptor
	  move $a1, $sp	        # the input buffer
	  li $a2, 1		# reads the first char
	  syscall
	  lb $t1, 0($sp)	# get first char from stack
	  
	check_R1_Pt9:
	li $t2, 13 
	bne $t1, $t2, check_N1_Pt9
	
	  li $v0, 14
	  move $a0, $s1 	# file descriptor
	  move $a1, $sp	        # the input buffer
	  li $a2, 1		# reads the first char
	  syscall
	  lb $t1, 0($sp)	# get first char from stack

	check_N1_Pt9:
	li $t2, 10 		# check if the current counter equals \n
	bne $t1, $t2, loop_thru_row_col_Pt9
	  addi $s2, $s2, 1	# increment the counter
	  j loop_thru_row_col_Pt9
	  
	moves_Pt9: 
	li $t0, 0		# 99 counter 
	li $s2, 0		# number of moves
	
	moves_loop_Pt9:
	beq $v0, $0, return_Part9# when we at the end of the file
	  
	  li $v0, 14
	  move $a0, $s1 	# file descriptor
	  move $a1, $sp		# the input buffer
	  li $a2, 1		# reads the first char
	  syscall
	  lb $t1, 0($sp)	# get first char
	  
	  li $t2, 13		# check for \r char
	  beq $t1, $t2, check_R2_Pt9
	  li $t2, 10		# check for \n char
	  beq $t1, $t2, check_N2_Pt9
	  
	  bne $t0, $s3, second_char_Pt9 # if num rows doesnt equal s
	    li $t0, 99		
	    sb $t0, 0($s0)	# store 99 
	    li $t0, 0		# set row moves to 0
	    addi $s2, $s2, 1
	    addi $s0, $s0, 1	# increment address
	  
	  second_char_Pt9:
	  li $t3, 48		# ascii bounds for int 
	  blt $t1, $t3,first_invalid_Pt9# if int not in the bounds then branch
	  li $t3, 57		# ascii bounds for int 
	  bgt $t1, $t3,first_invalid_Pt9

	  li $v0, 14
	  move $a0, $s1		# file descriptor
	  move $a1, $sp		# the input buffer
	  li $a2, 1		# reads the first char
	  syscall
	  lb $t2, 0($sp)	# get first char from stack
	  
	  li $t3, 48		# ascii bounds for int 
	  blt $t2, $t3,input100_Pt9# if int not in the bounds then branch
	  li $t3, 57		# ascii bounds for int 
	  bgt $t2, $t3,input100_Pt9
	  
	    addi $t1, $t1, -48	# int(t1)
	    addi $t2, $t2, -48	# int(t2)
	  
	    li $t3, 10		# get 10s value to multiply with t1
	    mul $t1, $t1, $t3	# multiply to get tens value t1
	    add $t1, $t1, $t2	# get combined number
	    
	    j increment_val_Pt9
	    
	  first_invalid_Pt9:
	  li $v0, 14
	  move $a0, $s1		# file descriptor
	  move $a1, $sp		# the input buffer
	  li $a2, 1		# reads the first char
	  syscall
	  
	  input100_Pt9:
	  li $t1, 100		# input 100 into invalid move
	  
	  increment_val_Pt9:
	  sb $t1, 0($s0)	# store byte from values t1
	  addi $s0, $s0, 1	# increment address
	  addi $s2, $s2, 1	# total moves increment
	  addi $t0, $t0, 1	# increment and check with row
	  
	  j moves_loop_Pt9
	  
	  check_R2_Pt9:
	  li $v0, 14
	  move $a0, $s1 	# file descriptor
	  move $a1, $sp	        # the input buffer
	  li $a2, 1		# reads the first char
	  syscall
	  lb $t1, 0($sp)	# get first char from stack
	  
	  check_N2_Pt9:
	  j moves_loop_Pt9	# return to beginning of loop
	  
	wrg_file_Pt9:
	li $s2, -1
	j return_Part9
	
	return_Part9:
	addi $sp, $sp, 4		# return sp back to normal
	li $v0, 16			# close file 
	move $a0, $s1
	syscall
	move $v0, $s2			# set return value for total moves
	lw $s0, 0($sp)			# restore registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	jr $ra

play_game:
	move $s0, $a2			# save address of state
	move $s1, $a3			# save address of moves
	lw $s2, 0($sp)			# get max number of moves
	addi $sp, $sp, 4		# reset the stack pointer
	move $s3, $a0			# save the moves name
	
	addi $sp, $sp, -4		# save return address on stack
	sw $ra, 0($sp)
	
	move $a0, $s0			# arg 1 = address to state, arg 2 = a1
	jal load_game			# loads game board		
	
	blez $v0, wrg_file_Pt10		# check if v0 is less equal to 0
	blez $v1, wrg_file_Pt10		# check if v1 is less equal to 0
	
	move $a0, $s1			# arg 1 = address to moves
	move $a1, $s3			# arg 2 = moves name file
	jal load_moves			# loads all the moves
	
	bltz $v0, wrg_file_Pt10		# check if file is invalid
	
	blez $s2, not_enough_movesPt10	# less than equal to 0
	
	move $s4, $v0			# get total number of moves
	move $s3, $s4			# copy total move from s3
	move $s7, $s2			# max moves saved 
	
	loop_thru_moves_Pt10:
	move $a0, $s0			# get address of state
	jal check_row 			# calls check row
	bnez $v0, row_is_empty_Pt10	# row is empty so we jump  

	beqz $s2, row_not_emptyPt10	# if number moves in file is done
	beqz $s4, row_not_emptyPt10	# total number of moves asked for is done
	
	  lb $s5, 0($s1)		# get a move from the list of moves 
	  li $t1, 99			# check if it equals 99 moves
	  beq $s5, $t1, invalid_99movePt10# current move 
	  li $t1, 100			# check if it equals 100 moves
	  beq $s5, $t1, invalid_100movePt10# current move 
	  
	    lb $a1, 5($s0)		# arg 2 = get the current player
	    move $a0, $s0		# arg 1 = game state
	    move $a2, $s5		# arg 3 = origin pocket
	    
	    jal get_pocket		# to get the distance
	    
	    move $s6, $v0		# save the number of stones
	    
	    move $a2, $v0		# arg 3 = gets the number of stones in pocket
	    move $a1, $s5		# arg 2 = pocket
	    move $a0, $s0		# arg 1 = game state
	    
	    jal verify_move
	    
	    beqz $v0, increment_loopPt10# loop back if invalid move
	    li $t1, 1
	    bne $v0, $t1, invalid_Pt10	# check to see if valid move
	    
	    move $a0, $s0		# arg 1 = state object
	    move $a1, $s5		# arg 2 = get a move from the list
	    jal execute_move		# call execute move
	    
	    li $t1, 2
	    beq $v1, $t1, move_again_Pt10# check to see if stone landed in mancala
	    li $t1, 1
	    beq $v1, $t1, stealpieces_Pt10 # check to see if stone landed in mancala
	    j increment_loopPt10
	    
	    move_again_Pt10:
	    lb $t1, 5($s0)		# get the player turn 
	    li $t2, 'T'			# check if player equals T
	    bne $t1, $t2, checkB_Pt10	# check to see if it equals
	      li $t2, 'B'		# switch back to B
	      sb $t2, 5($s0)
	      j increment_loopPt10
	    checkB_Pt10:
	    li $t2, 'T'			# switch back to T
	    sb $t2, 5($s0)
	    j increment_loopPt10
	    
	    stealpieces_Pt10:
	    lb $t1, 2($s0)		# get the num of pockets
	    addi $t2, $t1, -1		# get the last index row
	    sub $t3, $t2, $s5		# (last index pocket - origin pcoket)
	    add $t3, $t3, $s6 		# (# of stones + (last index pocket - origin pcoket)
	    add $t1, $t1, $t1
	    addi $t1, $t1, 1		# denom = num pockets * 2 + 1
	    div $t3, $t1		# numerator/denominator
	    mfhi $t4			# remainder 
	    
	    bgt $t4, $t2, increment_loopPt10# branch to increment if remadinder greater than last index
	      sub $t5, $t2, $t4		# get destination index
	      
	      move $a0, $s0		# arg 1 = game state
	      move $a1, $t5		# destination pocket
	      
	      jal steal			# call the steal function
	      
	      j increment_loopPt10	# loop to increment
	  
	    increment_loopPt10:
	    addi $s1, $s1, 1		# get next move to see what it is
	    addi $s2, $s2, -1		# decrease amount of max moves
	    addi $s4, $s4, -1		# decrement total moves in file
	    j loop_thru_moves_Pt10	# loop back to the top
	  
	  invalid_Pt10:
	  addi $s1, $s1, 1		# get next move to see what it is
	  addi $s4, $s4, -1		# subtract from total moves
	  j loop_thru_moves_Pt10	# loop back to the top
	  
	  invalid_99movePt10:		# 99 move 
	  move $a0, $s0			# arg 1 = get state address
	  li $a1, 0			# arg 2 = 0 pocket default
	  move $a2, $s5			# arg 3 = 99 stones
	  jal verify_move		# perform the verify 
	  addi $s4, $s4, -1		# subtract from total moves
	  addi $s2, $s2, -1		# decrease amount of max moves
	  addi $s1, $s1, 1		# get next move
	  j loop_thru_moves_Pt10	# loop back to the top
	  
	  invalid_100movePt10:
	  addi $s4, $s4, -1		# subtract from total moves
	  addi $s3, $s3, -1		# subtrack from the total char bc of invalid
	  addi $s1, $s1, 1		# get next move
	  j loop_thru_moves_Pt10	# loop back to the top
	  
	row_not_emptyPt10:
	li $v0, 0			# v0 = get values in v1 move to v0
	j max_row_Pt10
	
	row_is_empty_Pt10:
	move $v0, $v1			# v0 = get values in v1 move to v0
	j max_row_Pt10
	
	max_row_Pt10:
	bgt $s3, $s7, max_row_greaterPt10	# if s3 < s7 then v1 = s3
	  move $v1, $s3			# v1 = get the total amount of moves
	  j return_Part10
	max_row_greaterPt10:
	move $v1, $s7			# v1 = get the total amount of moves
	j return_Part10
	
	not_enough_movesPt10:
	li $v0, 0			# v0 = 0
	li $v1, 0			# v1 = 0
	j return_Part10
	
	wrg_file_Pt10:
	li $v0, -1
	li $v1, -1
	
	return_Part10:
	lw $ra, 0($sp)			# restore return address
	addi $sp, $sp, 4		# return stack pointer	
	jr  $ra
	
print_board:
	addi $sp, $sp, -16		# preserve save registers
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	move $s0, $a0			# save the first variable
	lb $s1, 2($s0)			# size of mancala
	
	lb $a0, 6($s0)			# print the first byte
	li $v0, 11			# char 
	syscall
	
	lb $a0, 7($s0)			# print the first byte
	li $v0, 11			# char 
	syscall
	
	li $a0, 10
	li $v0, 11			# print the new line
	syscall
	
	addi $s2, $s0, 8
	add $s2, $s2, $s1
	add $s2, $s2, $s1		# to get the first bit at s2
	add $s2, $s2, $s1
	add $s2, $s2, $s1		# to get the first bit at s2
	
	lb $a0, 0($s2)			# print the first byte
	li $v0, 11			# char 
	syscall
	
	lb $a0, 1($s2)			# print the first byte
	li $v0, 11			# char 
	syscall
	
	li $a0, 10
	li $v0, 11			# print the new line
	syscall
	
	addi $s3, $s0, 8		# get the start of board
	
	li $t0, 0			# counter for total loops
	loop_thru_rowsPt11:
	li $s2, 2			# max number of loops
	beq $t0, $s2, return_Part11	# if t0 == s2 branch out to the end
	  li $t1, 0			# sets inside counter 
	  loop_thru_charPt11:
	  beq $t1, $s1, print_newline_Pt11# print a new line
	    
	    lb $a0, 0($s3)		# print the first byte
	    li $v0, 11			# char 
	    syscall
	    
	    addi $s3, $s3, 1		# add to get next char
	    
	    lb $a0, 0($s3)		# print the first byte
	    li $v0, 11			# char 
	    syscall
	    
	    addi $s3, $s3, 1		# add to get next char
	    
	    addi $t1, $t1, 1		# increment counter
	    j loop_thru_charPt11
	  
	print_newline_Pt11:
	li $a0, 10
	li $v0, 11			# print the new line
	syscall
	addi $t0, $t0, 1		# add outside loop counter
	j loop_thru_rowsPt11
	
	return_Part11:
	lw $s0, 0($sp)			# restore registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	jr $ra
	
write_board:
	addi $sp, $sp, -20		# preserve 
	sw $s6, 16($sp)			
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	move $s0, $a0			# save the first variable
	lb $s1, 2($s0)			# size of mancala
	addi $s2, $s0, 6		# first index of byte in top mancala
	addi $s3, $s0, 8
	add $s3, $s3, $s1
	add $s3, $s3, $s1
	add $s3, $s3, $s1
	add $s3, $s3, $s1		# get the the bottom mancala
	
	addi $sp, $sp, -10		# make room on the stack
	li $t0, 't'
	sb $t0, 9($sp)			# store t on stack
	li $t0, 'x'
	sb $t0, 8($sp)			# store x on stack
	li $t0, 't'
	sb $t0, 7($sp)			# store t on stack
	li $t0, '.'
	sb $t0, 6($sp)			# store . on stack
	li $t0, 't'
	sb $t0, 5($sp)			# store t on stack
	li $t0, 'u'
	sb $t0, 4($sp)			# store u on stack
	li $t0, 'p'
	sb $t0, 3($sp)			# store p on stack
	li $t0, 't'
	sb $t0, 2($sp)			# store t on stack
	li $t0, 'u'
	sb $t0, 1($sp)			# store u on stack
	li $t0, 'o'
	sb $t0, 0($sp)			# store o on stack
	
	li $v0, 13			# write to file
	move $a0, $sp
	li $a1, 1			# open file for writing
	li $a2, 0
	syscall				# write to file
	move $s6, $v0			# save the file descriptor
	
	bltz $v0, return_v1Pt12		# $v0 == -1
	
	move $a0, $s6			# arg 1 = description 
	move $a1, $s2			# arg 2 = first index
	li $a2, 1			# arg 3 = read 1 char
	li $v0, 15			
	syscall
	
	bltz $v0, return_v1Pt12		# $v0 == -1
	addi $s2, $s2, 1
	
	move $a0, $s6			# arg 1 = description 
	move $a1, $s2			# arg 2 = first index
	li $a2, 1			# arg 3 = read 1 char
	li $v0, 15			
	syscall
	
	bltz $v0, return_v1Pt12		# $v0 == -1
	addi $s2, $s2, 1
	
	li $t2, 10
	addi $sp, $sp, -1
	sb $t2, 0($sp)
	move $a0, $s6			# arg 1 = description 
	move $a1, $sp			# arg 2 = first index
	li $a2, 1			# arg 3 = read 1 char
	li $v0, 15			
	syscall
	addi $sp, $sp, 1
	
	move $a0, $s6			# arg 1 = description 
	move $a1, $s3			# arg 2 = first index
	li $a2, 1			# arg 3 = read 1 char
	li $v0, 15			
	syscall
	
	bltz $v0, return_v1Pt12		# $v0 == -1
	addi $s3, $s3, 1
	
	move $a0, $s6			# arg 1 = description 
	move $a1, $s3			# arg 2 = first index
	li $a2, 1			# arg 3 = read 1 char
	li $v0, 15			
	syscall
	
	bltz $v0, return_v1Pt12		# $v0 == -1
	
	li $t2, 10
	addi $sp, $sp, -1
	sb $t2, 0($sp)
	move $a0, $s6			# arg 1 = description 
	move $a1, $sp			# arg 2 = first index
	li $a2, 1			# arg 3 = read 1 char
	li $v0, 15			
	syscall
	addi $sp, $sp, 1
	
	li $t0, 0			# counter for total loops
	loop_thru_rowsPt12:
	li $s3, 2			# max number of loops
	beq $t0, $s3, return_v0Pt12	# if t0 == s2 branch out to the end
	  li $t1, 0			# sets inside counter 
	  loop_thru_charPt12:
	  beq $t1, $s1, print_newline_Pt12# print a new line
	    
	    move $a0, $s6		# arg 1 = description 
	    move $a1, $s2		# arg 2 = first index
	    li $a2, 1			# arg 3 = read 1 char
	    li $v0, 15			
	    syscall
	    
	    bltz $v0, return_v1Pt12		# $v0 == -1
	    addi $s2, $s2, 1
	    
	    move $a0, $s6			# arg 1 = description 
	    move $a1, $s2			# arg 2 = first index
	    li $a2, 1			# arg 3 = read 1 char
	    li $v0, 15			
	    syscall
	    
	    bltz $v0, return_v1Pt12		# $v0 == -1
	    
	    addi $s2, $s2, 1
	    addi $t1, $t1, 1		# increment counter
	    j loop_thru_charPt12
	  
	print_newline_Pt12:
	li $t2, 10
	addi $sp, $sp, -1
	sb $t2, 0($sp)
	move $a0, $s6			# arg 1 = description 
	move $a1, $sp			# arg 2 = first index
	li $a2, 1			# arg 3 = read 1 char
	li $v0, 15			
	syscall
	addi $sp, $sp, 1		# increment by 1
	addi $t0, $t0, 1
	j loop_thru_rowsPt12
	
	return_v0Pt12:
	li $t4, 1			# save the valid
	j return_Part12
	
	return_v1Pt12:
	li $t4, -1			# save the invalid 
	j return_Part12
	
	return_Part12:
	move $a0, $s6
	li $v0, 16
	syscall
	addi $sp, $sp, 10
	
	move $v0, $t4
	
	lw $s0, 0($sp)			# restore registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s6, 16($sp)
	addi $sp, $sp, 20
	jr $ra
	
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
