############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:


create_term:
	move $t0, $a0			# save coefficient
	move $t1, $a1			# save the degree
		
	beqz $t0, wrong_arg_Pt1
	bltz $t1, wrong_arg_Pt1
	
	li $a0, 12				# get a space of term
	li $v0, 9
	syscall					# call upon the stack
	
	sw $t0, 0($v0)			# load coefficient
	sw $t1, 4($v0)			# load degree
	sw $0, 8($v0)			# load initial null address
	
	j return_Part1	
	
	wrong_arg_Pt1:
	li $v0, -1
	
	return_Part1:
	jr $ra
	
init_polynomial:
	addi $sp, $sp, -4		# save a register
	sw $s0, 0($sp)			# store s0 register
	
	move $s0, $a0 			# save the pointer
	
	addi $sp, $sp, -4		# save the return address
	sw $ra, 0($sp)		
	
	lw $a0, 0($a1)			# get value within pair[0]
	lw $a1, 4($a1)			# get value within pair[1]
	jal create_term			# creates the term
	
	li $t0, -1
	beq $v0, $t0, return_Part2
	
	sw $v0, 0($s0)			# store the address into pointer
	li $v0, 1
	
	return_Part2:
	lw $ra, 0($sp)			# restore return address
	addi $sp, $sp, 4
	
	lw $s0, 0($sp)			# restore s0 register
	addi $sp, $sp, 4		
	jr $ra
	
add_N_terms_to_polynomial:
	addi $sp, $sp, -24		# preserve s registers
	sw $s4, 20($sp)
	sw $s3, 16($sp)
	sw $s2, 12($sp)
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	
	move $s0, $a0			# save the first argument: pointer
	lw $t0, 0($s0)			# check to see if the pointer is 0
	beqz $t0, N_zero_condtion_Pt3
	move $s1, $a1			# save the second argument: terms
	move $s2, $a2			# save the third argument: number terms to add
	beqz $s2, N_zero_condtion_Pt3	# return value if $s2, 
	
	move $a0, $s1			# sort through the exponents
	jal helper_sort_exponents
	
	lw $t0, 0($s0)			# get the address of the list of the pointer
	move $s3, $t0			# save the address of the head
	
	lw $t1, 4($t0)			# get the exponent of the head
	lw $t2, 4($s1)			# get the exponent of first term
	
	ble $t2, $t1, continue1_Pt3
		lw $t3, 0($t0)		# the coefficient of the head
		lw $t4, 0($s1)		# coefficient of first term
		
		sw $t4, 0($t0)		# swap the values from linked list and terms
		sw $t2, 4($t0)
		sw $t3, 0($s1)
		sw $t1, 4($s1) 
		
		move $a0, $s1		# restore order in the array terms
		jal helper_sort_exponents
	
	continue1_Pt3:
	li $s4, 0				# number moves made 
	
	loop_thru_terms_Pt3:
	beq $s4, $s2, return_Part3
		lw $a0, 0($s1)		# get current coefficient in terms array
		lw $a1, 4($s1)		# get current exponent in terms array
		
		bnez $a0, continue_thru_terms_Pt3 
		li $t0, -1
		beq $a1, $t0, return_Part3
	
		continue_thru_terms_Pt3:
		lw $t0, 4($s3)		# get exponent at pointer
		beq $a1, $t0, increment_loop_Pt3
		
		jal create_term		# create a new term
		
		bltz $v0, increment_loop_Pt3
		sw $v0, 8($s3)		# set the link from one node to another
		move $s3, $v0 		# set the return value to pointer
		addi $s4, $s4, 1	# increment num terms added
		
		increment_loop_Pt3:
		addi $s1, $s1, 8	# get next term in array of terms
		j loop_thru_terms_Pt3
		
	N_zero_condtion_Pt3:
	li $s4, 0
	
	return_Part3:
	move $v0, $s4
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addi $sp, $sp, 24		# restore s registers
	jr $ra
	
