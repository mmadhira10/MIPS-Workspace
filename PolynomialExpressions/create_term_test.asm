.data
coeff: .word 12
exp: .word 8

.text:
main:
    lw $a0, coeff
    lw $a1, exp
    jal create_term

	
    #write test code
	move $a0, $v0
	li $v0, 1
	syscall
	
	move $t0, $a0
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	
	lw $a0, 4($t0)
	li $v0, 1
	syscall
	
	
	li $v0, 10
    syscall

.include "hw5.asm"
