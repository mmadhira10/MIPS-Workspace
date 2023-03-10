.data

ErrMsg: .asciiz "Invalid Argument"
WrongArgMsg: .asciiz "You must provide exactly two arguments"
EvenMsg: .asciiz "Even"
OddMsg: .asciiz "Odd"

# for 5b to create the mantissa
Decimal: .asciiz "1."
 

arg1_addr : .word 0
arg2_addr : .word 0
num_args : .word 0

.text: 
.globl main
main:
	sw $a0, num_args

	lw $t0, 0($a1) # takes address in $a1 + 0
	sw $t0, arg1_addr
	lw $s1, arg1_addr 

	lw $t1, 4($a1) # takes address in $a1 + 4
	sw $t1, arg2_addr
	lw $s2, arg2_addr


# do not change any line of code above this section
# you can add code to the .data section

# t0 and t1 occupied
# s1 and s2 are occupied

start_coding_here:

##########        Part 1       ###########

	addi $t2, $0, 2
	beq $a0, $t2, checking_addr1
	li $v0, 4 # otherwise terminate
	la $a0, WrongArgMsg
	syscall
	li $v0, 10
	syscall 

# check if argument1 is right character, $t2 = <character>
checking_addr1:
	lbu $t3, 0($s1)
caseO: # check if arg1_addr equals O
	li $t2, 'O'
	bne $t3, $t2, caseS
	j checking_addr2
caseS: # check if arg1_addr equals S
	li $t2, 'S'
	bne $t3, $t2, caseT
	j checking_addr2
caseT: # check if arg1_addr equals T
	li $t2, 'T'
	bne $t3, $t2, caseI
	j checking_addr2
caseI: # check if arg1_addr equals I
	li $t2, 'I'
	bne $t3, $t2, caseE
	j checking_addr2
caseE: # check if arg1_addr equals E
	li $t2, 'E'
	bne $t3, $t2, caseC
	j checking_addr2
caseC: # check if arg1_addr equals C
	li $t2, 'C'
	bne $t3, $t2, caseX
	j checking_addr2
caseX: # check if arg1_addr equals X
	li $t2, 'X'
	bne $t3, $t2, caseM
	j checking_addr2
caseM: # check if arg1_addr equals M
	li $t2, 'M'
	bne $t3, $t2, default
	j checking_addr2
default: # check if arg_addr is not equal to any of the val
	li $v0, 4
	la $a0, ErrMsg
	syscall
	li $v0, 10
	syscall
	
# check if argument2 is right string
checking_addr2: 
	li $t2, 0 # counter
	li $t4, 0 # null character
while_ad2: 
	lbu $t5, 0($s2) # current character
	beq $t5, $t4, ad2_hex # if null = null jump ahead
caseF_ad2: # check if arg2_addr equals F
	li $t6, 'F'
	bne $t5, $t6, caseE_ad2
	j nextchar
caseE_ad2: # check if arg2_addr equals E
	li $t6, 'E'
	bne $t5, $t6, caseD_ad2
	j nextchar
caseD_ad2: # check if arg2_addr equals D
	li $t6, 'D'
	bne $t5, $t6, caseC_ad2
	j nextchar
caseC_ad2: # check if arg2_addr equals C
	li $t6, 'C'
	bne $t5, $t6, caseB_ad2
	j nextchar
caseB_ad2: # check if arg2_addr equals B
	li $t6, 'B'
	bne $t5, $t6, caseA_ad2
	j nextchar
caseA_ad2: # check if arg2_addr equals A
	li $t6, 'A'
	bne $t5, $t6, case9_ad2
	j nextchar
case9_ad2: # check if arg2_addr equals 9
	li $t6, '9'
	bne $t5, $t6, case8_ad2
	j nextchar
case8_ad2: # check if arg2_addr equals 8
	li $t6, '8'
	bne $t5, $t6, case7_ad2
	j nextchar
case7_ad2: # check if arg2_addr equals 7
	li $t6, '7'
	bne $t5, $t6, case6_ad2
	j nextchar
