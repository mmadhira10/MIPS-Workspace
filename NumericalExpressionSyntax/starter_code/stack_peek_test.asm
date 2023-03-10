.data
Newline: .asciiz "\n"
WrongArgMsg: .asciiz "You must provide exactly one argument"
BadToken: .asciiz "Unrecognized Token"
ParseError: .asciiz "Ill Formed Expression"
ApplyOpError: .asciiz "Operator could not be applied"
Comma: .asciiz ","

val_stack : .word 0
op_stack : .word 0

.text
.globl main
main:

  # add code to call and test test stack_peek function
  la $a2, val_stack
  li $a1, 0
  li $a0, 5
  jal stack_push
  
  move $a0, $a1
  la $a1, val_stack
  jal stack_peek
  move $a0, $v0
  li $v0, 1
  syscall

end:
  # Terminates the program
  li $v0, 10
  syscall

.include "hw2-funcs.asm"
