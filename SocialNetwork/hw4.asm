############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:

str_len:
	move $t0, $a0						# save the address of the name
	
	check_empty_Pt1:
	lb $t1, 0($t0)						# load first char
	bgtz $t1, string_Pt1				# check to see if first char is null
		li $t2, 0						# set length return to 0
		j returnPart1
	
	string_Pt1:
	li $t2, 0							# save the counter for counting the chars
	
	loop_thru_string_Pt1:
	lb $t1, 0($t0)						# save the moving address
	beqz $t1, returnPart1				# loop thru the string and count chars
		addi $t0, $t0, 1				# get next char
		addi $t2, $t2, 1				# increment the number of chars
		j loop_thru_string_Pt1
	
	returnPart1:						# return back to address caller
	move $v0, $t2
	jr $ra
	
str_equals:
	addi $sp, $sp, -8					# make space on stack
	sw $s0, 0($sp)						# store saved registers
	sw $s1, 4($sp)

	move $s0, $a0						# save args into save registers
	move $s1, $a1
		
	loop_thru_names_Pt3:
	lb $t0, 0($s0)						# get char 
	lb $t1, 0($s1)
	bne $t0, $t1, not_equal_Pt3			# check to see if char equal each other
		beqz $t0, equal_Pt3
		beqz $t1, equal_Pt3
			addi $s0, $s0, 1
			addi $s1, $s1, 1
			j loop_thru_names_Pt3
	
	not_equal_Pt3:
	li $v0, 0
	j returnPart3
	
	equal_Pt3:
	li $v0, 1
	
	returnPart3:
	lw $s0, 0($sp)						# store saved registers
	lw $s1, 4($sp)
	addi $sp, $sp, 8					# make space on stack
	jr $ra
	
str_cpy:
	addi $sp, $sp, -4					# save original return address
	sw $ra, 0($sp)						# save return address
	jal str_len							# call the string length function
	
	move $t0, $a0						# save source address
	move $t1, $a1						# save dest address
	
	loop_thru_string_Pt2:
	lb $t2, 0($t0)						# get first char
	beqz $t2, returnPart2				# exit loop t2 = null
	  sb $t2, 0($t1)					# copy char into new address
	  addi $t0, $t0, 1					# increment source address
	  addi $t1, $t1, 1					# increment dest address
	  j loop_thru_string_Pt2
	
	returnPart2:
	lw $ra, 0($sp)						# restore return address
	addi $sp, $sp, 4					# restore original return address
	jr $ra
	
create_person:
	addi $sp, $sp, -4					# save original return address
	sw $s0, 0($sp)						# save return address
	
	move $s0, $a0						# save the address for the network
	lw $t0, 0($s0)						# get the number of nodes
	addi $t2, $s0, 36					# get the nodes address
	lw $t3, 8($s0)						# get the size of the node
	
	li $t1, 0							# loop counter
	loop_thru_nodes_Pt4:
	beq $t1, $t0, space_full_Pt4
		lb $t4, 0($t2)					# get the char
		beqz $t4, space_not_full_Pt4
			addi $t1, $t1, 1			# increment counter
			add $t2, $t2, $t3			# increase address by size node
			j loop_thru_nodes_Pt4
	
	space_full_Pt4:
	li $v0, -1
	j returnPart4
	
	space_not_full_Pt4:
	lw $t1, 16($s0)						# get the num of nodes
	addi $t1, $t1, 1					# increment curr_number_nodes
	sw $t1, 16($s0)						# add it back in 
	move $v0, $t2
	
	returnPart4:
	lw $s0, 0($sp)						# restore return address
	addi $sp, $sp, 4					# restore original return address
	jr $ra
	
is_person_exists:
	addi $sp, $sp, -8					# make space on stack
	sw $s0, 0($sp)						# store saved registers
	sw $s1, 4($sp)
	
	move $s0, $a0						# save the first arg
	move $s1, $a1						# save the second arg
	
	addi $t0, $s0, 36
	sub $t0, $s1, $t0					# get the change addresses
	lw $t1, 8($s0)						# get the size of node
	div $t0, $t1						# pick to see what node it is
	mflo $t2
	lw $t1, 16($s0)						# get total possible nodes
	
	bge $t2, $t1, return_0_Pt5
	bltz $t2, return_0_Pt5
	li $v0, 1
	j returnPart5

	return_0_Pt5:
	li $v0, 0
	j returnPart5
	
	returnPart5:
	lw $s0, 0($sp)						# store saved registers
	lw $s1, 4($sp)
	addi $sp, $sp, 8					# make space on stack
	jr $ra
	
