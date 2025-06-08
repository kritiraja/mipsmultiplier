
#	CS2340 Term Project
#
#	Author: Kriti Raja
#	Date: 04/25/2025
#	Location: UTD
#	Description: check for horizontal winning pattern

.include "Syscalls.asm"
.data
    x_win_msg: .asciiz "\nYou have won the game!\n"
    o_win_msg: .asciiz "\nComputer has won the game!\n"
    no_win_msg: .asciiz "\nNo winner yet, continue playing.\n"

.text
.globl wincheck
wincheck:
    addi $sp, $sp, -32        # move stack pointer down by 20
    sw $ra, 0($sp)            # store return address in stack
    sw $s0, 4($sp)            # store saved register in stack
    sw $s1, 8($sp)            # store saved register in stack
    sw $s2, 12($sp)           # store saved register in stack
    sw $s3, 16($sp)           # store saved register in stack
    sw $t0, 20($sp)           # store register in stack
    sw $t1, 24($sp)           # store register in stack
    sw $t2, 28($sp)           # store register in stack
    move $s0, $t6             # $s0 = address of display string
    li $s6, 0                 # flag $s6 = 0 for no winner yet
    li $s1, 0                 # $s1 = 0 ($s1 is the row counter)
    
row:
    li $t0, 38                # $t1 = 38 (number of characters in a row)
    mul $t0, $t0, $s1         # $t0 = row number x 38
    add $t0, $s0, $t0         # $t0 = address of start of current row
    addi $t0, $t0, 2          # skip first 2 chars 
    li $s2, 0                 # $s2 = 0 ($s2 is the onsecutive XX counter)
    li $s3, 0                 # $s3 = 0 ($s3 is the position in row)
    
xx_check:
    beq $s3, 6, xx_check_done # if $s3 == 6 (all positions checked) go to xx_check_done
    lb $t1, 0($t0)            # load first character into $t1
    lb $t2, 1($t0)            # load second character into $t2
    li $t3, 'X'			 # load character "X" into $t3
    bne $t1, $t3, xx_not_match # check if first character == "X"
    bne $t2, $t3, xx_not_match # check if second character == "X"
    addi $s2, $s2, 1           # add 1 to $s2 (consecutive XX counter)
    j xx_check_next		# jump to check next xx
    
xx_not_match:
    li $s2, 0                 # reset consecutive XX counter to 0
    
xx_check_next:
    beq $s2, 4, xx_winfound  # 4 in a row found
    addi $t0, $t0, 6          # move to next position (each cell is 6 chars wide)
    addi $s3, $s3, 1          # add 1 to $s3 (position counter)
    j xx_check			# jump to xx_check
    
xx_check_done:
    li $s2, 0                 # $s2 = 0 ($s2 is the onsecutive OO counter)
    li $s3, 0                 # $s3 = 0 ($s3 is the position in row)
    li $t0, 38                # $t1 = 38 (number of characters in a row)
    mul $t0, $t0, $s1         # $t0 = row number x 38
    add $t0, $s0, $t0         # $t0 = address of start of current row
    addi $t0, $t0, 2          # skip first 2 chars 
    
oo_check:
    beq $s3, 6, oo_check_done # checked all 6 positions in the row
    lb $t1, 0($t0)            # load first character into $t1
    lb $t2, 1($t0)            # load second character into $t2
    li $t3, 'O'			# load character "O" into $t3
    bne $t1, $t3, oo_not_match # check if first character == "O"
    bne $t2, $t3, oo_not_match # check if first character == "O"
    addi $s2, $s2, 1          # add 1 to $s2 (consecutive OO counter)
    j oo_check_next		# jump to oo_check_next 
    
oo_not_match:
    li $s2, 0                 # reset consecutive counter
    
oo_check_next:
    beq $s2, 4, oo_winfound  # 4 in a row found
    addi $t0, $t0, 6          # move to next position (each cell is 6 chars wide)
    addi $s3, $s3, 1          # add 1 to $s3 (position counter)
    j oo_check			# jump to oo_check
    
oo_check_done:
    addi $s1, $s1, 1          # increment row counter
    blt $s1, 12, row      	# if not all rows are checked, go to row
    j wincheckdone		# jump to wincheckdone
    
xx_winfound:
    li $a0, 100	      	  # load 200 into $a0 for pitch of volume output
    li $a3, 200		  # load 127 into $a0 for volume of sound ouput
    li $a1, 1000		  # load 500 into $a1 for length of sound
    li $v0, 31		  # syscall code for MIDI out
    syscall			  # run service call
    li $a0, 150	      	  # load 200 into $a0 for pitch of volume output
    li $a3, 200		  # load 127 into $a0 for volume of sound ouput
    li $a1, 1400		  # load 500 into $a1 for length of sound
    li $v0, 31		  # syscall code for MIDI out
    syscall			  # run service call
    la $a0, x_win_msg		# load address of x win msg into $a0
    li $v0, SysPrintString     # service call: print string
    syscall			# run system call
    li $s6, 1                 # XX wins
    j wincheckdone		# jump to wincheckdone
    
oo_winfound:
    li $a0, 20	      	  # load 200 into $a0 for pitch of volume output
    li $a3, 200		  # load 127 into $a0 for volume of sound ouput
    li $a1, 1000		  # load 500 into $a1 for length of sound
    li $v0, 31		  # syscall code for MIDI out
    syscall		# run service call
    la $a0, o_win_msg  	# load address of o win msg into $a0
    li $v0, SysPrintString     # service call: print string
    syscall			# run system call
    li $s6, 2                 # OO wins
    j wincheckdone	# jump to wincheckdone
    
wincheckdone:
    lw $ra, 0($sp)            # Restore return address
    lw $s0, 4($sp)            # Restore $s0
    lw $s1, 8($sp)            # Restore $s1
    lw $s2, 12($sp)           # Restore $s2
    lw $s3, 16($sp)           # Restore $s3
    lw $t0, 20($sp)           # Restore $t0
    lw $t1, 24($sp)           # Restore $t1
    lw $t2, 28($sp)           # Restore $t2
    addi $sp, $sp, 32         # Restore stack pointer
    jr $ra                    # jump to return address
