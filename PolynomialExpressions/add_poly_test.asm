.data
p_pair: .word 5 2
p_terms: .word 5 3 1 0 0 -1
q_pair: .word -7 2 
q_terms: .word 8 1 5 0 0 -1
p: .word 0
q: .word 0
r: .word 0
N: .word 1

.text:
main:
    la $a0, p
    la $a1, p_pair
    jal init_polynomial

    la $a0, p
    la $a1, p_terms
    lw $a2, N
    jal add_N_terms_to_polynomial

    la $a0, q
    la $a1, q_pair
    jal init_polynomial

    la $a0, q
    la $a1, q_terms
    lw $a2, N
    jal add_N_terms_to_polynomial

    la $a0, p
    la $a1, q
    la $a2, r
    jal add_poly

    #write test code
    
    li $t1, 3
    
    move $a0, $v0		# get output of function
    li $v0, 1
    syscall
    
    li $a0, 10			# new line character
    li $v0, 11
    syscall 
    
    la $t0, r
    lw $t0, 0($t0)		# address to linked list
    
   	li $t2, 0
    for_loop_Part7:
    beq $t2, $t1, end_Part7
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
    	
    	j for_loop_Part7
    	
	end_Part7:
    li $v0, 10
    syscall

.include "hw5.asm"
