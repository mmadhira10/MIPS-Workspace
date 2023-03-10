.data
pair: .word 1 1
terms: .word 2 2 3 3 4 4 0 -1
new_terms: .word 1 4 2 3 3 2 4 1 2 2 3 3 4 4 0 1 0 -1
p: .word 0
N: .word 20

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
    la $a1, new_terms
    lw $a2, N
    jal update_N_terms_in_polynomial
    
    move $a0, $v0
    li $v0, 1
    syscall

	li $a0, 10			# new line character
    li $v0, 11
    syscall 
    #write test code
    li $t1, 4
    la $t0, p
    lw $t0, 0($t0)		# address to linked list
    
   	li $t2, 0
    for_loop_Part3:
    beq $t2, $t1, end_Part4
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

	end_Part4:
    li $v0, 10
    syscall

.include "hw5.asm"