case6_ad2: # check if arg2_addr equals 6
	li $t6, '6'
	bne $t5, $t6, case5_ad2
	j nextchar
case5_ad2: # check if arg2_addr equals 5
	li $t6, '5'
	bne $t5, $t6, case4_ad2
	j nextchar
case4_ad2: # check if arg2_addr equals 4
	li $t6, '4'
	bne $t5, $t6, case3_ad2
	j nextchar
case3_ad2: # check if arg2_addr equals 3
	li $t6, '3'
	bne $t5, $t6, case2_ad2
	j nextchar
case2_ad2: # check if arg2_addr equals 2
	li $t6, '2'
	bne $t5, $t6, case1_ad2
	j nextchar
case1_ad2: # check if arg2_addr equals 1
	li $t6, '1'
	bne $t5, $t6, case0_ad2
	j nextchar
case0_ad2: # check if arg2_addr equals 0
	li $t6, '0'
	bne $t5, $t6, casex_ad2
	j nextchar
casex_ad2: # check if arg2_addr equals x
	li $t6, 'x'
	li $t7, 1
	bne $t7, $t2, def_ad2
	bne $t5, $t6, def_ad2
	j nextchar
def_ad2: # check if arg_addr is not equal to any of the val
	li $v0, 4
	la $a0, ErrMsg
	syscall
	li $v0, 10
	syscall
nextchar: # moves to the next character
	addi $t2, $t2, 1 # add to the counter
	addi $s2, $s2, 1 # get addr of next char
	j while_ad2

ad2_hex: # checks the first two characters
	addi $t2, $t2, -10 # seeing if the hexadeci is over 8
	bgez $t2, Part2 # terminate code if isn't
	li $v0, 4
	la $a0, ErrMsg
	syscall
	li $v0, 10
	syscall
	
##########        Part 2       ###########

Part2:
	lw $s2, arg2_addr # reset address
	addi $s2, $s2, 2 # move 2 characters
	li $t2, 0 # set counter
	addi $t3, $0, 8 # limit
	li $s4, 0
while_bits: # loop through the char
	lbu $t4, 0($s2) #get current char
	beq $t2, $t3, Part2a 
caseF_bits: # check if it equals to bit F
	li $t5, 'F'
	bne $t5, $t4, caseE_bits
	addi $t4, $t4, -55 # sub 55 from A-F
	j next_hexa
caseE_bits: # check if it equals to bit E
	li $t5, 'E'
	bne $t5, $t4, caseD_bits
	addi $t4, $t4, -55
	j next_hexa
caseD_bits: # check if it equals to bit D
	li $t5, 'D'
	bne $t5, $t4, caseC_bits
	addi $t4, $t4, -55
	j next_hexa
caseC_bits: # check if it equals to bit C
	li $t5, 'C'
	bne $t5, $t4, caseB_bits
	addi $t4, $t4, -55
	j next_hexa
caseB_bits: # check if it equals to bit B
	li $t5, 'B'
	bne $t5, $t4, caseA_bits
	addi $t4, $t4, -55
	j next_hexa
caseA_bits: # check if it equals to bit A
	li $t5, 'A'
	bne $t5, $t4, case9_bits
	addi $t4, $t4, -55
	j next_hexa
case9_bits: # check if it equals to bit 9
	li $t5, '9'
	bne $t5, $t4, case8_bits
	addi $t4, $t4, -48 # sub 48 from 0-9
	j next_hexa
case8_bits: # check if it equals to bit 8
	li $t5, '8'
	bne $t5, $t4, case7_bits
	addi $t4, $t4, -48
	j next_hexa
case7_bits: # check if it equals to bit 7
	li $t5, '7'
	bne $t5, $t4, case6_bits
	addi $t4, $t4, -48
	j next_hexa
case6_bits: # check if it equals to bit 6
	li $t5, '6'
	bne $t5, $t4, case5_bits
	addi $t4, $t4, -48
	j next_hexa
