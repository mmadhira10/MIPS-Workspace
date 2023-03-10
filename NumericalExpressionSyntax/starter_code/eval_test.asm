.data
Newline: .asciiz "\n"
WrongArgMsg: .asciiz "You must provide exactly one argument"
BadToken: .asciiz "Unrecognized Token"
ParseError: .asciiz "Ill Formed Expression"
ApplyOpError: .asciiz "Operator could not be applied"

val_stack : .word 0
op_stack : .word 0
equation : .asciiz ""


.text
.globl main
main:
 
  # add code to call and test eval function
  la $a0, equation
  jal eval 

end:
	# Terminates the program
	li $v0, 10
	syscall

.include "hw2-funcs.asm"