is_person_name_exists:
	addi $sp, $sp, -12					# save original return address
	sw $s0, 0($sp)						# save return address
	sw $s1, 4($sp)						# save the name
	sw $s2, 8($sp)
	
	move $s0, $a0						# save the first argument
	move $s1, $a1						# save the name
	
	lw $s2, 16($s0)						# get current number of nodes
	lw $t2, 8($s0)						# size of each node
	addi $t3, $s0, 36					# offset to get the first node
	
	addi $sp, $sp, -4					# preserve return address
	sw $ra, 0($sp)
	
	li $t4, 0							# set counter to 0
	loop_thru_nodes_Pt6:
	beq $t4, $s2, return0_Pt6			# if counter == current num nodes 
		
		move $a0, $s1					# arg1 = checking name
		move $a1, $t3					# arg2 = node name to check with
		
		jal str_equals					# checking to see if the strings equal
		
		bnez $v0, return1_Pt6
			
			add $t3, $t3, $t2			# increment the address
			addi $t4, $t4, 1			# increment the counter
		
		 j loop_thru_nodes_Pt6 

	return0_Pt6:
	li $v0, 0							# return = false
	j returnPart6
	
	return1_Pt6:
	li $v0, 1							# return = true
	move $v1, $t3						# 2nd return = address
	
	returnPart6:
	lw $ra, 0($sp)						# restore return address
	addi $sp, $sp, 4
	lw $s0, 0($sp)						# restore return address
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12					# restore original return address
	jr $ra
	
add_person_property:
	addi $sp, $sp, -16					# save original return address
	sw $s0, 0($sp)					
	sw $s1, 4($sp)						
	sw $s2, 8($sp)
	sw $s3, 12($sp)			
	
	move $s0, $a0						# save arguments: network
	move $s1, $a1						# save arguments: next spot to put
	move $s2, $a2						# save arguments: the property 
	move $s3, $a3						# save arguments: the name
	
	addi $sp, $sp, -4					# save the return address
	sw $ra, 0($sp)
	
	move $a0, $s2						# arg1 = name property
	addi $a1, $s0, 24						# arg2 = name property
	jal str_equals
	
	beqz $v0, wrong_property_Pt7		# if len(property) != 4
	
	move $a0, $s0						# arg1 = network
	move $a1, $s1						# arg2 = next place to put object
	jal is_person_exists				# check to see if person exists
	
	beqz $v0, person_nonexistent_Pt7	# person nonexistent
	
	move $a0, $s3						# arg1 = name being added
	jal str_len
	addi $v0, $v0, 1
	
	lw $t0, 8($s0)						# checking the length
	bgt $v0, $t0, str_long_Pt7			# v0 < length of string
	
	move $a0, $s0						# arg1 = network
	move $a1, $s3						# arg2 = name
	jal is_person_name_exists
	
	bnez $v0, person_name_exists_Pt7	# if v0 != 0 jump
	
	loop_thru_name_Pt7:
	lb $t0, 0($s3)						# get char from name
	beqz $t0, correct_args_Pt7
		sb $t0, 0($s1)					# store byte
		addi $s1, $s1, 1				# increment the address
		addi $s3, $s3, 1				# increment the word address
		j loop_thru_name_Pt7
	
	wrong_property_Pt7:					
	li $v0, 0							# if wrong property name is given
	j returnPart7
	
	person_nonexistent_Pt7:
	li $v0, -1							# if person doesnt exists
	j returnPart7
	
	str_long_Pt7:						# if str is too long
	li $v0, -2
	j returnPart7
	
	person_name_exists_Pt7:				# if str is not unique
	li $v0, -3
	j returnPart7
	
	correct_args_Pt7:					# if str follows correct conditions
	li $v0, 1
	
	returnPart7:
	lw $ra, 0($sp)
	addi $sp, $sp, 4					# save the return address
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp,16
	jr $ra
	
get_person:
	addi $sp, $sp, -8					# make space on stack
	sw $s0, 0($sp)						# store saved registers
	sw $s1, 4($sp)
	
	addi $sp, $sp, -4					# save return address
	sw $ra, 0($sp)
	
	move $s0, $a0						# arg1 = network
	move $s1, $a1						# arg2 = name
	jal is_person_name_exists
	
	beqz $v0, returnPart8
	move $v0, $v1						# set the second return to first
	
	returnPart8:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $s0, 0($sp)						# store saved registers
	lw $s1, 4($sp)
	addi $sp, $sp, 8					# make space on stack
	jr $ra
	