helper_sort_exponents:
	move $t0, $a0			# save the address to array
	move $t9, $t0			# save original address
	
	lw $t1, 4($t0)			# check to see if its -1
	bltz $t1, return_helper1
	
	addi $t0, $t0, 8		# get next term 
	
	helper_loop_exp:		# for loop that runs the exponents
	lw $t1, 4($t0)			# get the exponent
	li $t8, -1
	bne $t1, $t8, continue_loop_exp# check to see if it equals -1
	lw $t8, 0($t0)			# get the coefficient
	beqz $t8, return_helper1
	
	continue_loop_exp:
		move $t2, $t0		# save address
		helper_inner_loop_exp:
		addi $t3, $t2, -8	# get the previous exponent address
		lw $t4, 4($t3)		# get the previous exponent
		ble $t1, $t4, next_exponent_helper
		blt $t3, $t9, next_exponent_helper	# check to see if reach beg of array
			lw $t5, 0($t3)	# get the previous coefficient
			lw $t6, 0($t2)	# get current coefficient
			
			sw $t6, 0($t3)	# swap
			sw $t1, 4($t3)  
			
			sw $t5, 0($t2)  
			sw $t4, 4($t2)
			
			move $t2, $t3	# copy the address of t3 to t2
			
		j helper_inner_loop_exp
			
	next_exponent_helper:
	addi $t0, $t0, 8		# get next address of next exponent
	j helper_loop_exp

	return_helper1:
	jr $ra
	
update_N_terms_in_polynomial:
	addi $sp, $sp, -24		# preserve s registers
	sw $s4, 20($sp)
	sw $s3, 16($sp)
	sw $s2, 12($sp)
	sw $s1, 8($sp)
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	
	move $s0, $a0			# save first argument: pointer
	beqz $s0, N_zero_condtion_Pt4 # if the pointer == 0 then return error
	move $s1, $a1			# save second argument: new_terms
	move $s2, $a2			# save third argument: N
	beqz $s2, N_zero_condtion_Pt4	# return value if $s2 == 0
	
	lw $s3, 0($s0)			# save register: the pointer in linked list
	move $t7, $s3			# previous node 
	li $s4, 0				# save register: the counter for all the changes made
	
	loop_thru_exponents_Pt4:
	lw $t0, 8($t7)
	beqz $t0, return_Part4	# if the return address is 0
	beq $s4, $s2, return_Part4 # if changes == N then return
	
		li $t1, 0			# counter number of changes
		lw $t2, 4($s3)		# get the current exponent
		move $t3, $s1		# get the array for terms
		
		loop_thru_terms_Pt4:
		lw $t4,0($t3)		# get current coefficient
		lw $t5,4($t3)		# get exponent
		bnez $t4, continue_thru_terms_Pt4
		li $t6, -1
		beq $t5, $t6, exit_loop_terms_Pt4  
		
			continue_thru_terms_Pt4:
			bne $t5, $t2, increment_terms_loop_Pt4	# checking to see if the exponents equal
			beqz $t4, increment_terms_loop_Pt4		# if the coefficient == 0
				sw $t4, 0($s3)						# store new coefficient into array
				addi $t1, $t1, 1					# increment total changes
		
			increment_terms_loop_Pt4:
			addi $t3, $t3, 8						# get next term in array
			j loop_thru_terms_Pt4
			
		exit_loop_terms_Pt4:
		beqz $t1, increment_exponent_Pt4
			addi $s4, $s4, 1						# increment the amount of updated terms
		
		increment_exponent_Pt4:
		move $t7, $s3								# set previous node 
		lw $s3, 8($s3)								# move to next node in linked list
		j loop_thru_exponents_Pt4					# loop back to top of loop
		
	N_zero_condtion_Pt4:
	li $s4, 0
	
	return_Part4:
	move $v0, $s4						# set the return value
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addi $sp, $sp, 24					# restore s registers
	jr $ra
	
