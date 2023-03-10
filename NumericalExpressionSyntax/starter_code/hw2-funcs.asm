############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

############################## Do not .include any files! #############################

.text
# s0 = base of val_stack, s1 = base of op_stack, s2 = top of val_stack
# s3 = top of op_stack, t0 = current character, t1 = character,
# t2 = total digit value
eval: 
	# sets the stacks and pointers up
	la $s0, val_stack 	# address for the val_stack
	addi $s0, $s0, -4	# set the size to empty
	la $s1, op_stack  	# address for the op_stack
	addi $s1, $s1, 2004     # offset address for op_stack
	li $s2, -4 		# top of the val_stack
	li $s3, -4 		# top of the op_stack
	addi $sp, $sp, -4
  	sw $ra, 0($sp)
  	
  	move $s5, $a0		# checks to see if the string is not an empty string
	lbu $s4, 0($s5)
	bne $s4, $0, loop_string	# char == null character
	
	li $v0, 4 			# otherwise terminate
  	la $a0, ParseError		# throw error for illformed exp
   	syscall 
    	li $v0, 10			# terminate program
    	syscall  
	
	# this will loop through the string and get the characters
	# $s4 = next character
	# loop_string block
	loop_string:
	lbu $s4, 0($s5)
	beq $s4, $0, end_stringloop
	
		# open_parantheses block
		open_parantheses: 	# checks to see if its open parantheses
		li $t1, '('
		bne $s4, $t1, digit
		move $a0, $s4		# parameter: a0 = '('
		move $a1, $s3 		# parameter: a1 = top of the stack
		move $a2, $s1		# parameter: a2 = base address
		jal stack_push
		addi $v0, $v0, -4
		move $s3, $v0		# set the top to new value
		j increment_loop
	
		# digit block
		digit:			# checks to see if its a digit
		move $a0, $s4 		# parameter a0 = digit
		jal is_digit		# token[i].isdigit()
		move $t0, $a0		# copies contents back into t0
		beq $v0, $0, closed_parantheses 	# elif to closed_parantheses
		li $s6, 0		# value = 0
		
		  # digitloop block
		  digitloop:			# while(i < len(tokens) and tokens[i].isdigit())
		  lbu $s4, 0($s5)		# i += 1
		  li $t9, '('
		  beq $s4, $t9, wrong_input
		  move $a0, $s4 		# parameter a0 = digit
		  jal is_digit
		  bne $v0, $0, checkdigit 	# tokens[i] 
		  move $a0, $s6			# a0 parameter for stackpush
		  move $a1, $s2			# a1 parameter for stackpush
		  move $a2, $s0			# a2 parameter for stackpush
		  jal stack_push
		  addi $v0, $v0, -4		# redecuing the pointer
		  move $s2, $v0			# setting pointer to new top
		  j loop_string
			
		  # checkdigit 
		  checkdigit:
		  beq $s4, $0, end_stringloop	# checks token if null
		  addi $t2, $s4, -48		# int(tokens[i])
		  li $t3, 10
		  mul $s6, $s6, $t3		# val = (val * 10)
		  add $s6, $s6, $t2		# val = val + tokens[i]
		  addi $s5, $s5, 1		# increment the loop
		  j digitloop
			
		# closed_parantheses block
		closed_parantheses:
		li $t1, ')'			# tokens[i] == ')'
		bne $s4, $t1, operators_block	# elif tokens[i] == ')'
		
		  # while_eval block
		  while_eval:			# while len(ops) != 0 and ops[-1] != '('
		  move $a0, $s3			# parameter: a0 to check empty
		  jal is_stack_empty		# check to see if stack empty
		  bne $v0, $0, pop_op		# len(ops) != 0
		  move $a0, $s3
		  move $a1, $s1		
		  jal stack_peek		# checks next element
		  move $t3, $v0			# saves next element to check
		  li $t2, '('
		  beq $t3, $t2, pop_op		# ops[fist input] != '('
		    
		    move $a0, $s2 		# argument for top value
		    move $a1, $s0 		# argument for base value
		    jal stack_pop
		    move $s2, $v0		# s2 = new top of the stack
		    move $t4, $v1 		# val2 = values.pop()
		    
		    move $a0, $s2		# argument for top value
		    move $a1, $s0 		# argument for base value
		    jal stack_pop
		    move $s2, $v0		# s2 = new top of the stack
		    move $t5, $v1 		# val2 = values.pop()
		    
		    move $a0, $s3		# argument for top op
		    move $a1, $s1 		# argument for base op
		    jal stack_pop
		    move $s3, $v0		# s2 = new top of the stack
		    move $t6, $v1 		# val2 = values.pop()
		    
		    move $a0, $t5
		    move $a1, $t6
		    move $a2, $t4		
		    jal apply_bop		# applyOp(val1, val2, op)
		    
		    move $a0, $v0		
		    move $a1, $s2
		    move $a2, $s0
		    jal stack_push		# values.append(applyOp(val1, val2, op)
		    addi $v0, $v0, -4		# adjust the top of the val_stack
		    move $s2, $v0
		    
		    j while_eval		# loop back to top of loop
		    
		    # pop_op block
		    pop_op:
		    move $a0, $s3
		    move $a1, $s1
		    jal stack_pop		# ops.pop()
		    move $s3, $v0		# sets the top op stack
		    j increment_loop 
		  
		# operators_block		
		operators_block:
		move $a0, $s4			
		jal valid_ops			# if validOps(char):
		beq $v0, $0, illegal_element	# validOps(char) == 0 then jump end program
		move $a0, $s3
		move $a1, $s1
		jal stack_peek			# first element from ops stack to check
		move $t1, $v0			# moves peeked value into checking register
		li $t0, '('
		beq $t1, $t0, push_op		# checks for open parantheses
		
		move $a0, $s3
		jal is_stack_empty	
		bne $v0, $0, push_op		# is list empty?
		move $a0, $s3			# parameter: top of the op stack
		move $a1, $s1			# parameter: base address
		jal stack_peek			# ops[-1]
		move $a0, $v0			# parameter: stack_peek
		jal op_precedence		# precedence: top of op stack
		move $t8, $v0                   # precedence(ops[-1])
		move $a0, $s4			# parameter: current element
		jal op_precedence		# precedence: current element
		move $t9, $v0			# precedence(tokens[i]))
		blt $t8, $t9, push_op		# precedence(ops[-1])>=precedence(tokens[i]))
			
		  move $a0, $s2 		# argument for top value
		  move $a1, $s0 		# argument for base value
		  jal stack_pop
		  move $s2, $v0			# s2 = new top of the stack
		  move $t4, $v1 		# val2 = values.pop()
		    
		  move $a0, $s2			# argument for top value
		  move $a1, $s0 		# argument for base value
		  jal stack_pop
		  move $s2, $v0			# s2 = new top of the stack
		  move $t5, $v1 		# val2 = values.pop()
		    
		  move $a0, $s3			# argument for top op
		  move $a1, $s1 		# argument for base op
		  jal stack_pop
		  move $s3, $v0			# s2 = new top of the stack
		  move $t6, $v1 		# val2 = values.pop()
		  
		  move $a0, $t5
		  move $a1, $t6
		  move $a2, $t4		
		  jal apply_bop			# applyOp(val1, val2, op)
		
		  move $a0, $v0		
		  move $a1, $s2
		  move $a2, $s0
		  jal stack_push		# values.append(applyOp(val1, val2, op)
		  addi $v0, $v0, -4		# adjust the top of the val_stack
		  move $s2, $v0

		  j operators_block		# loop back to top of loop
		  
		  # push_op block
		  push_op:
		  move $a0, $s4			# argument: value
		  move $a1, $s3			# argument: top op address
		  move $a2, $s1			# argument: base op address
		  jal stack_push		# ops.append(tokens[i])
		  addi $v0, $v0, -4		
		  move $s3, $v0			# top stack set with $v0
		  j increment_loop
		
		illegal_element:
		  li $v0, 4 			# otherwise terminate
   		  la $a0, BadToken		# throw error for identifialble ops
   		  syscall 
    		  li $v0, 10			# terminate program
    		  syscall  
		
		# increment_loop
		increment_loop:
		addi $s5, $s5, 1
		j loop_string
		

	end_stringloop: 			# end the loop and start anew
	move $a0, $s3				# argument: top of the stack
	jal is_stack_empty			# len(ops) != 0
	bne $v0, $0, print_value
	
	  move $a0, $s2 			# argument for top value
	  move $a1, $s0 			# argument for base value
	  jal stack_pop
	  move $s2, $v0				# s2 = new top of the stack
	  move $t4, $v1 			# val2 = values.pop()
	    
	  move $a0, $s2				# argument for top value
	  move $a1, $s0 			# argument for base value
	  jal stack_pop
	  move $s2, $v0				# s2 = new top of the stack
	  move $t5, $v1 			# val2 = values.pop()
	    
	  move $a0, $s3				# argument for top op
	  move $a1, $s1 			# argument for base op
	  jal stack_pop
	  move $s3, $v0				# s2 = new top of the stack
	  move $t6, $v1 			# val2 = values.pop()
		 
		 
	  move $a0, $t5
	  move $a1, $t6
	  move $a2, $t4		
	  jal apply_bop				# applyOp(val1, val2, op)
		
	  move $a0, $v0		
	  move $a1, $s2
	  move $a2, $s0
	  jal stack_push			# values.append(applyOp(val1, val2, op)
	  addi $v0, $v0, -4			# adjust the top of the val_stack
	  move $s2, $v0
	  
	  j end_stringloop
	
	wrong_input:
	li $v0, 4 		# otherwise terminate
   	la $a0, ParseError
        syscall 
    	li $v0, 10
    	syscall
	
	print_value:
	move $a0, $s2
	move $a1, $s0
	bgtz $s2, wrong_input
	jal stack_pop
	move $a0, $v1
	li $v0, 1
	syscall
	
	lw $ra, 0($sp)
  	addi $sp, $sp, 4
	
  	jr $ra