is_relation_exists:
	addi $sp, $sp, -12					# make space on stack
	sw $s0, 0($sp)						# store saved registers
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	
	
	lw $t7, 8($s0)						# calculate effective address
	lw $t8, 0($s0)
	mul $t8, $t7, $t8					
	li $t9, 4
	div $t8, $t9
	mfhi $t9
	beqz $t9, add_to_get_address_Pt9
		li $t7, 4
		sub $t7, $t9, $t7
		add $t8, $t8, $t9
	
	add_to_get_address_Pt9:
	add $t2, $s0, $t8 
	addi $t2, $t2, 36
	
	lw $t0, 20($s0)
	li $t1, 0
	loop_thru_edges_Pt9:
	beq $t1, $t0, return0_Pt9			# if incr == total then jump
		lw $t3, 0($t2)					# get the address for first node
		beq $s1, $t3, check_addr1_Pt9
		lw $t3, 4($t2)					# get the address for first node
		beq $s1, $t3, check_addr2_Pt9
		j increment_loop_Pt9
		
		check_addr1_Pt9:
		lw $t3, 4($t2)					# get the address for first node
		beq $s2, $t3, return1_Pt9
		j increment_loop_Pt9
		
		check_addr2_Pt9:
		lw $t3, 0($t2)					# get the address for first node
		beq $s2, $t3, return1_Pt9
		
		increment_loop_Pt9:
		addi $t1, $t1, 1
		addi $t2, $t2, 12
		j loop_thru_edges_Pt9
		
	return0_Pt9:
	li $v0, 0
	j returnPart9
	
	return1_Pt9:
	li $v0, 1
	move $v1, $t2
	
	returnPart9:
	lw $s0, 0($sp)						# store saved registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12					# make space on stack
	jr $ra
	
add_relation:
	addi $sp, $sp, -12					# make space on stack
	sw $s0, 0($sp)						# store saved registers
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	move $s0, $a0						# save arguments
	move $s1, $a1
	move $s2, $a2
	
	addi $sp, $sp, -4					# preserve return address
	sw $ra, 0($sp)
	
	move $a0, $s0						# arg1 = network
	move $a1, $s1						# arg2 = person
	jal is_person_exists
	
	beqz $v0, person_nonexsistent_Pt10
	
	move $a0, $s0						# arg1 = network
	move $a1, $s2						# arg2 = person
	jal is_person_exists
	
	beqz $v0, person_nonexsistent_Pt10
	
	lw $t0, 4($s0)						# get total # possible edges
	lw $t1, 20($s0)						# curr # edges
	beq $t0, $t1, capacity_met_Pt10
	
	move $a0, $s0						# arg1 = network
	move $a1, $s1						# arg2 = person1
	move $a2, $s2						# arg3 = person2
	jal is_relation_exists				
	
	bnez $v0, relation_exists_Pt10
	
	beq $s1, $s2, same_person_Pt10
	
	lw $t7, 8($s0)						# calculate effective address
	lw $t8, 0($s0)
	mul $t8, $t7, $t8					
	li $t9, 4
	div $t8, $t9
	mfhi $t9
	beqz $t9, add_to_get_address_Pt10
		li $t7, 4
		sub $t7, $t9, $t7
		add $t8, $t8, $t9
	
	add_to_get_address_Pt10:
	add $t1, $s0, $t8 
	addi $t1, $t1, 36

	loop_thru_edges_Pt10:
	lw $t0, 0($t1)						# get set of edges
	beqz $t0, add_edge_Pt10
		addi $t1, $t1, 12				# increment the address	
	j loop_thru_edges_Pt10
	
	person_nonexsistent_Pt10:
	li $v0, 0
	j returnPart10
	
	capacity_met_Pt10:
	li $v0, -1
	j returnPart10
	
	relation_exists_Pt10:
	li $v0, -2
	j returnPart10
	
	same_person_Pt10:
	li $v0, -3
	j returnPart10
	
	add_edge_Pt10:
	sw $s1, 0($t1)						# store new addresses
	sw $s2, 4($t1)
	lw $t0, 20($s0)						# increment the num of edges
	addi $t0, $t0, 1
	sw $t0, 20($s0)
	li $v0, 1
	
	returnPart10:
	lw $ra, 0($sp)
	addi $sp, $sp, 4					# preserve return address
	lw $s0, 0($sp)						# store saved registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12					# make space on stack
	jr $ra
	