get_Nth_term:
	addi $sp, $sp, -16					# preserve s registers
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	
	move $s0, $a0						# save argument 1: pointer
	beqz $s0, error_Pt5					# if pointer == 0 the return error
	move $s1, $a1						# save argument 2: which term we are retrieving
	
	lw $s2, 0($s0)						# current pointer
	lw $s3, 0($s0)						# previous pointer
	
	li $t1, 1							# counter through the loop
	loop_thru_terms_Pt5:
	lw $t0, 8($s3)						# check to see previous pointer link
	beqz $t0, error_Pt5
		bne $t1, $s1, increment_loop_Pt5 
		lw $v0, 4($s2)					# v0 = get the exponent
		lw $v1, 0($s2)					# v1 = get the coefficient
		j return_Part5
		
	increment_loop_Pt5:
	addi $t1, $t1, 1					# incrementing the amount of nodes visited
	move $s3, $s2						# set previous pointer
	lw $s2, 8($s2)						# get next node
	j loop_thru_terms_Pt5
	
	error_Pt5:
	li $v0, -1
	li $v1, 0
	
	return_Part5:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16					# restore s registers
	jr $ra
	
remove_Nth_term:
	addi $sp, $sp, -20					# preserve s register
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	move $s0, $a0						# preserve argument 1: pointer
	beqz $s0, error_Pt6					# if pointer == 0 then return error
	move $s1, $a1						# preserve arguent 2: Nth remove 
	
	lw $s2, 0($s0)						# s register = current pointer
	lw $s3, 0($s0)						# s register = previous pointer
	lw $s4, 8($s2)						# s register = next pointer
	
	li $t0, 1							# check to see if N equals the 1
	bne $s1, $t0, continue1_Pt6
		sw $0, 8($s2)					# we will set the link of head to 0
		lw $v0, 4($s2)					# v0 = exponent of head
		lw $v1, 0($s2)					# v1 = coefficient of head
		sw $s4, 0($s0)					# get address of next pointer and store into pointer
		j return_Part6
		
	continue1_Pt6:
	li $t0, 2							# counter for loop
	move $s2, $s4						# set current to address at next
	bnez $s4, reg_increment_pt6			# if $s4 == 0 j to increment_counter
		j loop_thru_terms_Pt6
	reg_increment_pt6:
	lw $s4, 8($s4)					# get address of next node

	loop_thru_terms_Pt6:				
	lw $t1, 8($s3)						# check to see if previous pointer has address 0
	beqz $t1, error_Pt6					# if the return address is 0
		
		bne $t0, $s1, increment_loop_Pt6# check to see if Nth number reached
			lw $v0, 4($s2)				# v0 = exponent
			lw $v1, 0($s2)				# v1 = coefficient
			sw $0, 8($s2)				# set next address of current to 0
			sw $s4, 8($s3)				# set address of previous to address of next
			j return_Part6 
		
		increment_loop_Pt6:
		move $s3, $s2					# set previous pointer to current
		move $s2, $s4					# set current to address at next
		bnez $s4, reg_increment_counter_pt6		# if $s4 == 0 j to increment_counter
			j increment_counter_Pt6
		reg_increment_counter_pt6:
		lw $s4, 8($s4)				# get address of next node
		
		increment_counter_Pt6:
		addi $t0, $t0, 1				# increment the counter
		j loop_thru_terms_Pt6
	
	error_Pt6:
	li $v0, -1
	li $v1, 0
	
	return_Part6:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	addi $sp, $sp, 20					# restore s register
	jr $ra
	
