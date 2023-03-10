.data
pair: .word 12 8
terms: .word 16 5 -2 3 5 0 0 -1
p: .word 0
N: .word 3
N1: .word 4

.text:
main:
    la $a0, p
    la $a1, pair
    jal init_polynomial

    la $a0, p
    la $a1, terms
    lw $a2, N
    jal add_N_terms_to_polynomial

    la $a0, p
    lw $a1, N1
    jal remove_Nth_term

    #write test code
    
    move $t0, $v0
    move $t1, $v1
    
    move $a0, $t0
    li $v0, 1
    syscall
    
    li $a0, 10			# new line character
    li $v0, 11
    syscall
    
    move $a0, $t1
    li $v0, 1
    syscall

	li $a0, 10			# new line character
    li $v0, 11
    syscall 
    #write test code
    li $t1, 3
    la $t0, p
    lw $t0, 0($t0)		# address to linked list
    
   	li $t2, 0
    for_loop_Part6:
    beq $t2, $t1, end_Part6
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
    	
    	j for_loop_Part6

	end_Part6:
    li $v0, 10
    syscall

.include "hw5.asm"