add_relation_property:
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	
	addi $sp, $sp, -20					# make space on stack
	sw $s0, 0($sp)						# store saved registers
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $s0, $a0						# all the arguments for function
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	move $s4, $t0
	
	move $a0, $s0						# arg1 = network
	move $a1, $s1						# arg2 = person1
	move $a2, $s2						# arg3 = person2
	jal is_relation_exists
	
	beqz $v0, relation_Pt11
	move $t9, $v1
	
	addi $a0, $s0, 29					# get the friend name
	move $a1, $s3						# get the value 
	jal str_equals						# check if the new str 
	
	beqz $v0, not_property_Pt11      
	
	bltz $s4, invalid_property_Pt11
	
	sw $s4, 8($t9)						# store the contents s4
	li $v0, 1
	j returnPart11
	
	invalid_property_Pt11:
	li $v0, -2
	j returnPart11
	
	not_property_Pt11:
	li $v0, -1
	j returnPart11
	
	relation_Pt11:
	li $v0, 0
	j returnPart11
	
	returnPart11:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	lw $s0, 0($sp)						# store saved registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	addi $sp, $sp, 20					# make space on stack
	jr $ra
	
is_friend_of_friend:
	addi $sp, $sp, -12					# make space on stack
	sw $s0, 0($sp)						# store saved registers
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	move $s0, $a0						# save the arguments to be used later
	move $s1, $a1
	move $s2, $a2
	
	move $a0, $s1
	move $a1, $s2
	jal str_equals
	
	bnez $v0, not_mutual_friends_Pt12
	
	move $a0, $s0
	move $a1, $s1
	jal is_person_name_exists
	
	beqz $v0, person_nonexsistent_Pt12
	move $s1, $v1
	
	move $a0, $s0						# arg1 = network
	move $a1, $v1						# arg2 = person
	jal is_person_exists
	
	beqz $v0, person_nonexsistent_Pt12
	
	move $a0, $s0
	move $a1, $s2
	jal is_person_name_exists
	
	beqz $v0, person_nonexsistent_Pt12
	move $s2, $v1
	
	move $a0, $s0						# arg1 = network
	move $a1, $s2						# arg2 = person
	jal is_person_exists
	
	beqz $v0, person_nonexsistent_Pt12
	
	move $a0, $s0						# arg1 = network
	move $a1, $s1						# arg2 = person1
	move $a2, $s2						# arg3 = person2
	
	jal is_friends						# check to see if they are friends
	
	bgtz $v0, not_mutual_friends_Pt12
	
	lw $t4, 20($s0)						# get current number of edges
	lw $t7, 8($s0)						# calculate effective address
	lw $t8, 0($s0)
	mul $t8, $t7, $t8					
	li $t9, 4
	div $t8, $t9
	mfhi $t9
	beqz $t9, add_to_get_address_Pt12
		li $t7, 4
		sub $t7, $t9, $t7
		add $t8, $t8, $t9
	
	add_to_get_address_Pt12:
	add $t6, $s0, $t8 
	addi $t6, $t6, 36
	
	li $t5, 0							# counter
	loop_thru_edges_Pt12:
	beq $t5, $t4, not_mutual_friends_Pt12# 
		move $a0, $s0					# arg1 = network
		lw $a1, 0($t6)					# arg2 = person1
		lw $a2, 4($t6)					# arg3 = person3
		
		jal is_friends
		beqz $v0, increment_loop_Pt12
		lw $t7, 0($v1)
		beq $t7, $s1, friends_friends_Pt12
		lw $t7 ,4($v1)
		beq $t7, $s1, friends_friends_Pt12
		lw $t7, 0($v1)
		beq $t7, $s2, friends_friends_Pt12
		lw $t7 ,4($v1)
		beq $t7, $s2, friends_friends_Pt12
	
		increment_loop_Pt12:
		addi $t6, $t6, 12
		addi $t5, $t5, 1
		j loop_thru_edges_Pt12
		
	person_nonexsistent_Pt12:
	li $v0, -1
	j returnPart12
	
	not_mutual_friends_Pt12:
	li $v0, 0
	j returnPart12
	
	friends_friends_Pt12:
	li $v0, 1
	
	returnPart12:
	lw $ra, 0($sp)
	addi $sp, $sp, 4					# preserve return address
	lw $s0, 0($sp)						# store saved registers
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12					# make space on stack
	jr $ra

is_friends:
	move $t0, $a0						# save network
	move $t1, $a1						# save address
	move $t2, $a2						# save address
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal is_relation_exists				# calling the relationship exists func
	beqz $v0, not_related_Help
	lw $t3, 8($v1)
	blez $t3, not_related_Help
	li $v0, 1
	j returnHelp
		
	not_related_Help:
	li $v0, 0
	j returnHelp
	
	returnHelp:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra