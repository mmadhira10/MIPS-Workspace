.data
pair: .word 0 3
p: .word 0

.text:
main:
    la $a0, p
    la $a1, pair
    jal init_polynomial

    #write test code
    move $a0, $v0		# get output of function
    li $v0, 1
    syscall
    
    li $a0, 10			# new line character
    li $v0, 11
    syscall 
    
    la $t0, p			# set the pointer
    
    move $a0, $t0		# get the address stored in p
    li $v0, 1
    syscall
    
    li $a0, 10			# new line character
    li $v0, 11
    syscall 
    
    lw $t0, 0($t0)
    
    lw $a0, 0($t0)		# get the coefficient
    li $v0, 1
    syscall

    li $a0, 10			# new line character
    li $v0, 11
    syscall 
    
    lw $a0, 4($t0)		# get the exponent
    li $v0, 1
    syscall

    li $v0, 10
    syscall

.include "hw5.asm"