add_poly:
	addi $sp, $sp, -36					# preserve s registers
	sw $ra, 32($sp)
	sw $s7, 28($sp)
	sw $s6, 24($sp)
	sw $s5, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
		
	lw $s0, 0($a0) 						# argument 1: p polynomial
	lw $s1, 0($a1)						# argument 2: q polynomial
	move $s2, $a2 						# argument 3: r polynomial
	move $s4, $s0						# previous pointer for p
	move $s5, $s1						# previous pointer for q 
	
	bnez $s0, continue1_Pt7
	beqz $s1, empty_polynomials_Pt7
	
	continue1_Pt7:
	beqz $s0, add_all_toq_Pt7
	beqz $s1, add_all_top_Pt7
	li $s3, 0							# counter for what to do when
	
	loop_thru_terms_Pt7:
	bnez $s0, continue_loop_Pt7
	beqz $s1, set_up_r_list_Pt7
	
		continue_loop_Pt7:
		li $t0, 0						# p - coefficient
		li $t1, 0						# q - coefficient
		li $t4, -1						# p - exponents
		li $t5, -1						# q - exponents
		 
		beqz $s0, check_q_poly_Pt7
			lw $t4, 4($s0)				# p - current exponent
		check_q_poly_Pt7:
		beqz $s1, add_coefficients_Pt7
			lw $t5, 4($s1)				# q - current exponent
			
		add_coefficients_Pt7:
		bne $t4, $t5, p_coefficient_notnull_Pt7	# if both exponents are equal
			lw $t0, 0($s0)				# get coefficient at s0
			lw $t1, 0($s1)				# get coefficient at s1
			move $s4, $s0				# set previous to current
			move $s5, $s1
			lw $s0, 8($s0)				# set new currents
			lw $s1, 8($s1)
			j cont_add_coefficient_Pt7
			
		p_coefficient_notnull_Pt7:
		blt $t4, $t5, q_coefficient_notnull_Pt7
			lw $t0, 0($s0)				# get coefficient at s0
			move $s4, $s0				# set previous to current
			lw $s0, 8($s0)				# set new currents
			j cont_add_coefficient_Pt7
		
		q_coefficient_notnull_Pt7:
		blt $t5, $t4, q_coefficient_notnull_Pt7
			lw $t1, 0($s1)				# get coefficient at s1
			move $t4, $t5				# set the exponent within $t5 to $t4
			move $s5, $s1				# set previous and current values
			lw $s1, 8($s1)
			j cont_add_coefficient_Pt7
		
		cont_add_coefficient_Pt7:
		add $t0, $t0, $t1				# add up the coefficients
		
		li $a0, 8
		li $v0, 9
		syscall
		
		sw $t0, 0($v0)					# store the new coefficient
		sw $t4, 4($v0)					# store the new exponent
		
		bnez $s3, create_terms_arr_Pt7	# check to see if $s3 == 0
			move $s6, $v0
			j loop_back_to_top_Pt7
		create_terms_arr_Pt7:
		li $t0, 1
		bne $s3, $t0, loop_back_to_top_Pt7	# check to see if $s3 == 0
			move $s7, $v0
		
		loop_back_to_top_Pt7:
		addi $s3, $s3, 1				# get the total number of added to dynamic list
		j loop_thru_terms_Pt7
	
	set_up_r_list_Pt7:
	li $a0, 8
	li $v0, 9
	syscall
		
	li $t0, -1
	sw $0, 0($v0)					# store the new coefficient
	sw $t0, 4($v0)					# store the new exponent
	
	loop_thru_terms_tocheck_Pt7:
	blez $s3, empty_polynomials_Pt7
		lw $t0, 0($s6)				# check to see if first term equals 0
		beqz $t0, increment_thru_terms_tocheck_Pt7
			j initialize_Polynomial_Pt7
			
		increment_thru_terms_tocheck_Pt7:
		addi $s3, $s3, -1
		addi $s6, $s6, 8
		addi $s7, $s7, 8
		j loop_thru_terms_tocheck_Pt7
		
	initialize_Polynomial_Pt7:
	move $a0, $s2					# arg 1 = pair
	move $a1, $s6					# arg 2 = pointer
	jal init_polynomial
	bltz $v0, empty_polynomials_Pt7
	
	
	move $a0, $s2					# arg 1 = pointer
	move $a1, $s7					# arg 2 = list of coefficients
	addi $a2, $s3, -1				# arg 3 = list terms to add
	
	jal add_N_terms_to_polynomial	# set the rest of the polynomial
	
	li $v0, 1
	j return_Part7	
	
	add_all_top_Pt7:		
	sw $s0, 0($s2)
	li $v0, 1
	j return_Part7
	
	add_all_toq_Pt7:		
	sw $s1, 0($s2)
	li $v0, 1
	j return_Part7
	
	empty_polynomials_Pt7:
	li $v0, 0
	j return_Part7
	
	return_Part7:
	lw $s0, 0($sp)						# restore s registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	
	jr $ra
	
