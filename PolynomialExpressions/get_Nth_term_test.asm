.data
pair: .word 12 8
terms: .word 16 5 1 3 0 -1
p: .word 0
N: .word 3
N1: .word 3

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
    jal get_Nth_term

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

    li $v0, 10
    syscall

.include "hw5.asm"