# function goes through each value and checks if its equal 
is_digit: 
	# checks to see if the number is in range for ascii
	addi $t0, $a0, -57
  	blez $t0, digitGreater  
  	j digitFalse
  	
  	digitGreater:
  	li $t1, -9
  	bge $t0, $t1, digitTrue
  	j digitFalse
  
  	digitTrue:
  	li $v0, 1
  	j returndigit
  
  	digitFalse:
  	li $v0, 0
  	j returndigit
  
  	returndigit:
  	jr $ra

# pushes the values or operators on either one of the
# stacks and throws an error if the size is reached
# a0 = value, a1 = top, a2 = base address
stack_push:
	addi $a1, $a1, 4	# move to the next index
	add $t0, $a1, $a2	# check the size
	li $t1, 2000
	bne $a1, $t1, push_return
	li $v0, 4 		# otherwise terminate
   	la $a0, ParseError
   	syscall 
    	li $v0, 10
    	syscall 
	
	# push value into stack and increase the pointer to the
	# next value in the stack 
	push_return:
	sw $a0, 0($t0)
	addi $v0, $a1, 4
	jr $ra

# show previous value in the stack without revmoving
stack_peek:
	add $t0, $a0, $a1
	lw $v0, 0($t0)
        jr $ra

# showing previous value and removing it by 
# decreasing the pointer to the penultimate value
stack_pop:
	add $t0, $a0, $a1
	bge $a0, $0, wellformed
	li $v0, 4 		# otherwise terminate
   	la $a0, ParseError
        syscall 
    	li $v0, 10
    	syscall
	
	wellformed:
	lw $v1, 0($t0)
	addi $a0, $a0, -4
	move $v0, $a0
	jr $ra

