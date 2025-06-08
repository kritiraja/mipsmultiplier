#	CS2340 Term Project
#
#	Author: Kriti Raja
#	Date: 04/15/2025
#	Location: UTD
#	Description: user input / welcome to the game

.include "Syscalls.asm"

.data
	welcome: .asciiz "Welcome to the multiplier game!\nYou are XX and Computer is OO \nForm four XXs in a row to win the game!\n"
	compturn: .asciiz "\nComputer's turn... Computer chose: "
	userturn: .asciiz "\nYour turn (Enter a digit from 1 to 9): "
	userturn2: .asciiz "Your choice was: "
	gameovermsg: .asciiz "The game is over. Thanks for playing!"
	
	
	
.text
.globl main
main:
	la $a0, welcome		# load address of display into $a0
	li $v0, SysPrintString # service call: print string
	syscall			# run system call
	
	
	jal boarddisplay	# jump and link to boarddisplay

	jal gameround		# jump and link to gameround (loop)
	
	la $a0, gameovermsg	# load address of game over message into $a0
	li $v0, SysPrintString # service call: print string
	syscall			# run system call
	
	
gameround:
	la $a0, compturn	# load address of compturn into $a0
	li $v0, SysPrintString	# service call: print string ("Computer's turn...")
	syscall			# run system call
	
	li $v0, 42		# service call: generate random integer
	li $a1, 9		# set upper bound (exclusive)
	syscall			# run system call
	addi $a0, $a0, 1	# add lower bound to shift range
	move $t0, $a0		# $t0 = $a0 (result of random generation)
	
	li $v0, SysPrintInt	# service call: print integer
	syscall			# run system call

again:	
	la $a0, userturn	# load address of userturn into $a0
	li $v0, SysPrintString	# service call: print string  ("Your turn...")
	syscall			# run system call
	
	li $v0, SysReadInt	# service call: read int from keyboard to $v0
	syscall			# run system call
	move $t1, $v0		# $t1 = $v0 (user input)
	
	jal movevalidate	# jump and link to movevalidate
	beq $v0, -1, again	# if invalid move, ask for user's input again
	
	jal editboard		# jump and link to editboard
	beq $v0, -1, again	# if invalid move, ask for user's input again
	
	jal wincheck		# jump and link to wincheck
	
	beq $s6, 2, done	# if $s6 == 2, go to done
	beq $s6, 1, done	# if $s6 == 1, go to done

	jal verticalwincheck	# jump and link to verticalwincheck
	beq $s6, 2, done	# if $s6 == 2, go to done
	beq $s6, 1, done	# if $s6 == 1, go to done
	#computer's turn after user's choice is updated into board

comptryagain:
	la $a0, userturn2	# load address of userturn2 into $a0
	li $v0, SysPrintString # service call: print string
	syscall			# run system call
	move $a0, $t1		# move user's old choice into $a0
	li $v0, SysPrintInt	# service call: print integer
	syscall			# run system call
	
	
	la $a0, compturn	# load address of compturn into $a0
	li $v0, SysPrintString	# service call: print string ("Computer's turn...")
	syscall			# run system call

compagain:
	li $v0, 42		# service call: generate random integer
	li $a1, 9		# set upper bound (exclusive)
	syscall			# run system call
	addi $a0, $a0, 1	# add lower bound to shift range
	move $t3, $a0		# $t0 = $a0 (result of random generation)
	beq $t3, $t0, compagain # if $t3 = $t0, go to compagain
	
	li $v0, SysPrintInt	# service call: print integer
	syscall			# run system call
	
	jal movevalidatecomp	# jump and link to movevalidate
	
	jal editboardcomp	# jump and link to editboardcomp
	
	beq $v0, -1, comptryagain	# if invalid move, ask for user's input again
	jal wincheck		# jump and link to wincheck
	beq $s6, 2, done	# if $s6 =- 2, go to done
	beq $s6, 1, done	# if $s6 == 1, go to done
	
	jal verticalwincheck	# jump and link to verticalwincheck
	beq $s6, 2, done	# if $s6 == 2, go to done
	beq $s6, 1, done	# if $s6 == 1, go to done
	
	jal gameround		# jump and link to gameround
	
	
done:
	li $v0, SysExit		# service call: exit system (SysCalls.asm)
	syscall			# run system call
	
