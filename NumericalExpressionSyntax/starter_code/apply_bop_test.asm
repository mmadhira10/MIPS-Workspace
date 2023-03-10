.data
Newline: .asciiz "\n"
WrongArgMsg: .asciiz "You must provide exactly one argument"
BadToken: .asciiz "Unrecognized Token"
ParseError: .asciiz "Ill Formed Expression"
ApplyOpError: .asciiz "Operator could not be applied"

val_stack : .word 0
op_stack : .word 0

.text
.globl main
main:

  # add code to test call and test apply_bop function
  li $a0, -1
  li $a1, '/'
  li $a2, -2
  jal apply_bop
  move $a0, $v0
  li $v0, 1
  syscall 

end:
  # Terminates the program
  li $v0, 10
  syscall

.include "hw2-funcs.asm"