case5_bits: # check if it equals to bit 5
	li $t5, '5'
	bne $t5, $t4, case4_bits
	addi $t4, $t4, -48
	j next_hexa
case4_bits: # check if it equals to bit 4
	li $t5, '4'
	bne $t5, $t4, case3_bits
	addi $t4, $t4, -48
	j next_hexa
case3_bits: # check if it equals to bit 3
	li $t5, '3'
	bne $t5, $t4, case2_bits
	addi $t4, $t4, -48
	j next_hexa
case2_bits: # check if it equals to bit 2
	li $t5, '2'
	bne $t5, $t4, case1_bits
	addi $t4, $t4, -48
	j next_hexa
case1_bits: # check if it equals to bit 1
	li $t5, '1'
	bne $t5, $t4, case0_bits
	addi $t4, $t4, -48
	j next_hexa
case0_bits: # check if it equals to bit 0
	li $t5, '0'
	addi $t4, $t4, -48
	j next_hexa	
next_hexa:
	addi $t6, $0, 4 
	mul $t7, $t2, $t6 # multiply the counter by 4
	addi $t8, $0, 28 
	sub $t9, $t8, $t7 # 28 - counter * 4
	sllv $s3, $t4, $t9 # shift to the left by factor of 4
	or $s4, $s4, $s3
	addi $t2, $t2, 1
	addi $s2, $s2, 1
	j while_bits
	
Part2a: # print opcode value
	lbu $s3, 0($s1)
	li $t2, 'O'
	bne $s3, $t2, Part2b
	srl $s5, $s4, 26
	li  $v0, 1 
    	add $a0, $s5, $0
    	syscall
    	j TerminateProgram

Part2b: # print rs value
	li $t2, 'S'
	bne $s3, $t2, Part2c
	sll $s5, $s4, 6
	srl $s5, $s5, 27
	li  $v0, 1 
    	add $a0, $s5, $0
    	syscall
    	j TerminateProgram
    	
Part2c: # print rt value
	li $t2, 'T'
	bne $s3, $t2, Part2d
	sll $s5, $s4, 11
	srl $s5, $s5, 27
	li  $v0, 1 
    	add $a0, $s5, $0
    	syscall
    	j TerminateProgram
    	
Part2d: # print immediate value
	li $t2, 'I'
	bne $s3, $t2, Part3
	sll $s5, $s4, 16
	sra $s5, $s5, 16
	li  $v0, 1 
    	add $a0, $s5, $0
    	syscall
    	j TerminateProgram
    	
    	
##########        Part 3       ###########

Part3: # does shift to get 1 bit
	li $t2, 'E'
	bne $s3, $t2, Part4
	sll $s5, $s4, 31
	srl $s5, $s5, 31
part3_even: # prints out whether number is even
	bne $s5, $0, part3_odd
	li $v0, 4 
	la $a0, EvenMsg
	syscall
	j TerminateProgram
part3_odd: # prints out whether number is odd
	li $v0, 4 
	la $a0, OddMsg
	syscall
	j TerminateProgram
    	
##########        Part 4       ###########

Part4:
	lw $s2, arg2_addr # reset address
	li $t2, 'C'
	bne $s3, $t2, Part5a
	li $t3, 0 # counter up to 8
	li $t4, 8 # while loop limit
	li $t7, 0 # total amount of 1 bits in addr2
	addi $s2, $s2, 2 #skip of the first chars in addr2
while_part4:
	lbu $t5, 0($s2)
	beq $t3, $t4, printCount # condition for the while loop
caseF_part4: # F = 4 bits
	li $t6, 'F'
	bne $t5, $t6, caseE_part4
	addi $t7, $t7, 4 # add 4 1 bits to 
	j count_bits
caseE_part4: # check if it equals to bit E
	li $t6, 'E'
	bne $t5, $t6, caseD_part4
	addi $t7, $t7, 3 # add 3 1 bits to 
	j count_bits