# checks to see if the stack is empty
is_stack_empty:
	bltz $a0, stack_empty
	li $v0, 0
	j return_stackempty
	
	stack_empty:
	li $v0, 1
	
	return_stackempty:
  	jr $ra


# Function: checks to see if this is a 
# valid operator
valid_ops:
  	li $t0, '+'
  	beq $t0, $a0, opsTrue
  	li $t0, '-'
  	beq $t0, $a0, opsTrue
  	li $t0, '*'
  	beq $t0, $a0, opsTrue
  	li $t0, '/'
  	beq $t0, $a0, opsTrue
  	j opsFalse
  
  	opsTrue:
    	li $v0, 1
    	j returnOps
  
  	opsFalse:
    	li $v0, 0
    	j returnOps
   
  	returnOps:
  	jr $ra


# Check to see the precedence of each operator
op_precedence: 
  	addi $sp, $sp, -4
  	sw $ra, 0($sp) 			# save the adress of ra on the stack
  	jal valid_ops
  	move $t0, $v0
  	bne $t0, $0, precedenceTrue 	# if statement that checks if it is an ops
    	  li $v0, 4 			# otherwise terminate
   	  la $a0, BadToken
   	  syscall 
    	  li $v0, 10
    	  syscall 
  
  	precedenceTrue: # gives the value to the precedence
  	li $t0, '+'
  	beq $a0, $t0, firstPrecedence
  	li $t0, '-'
  	beq $a0, $t0, firstPrecedence
  	li $t0, '*'
  	beq $a0, $t0, secondPrecedence
  	li $t0, '/'
  	beq $a0, $t0, secondPrecedence
  	j exitPrecedence
  
  	firstPrecedence: 		# sets the precedence of +/- value
  	li $v0, 1
  	j exitPrecedence
  
 	secondPrecedence: 		# sets the precedence of *// value
  	li $v0, 2
  	j exitPrecedence
  
  	exitPrecedence:
  	lw $ra, 0($sp)
  	addi $sp, $sp, 4
  	jr $ra
  
# this operation gives you the precedence of each 
# operator so that when applying it you know 
# it which order it was used
apply_bop:
    	li $t0,'+'
    	bne $a1, $t0, subbinOps
    	add $v0, $a0, $a2
    	j returnBinOps
    	
    	subbinOps:
    	li $t0,'-'
    	bne $a1, $t0,mulbinOps
    	sub $v0, $a0, $a2
    	j returnBinOps
    	
    	mulbinOps:
    	li $t0,'*'
    	bne $a1, $t0,divbinOps
    	mul $v0, $a0, $a2
    	j returnBinOps
    	
    	divbinOps:
    	li $t0,'/'
    	# bne $a1, $t0, operatorError
    	beq $a2, $0, binErrorMsg
    	div $a0, $a2
    	mflo $v0			# put quotient into one register
    	mfhi $t0			# put remainder 
    	
    	bgtz $a0, other_condition
    	blt $a2, $0, other_condition
    	bne $t0, $0, floor_div
    	
    	other_condition:
    	bltz $a0, returnBinOps
    	bgt $a2, $0, returnBinOps
    	bne $t0, $0, floor_div
    	
    	j returnBinOps
    	
    	floor_div:
    	addi $v0, $v0, -1
    	j returnBinOps
    	
    	binErrorMsg:
    	li $v0, 4 		# otherwise terminate
   	la $a0, BadToken
        syscall 
    	li $v0, 10
    	syscall
    	
    	returnBinOps:
  	jr $ra
  	
	  
	  
	  
	
	
	  
	
	
		
	
	

