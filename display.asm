#	CS2340 Term Project
#
#	Author: Kriti Raja
#	Date: 04/15/2025
#	Location: UTD
#	Description: board display

.include "Syscalls.asm"

.data
	display: .asciiz "_____________________________________\n|  1  |  2  |  3  |  4  |  5  |  6  |\n_____________________________________\n|  7  |  8  |  9  |  10 |  12 |  14 |\n_____________________________________\n|  15 |  16 |  18 |  20 |  21 |  24 |\n_____________________________________\n|  25 |  27 |  28 |  30 |  32 |  35 |\n_____________________________________\n|  36 |  40 |  42 |  45 |  48 |  49 |\n_____________________________________\n|  54 |  56 |  63 |  64 |  72 |  81 |\n_____________________________________\n "
	
.text
.globl boarddisplay
boarddisplay:
	la $a0, display		# load address of display into $a0
	li $v0, SysPrintString # service call: print string
	syscall			# run system call
	move $t6, $a0		# $t6 = $a0
	jr $ra			# jump to return address