caseD_part4: # check if it equals to bit D
	li $t6, 'D'
	bne $t5, $t6, caseC_part4
	addi $t7, $t7, 3 # add 3 1 bits to 
	j count_bits
caseC_part4: # check if it equals to bit C
	li $t6, 'C'
	bne $t5, $t6, caseB_part4
	addi $t7, $t7, 2 # add 2 1 bits to 
	j count_bits
caseB_part4: # check if it equals to bit B
	li $t6, 'B'
	bne $t5, $t6, caseA_part4
	addi $t7, $t7, 3 # add 3 1 bits to 
	j count_bits
caseA_part4: # check if it equals to bit A
	li $t6, 'A'
	bne $t5, $t6, case9_part4
	addi $t7, $t7, 2 # add 2 1 bits to 
	j count_bits
case9_part4: # check if it equals to bit 9
	li $t6, '9'
	bne $t5, $t6, case8_part4
	addi $t7, $t7, 2 # add 2 1 bits to 
	j count_bits
case8_part4: # check if it equals to bit 8
	li $t6, '8'
	bne $t5, $t6, case7_part4
	addi $t7, $t7, 1  # add 1 1 bits to 
	j count_bits
case7_part4: # check if it equals to bit 7
	li $t6, '7'
	bne $t5, $t6, case6_part4
	addi $t7, $t7, 3 # add 3 1 bits to 
	j count_bits
case6_part4: # check if it equals to bit 6
	li $t6, '6'
	bne $t5, $t6, case5_part4
	addi $t7, $t7, 2 # add 2 1 bits to 
	j count_bits
case5_part4: # check if it equals to bit 5
	li $t6, '5'
	bne $t5, $t6, case4_part4
	addi $t7, $t7, 2 # add 4 1 bits to 
	j count_bits
case4_part4: # check if it equals to bit 4
	li $t6, '4'
	bne $t5, $t6, case3_part4
	addi $t7, $t7, 1 # add 1 1 bits to 
	j count_bits
case3_part4: # check if it equals to bit 3
	li $t6, '3'
	bne $t5, $t6, case2_part4
	addi $t7, $t7, 2 # add 2 1 bits to 
	j count_bits
case2_part4: # check if it equals to bit 2
	li $t6, '2'
	bne $t5, $t6, case1_part4
	addi $t7, $t7, 1 # add 1 1 bits to 
	j count_bits
case1_part4: # check if it equals to bit 1
	li $t6, '1'
	bne $t5, $t6, case0_part4
	addi $t7, $t7, 1 # add 1 1 bits to 
	j count_bits
case0_part4: # check if it equals to bit 0
	li $t6, '0'
	addi $t7, $t7, 0 # add 1 1 bits to 
	j count_bits	
	
count_bits: # jumps back to the top of the while loop
	addi $s2, $s2, 1
	addi $t3, $t3, 1
	j while_part4
	
printCount: # prints the total number of 1 bits seen
	li  $v0, 1 
    	add $a0, $t7, $0
    	syscall
    	j TerminateProgram

##########        Part 5       ###########

Part5a: # getting the 8 bit exponent from the entire bit 
	li $t2, 'X'
	bne $s3, $t2, Part5b
	sll $s5, $s4, 1
	srl $s5, $s5, 24
	addi $s5, $s5, -127
	li  $v0, 1 
    	move $a0, $s5
    	syscall
    	j TerminateProgram
    	
Part5b: # getting the mantissa 
	li $t2, 'M'
	bne $s3, $t2, TerminateProgram
	sll $s5, $s4, 9
	li  $v0, 1 
    	move $a0, $s5
    	li $v0, 4 
	la $a0, Decimal
	syscall
    	li $v0, 35
    	move $a0, $s5
    	syscall

##########        Terminate Program       ###########

TerminateProgram:
	li $v0, 10
	syscall
	
	


    	
	
	
	
	




	

	
	
	
		
	
	

	
	
	



	

	
	
	
	
	
	
	
	
	
	
	
