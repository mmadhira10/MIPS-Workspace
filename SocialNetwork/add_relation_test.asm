# add test cases to data section
# Test your code with different Network layouts
# Don't assume that we will use the same layout in all our tests
.data
Name1: .asciiz "Cacophonix"
Name2: .asciiz "Getafix"
Name_prop: .asciiz "NAME"

Network:
  .word 5   #total_nodes (bytes 0 - 3)
  .word 10  #total_edges (bytes 4- 7)
  .word 12  #size_of_node (bytes 8 - 11)
  .word 12  #size_of_edge (bytes 12 - 15)
  .word 0   #curr_num_of_nodes (bytes 16 - 19)
  .word 0   #curr_num_of_edges (bytes 20 - 23)
  .asciiz "NAME" # Name property (bytes 24 - 28)
  .asciiz "FRIEND" # FRIEND property (bytes 29 - 35)
   # nodes (bytes 36 - 95)	
  .byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0	
   # set of edges (bytes 96 - 215)
  .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

.text:
main:
	la $a0, Network
	jal create_person
	move $s0, $v0
	
	la $a0, Network
	move $a1, $s0
	la $a2, Name_prop
	la $a3, Name1
	jal add_person_property
	
	la $a0, Network
	jal create_person
	move $s1, $v0
	
	la $a0, Network
	move $a1, $s1
	la $a2, Name_prop
	la $a3, Name2
	jal add_person_property
	
	la $a0, Network
	move $a1, $s0
	move $a2, $s1
	jal add_relation
	
	la $a0, Network
	move $a1, $s1
	move $a2, $s1
	jal add_relation
	
	move $a0, $v0
	li $v0, 1
	syscall
	
	la $t0, Network
	addi $t0, $t0, 96
	lw $a0, 0($t0)
	li $v0, 1
	syscall
	
	lw $a0, 4($t0)
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
.include "hw4.asm"