mult_poly:
	addi $sp, $sp, -36					# preserve s registers
	sw $ra, 32($sp)
	sw $s7, 28($sp)
	sw $s6, 24($sp)
	sw $s5, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	lw $s0,0($a0)						# save register: p polynomial
	lw $s1,0($a1)						# save register: q polynomial
	move $s2, $a2						# save register: r address for polynomial
	
	bnez $s0, continue1_Pt8				# check to see if both arrays given null
	beqz $s1, empty_polynomials_Pt8

	continue1_Pt8:
	beqz $s0, add_all_toq_Pt8			# checks to see which one is null and set
	beqz $s1, add_all_top_Pt8			# r to that value
	li $s3, 0							# this is the counter through the loop
	
	outerloop_thru_poly_Pt8:
	beqz $s0, return_regular_Pt8		# check to see if the address is 0
	
		lw $s6, 0($s0)					# p - get coefficient
		lw $s7, 4($s0)					# p - get exponent
		
		move $s4, $s1					# save register: save old register
		innerloop_thru_poly_Pt8:
		beqz $s4, increment_outerloop_Pt8
			lw $t2, 0($s4)				# q - get coefficient
			lw $t3, 4($s4)				# q - get exponent
			mul $t2, $t2, $s6			# p_coefficient * q_coefficient
			add $t3, $t3, $s7 			# p_exponent + q_exponent
			
			bnez $s3, continue_innerloop_Pt8
				addi $sp, $sp, -8			# decrease stack pointer to add pair
				sw $t2, 0($sp)				# add coefficient to stack
				sw $t3, 4($sp)				# add exponent to stack
				move $a0, $s2				# arg 1 = address for holding pointer
				move $a1, $sp				# arg 2 = pair
			
				jal init_polynomial			
				bltz $v0, empty_polynomials_Pt8 # if error in init then throw error
				addi $sp, $sp, 8
				j increment_innerloop_Pt8
	
			continue_innerloop_Pt8:
			addi $sp, $sp, -12			# decrease stack pointer to add pair
			sw $t2, 0($sp)				# add coefficient to stack
			sw $t3, 4($sp)				# add exponent to stack
			
			addi $a0, $sp, 8				# arg 1 = address for holding pointer
			move $a1, $sp				# arg 2 = pair
			
			jal init_polynomial			
			bltz $v0, empty_polynomials_Pt8 # if error in init then throw error
			addi $sp, $sp, 8
			
			#li $a0, 4				# get a space of term
			#li $v0, 9
			#syscall					# call upon the stack
			
			#lw $t0, 8($sp)			# store address in $sp in s5
			#move $t1, $v0 			# save the new addresss
			#sw $t0, 0($t1)			# store contents into the heap
			#addi $sp, $sp, 12			# increment $sp to get to address
			
			move $a0, $s2				# arg 1: r polynomial
			move $a1, $sp				# arg 2: address to first polynomial
			move $a2, $s2				# arg 3: r polynomial
			jal add_poly
			
			addi $sp, $sp, 4
	
			increment_innerloop_Pt8:
			addi $s3, $s3, 1				# increment count
			lw $s4, 8($s4)					# set cursor to next address
			j innerloop_thru_poly_Pt8
			
		increment_outerloop_Pt8:
		lw $s0, 8($s0)					# get next s0 value
		j outerloop_thru_poly_Pt8
		
	return_regular_Pt8:
	li $v0, 1
	j return_Part8
	
	add_all_top_Pt8:					# if q is null add to p	
	sw $s0, 0($s2)
	li $v0, 1
	j return_Part8
	
	add_all_toq_Pt8:					# if p is null add to q	
	sw $s1, 0($s2)
	li $v0, 1
	j return_Part8
	
	empty_polynomials_Pt8:				# this is the error tossed if r is empty
	li $v0, 0
	j return_Part8

	return_Part8:
	lw $s0, 0($sp)						# restore s registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	addi $sp, $sp, 36
	jr $ra
