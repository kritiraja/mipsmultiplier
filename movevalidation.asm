#	CS2340 Term Project
#
#	Author: Kriti Raja
#	Date: 04/15/2025
#	Location: UTD
#	Description: move validation

.include "Syscalls.asm"

.data
	X:	.space  256
	C: 	.asciiz "O"
	P:	.asciiz "X"
	err1:	.asciiz "Enter a number between 1 and 9"
	corr:	.asciiz " is the final result of multiplication\n"
.text
.globl movevalidate

movevalidate:
	addi $sp, $sp, -12       # move stack pointer down by 20
    	sw $s2, 0($sp)            # store return address in stack
    	sw $t3, 4($sp)            # store saved register in stack
	li $t3, 1            # $t3 = 1 (lower bound)
    	blt $t1, $t3, invalid_move  # if $t1 < 1, invalid move
    
   	li $t3, 9            # $t3 = 9 (upper bound)
    	bgt $t1, $t3, invalid_move  # if $t1 > 9, invalid move
    	
	
	mul $t2, $t1, $t0	  # multiply user input with computer generated number
	move $a0, $t2		  # $a0 = $t2
	li $v0, 1		  # service call: print integer
	syscall			  # run system call
	
	la $a0, corr		  # load address of corr into $a0
	li $v0, 4		  # service call: print corr
	syscall			  # run system call
	
	li $a0, 50	      	  # load 200 into $a0 for pitch of volume output
	li $a3, 127		  # load 127 into $a0 for volume of sound ouput
	li $a1, 500		  # load 500 into $a1 for length of sound
	li $v0, 31		  # syscall code for MIDI out
	syscall			  # run system call 
	
	lw $s2, 0($sp)           # store return address in stack
    	lw $s3, 4($sp)           # store saved register in stack
    	addi $sp, $sp, 12        # move stack pointer up by 12

	jr $ra			  # jump to return address

invalid_move:
	
	la $a0, err1		  # load address of err1 message into $a0
	li $v0, SysPrintString   # service call: print string
	syscall			  # run service call
	li $a0, 20	      	  # load 200 into $a0 for pitch of volume output
	li $a3, 200		  # load 127 into $a0 for volume of sound ouput
	li $a1, 1000		  # load 500 into $a1 for length of sound
	li $v0, 31		  # syscall code for MIDI out
	syscall			  # run service call
	lw $s2, 0($sp)           # store return address in stack
    	lw $t3, 4($sp)           # store saved register in stack
   	addi $sp, $sp, 12        # move stack pointer up by 12
   	
   	li $v0, -1 # flag to show that invalid move was made
   	jr $ra			  # jump to return address
   	
