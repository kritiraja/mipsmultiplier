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
	err1:	.asciiz "Do not enter same number as computer\n"
	corr:	.asciiz " is the final result of multiplication\n"
	n:	.asciiz "\n"
.text
.globl movevalidatecomp
movevalidatecomp:
	la $a0, n		  # load address of newline into $a0
	li $v0, 4		  # service call: print string
	syscall			  # run system call
	
	mul $t2, $t1, $t3	  # multiply user input with computer generated number
	move $a0, $t2		  # $a0 = $t2
	li $v0, 1		  # service call: print integer
	syscall			  # run system call
	
	la $a0, corr		  # load address of corr into $a0
	li $v0, 4		  # service call: print corr
	syscall			  # run system call
	
	

	jr $ra			  # jump to return address
