.data
pair: .word 5 2
terms: .word 5 3 3 0 0 -1
p: .word 0
N: .word 5

.text:
main:
    la $a0, p
    la $a1, pair
    jal init_polynomial

    la $a0, p
    la $a1, terms
    lw $a2, N
    jal add_N_terms_to_polynomial

    #write test code
    addi $t1, $v0, 1
    
    move $a0, $v0		# get output of function
    li $v0, 1
    syscall
    
    li $a0, 10			# new line character
    li $v0, 11
    syscall 
    
    la $t0, p
    lw $t0, 0($t0)		# address to linked list
    
   	li $t2, 0
    for_loop_Part3:
    beq $t2, $t1, end_Part3
    	lw $a0, 0($t0)
    	li $v0, 1
    	syscall
    	
    	li $a0, 32
    	li $v0, 11
    	syscall
    	
    	lw $a0, 4($t0)
    	li $v0, 1
    	syscall
    	
    	li $a0, 32
    	li $v0, 11
    	syscall
    	
    	lw $t0, 8($t0)
    	addi $t2, $t2, 1
    	
    	j for_loop_Part3
    
    
    
    
    #la $a0, terms
    #jal helper_sort_exponents
    
    #la $t0, terms
    #li $t1, 0			# initialize for loop
    #for_loop:
    #li $t2, 4
    #beq $t1, $t2, end_Part3
    #	lw $a0, 0($t0)
    #	li $v0, 1
    #	syscall
    #	addi $t0, $t0, 4
    	
    #	li $a0, 32
    #	li $v0, 11
    #	syscall
    	
    #	lw $a0, 0($t0)
    #	li $v0, 1
    #	syscall
    #	addi $t0, $t0, 4
    	
    #	li $a0, 32
    #	li $v0, 11
    #	syscall
    	
    #	addi $t1, $t1, 1
    #	j for_loop
    	
	end_Part3:
    li $v0, 10
    syscall

.include "hw5.asm"
