#	CS2340 Term Project
#
#	Author: Kriti Raja
#	Date: 04/29/2025
#	Location: UTD
#	Description: check for vertical winning pattern

.include "Syscalls.asm"
.data
    x_win_msg: .asciiz "\nYou have won the game!\n"
    o_win_msg: .asciiz "\nComputer has won the game!\n"
    no_win_msg: .asciiz "\nNo winner yet, continue playing.\n"

.text
.globl verticalwincheck
verticalwincheck:
    addi $sp, $sp, -32        # move stack pointer down by 32
    sw $ra, 0($sp)            # store return address in stack
    sw $s0, 4($sp)            # store saved register in stack
    sw $s1, 8($sp)            # store saved register in stack
    sw $s2, 12($sp)           # store saved register in stack
    sw $s3, 16($sp)           # store saved register in stack
    sw $t0, 20($sp)           # store register in stack
    sw $t1, 24($sp)           # store register in stack
    sw $t2, 28($sp)           # store register in stack
    move $s0, $t6             # $s0 = address of display string
    li $s6, 0                 # Default: no winner
    li $s1, 0                 # column counter
    
column_loop:
    li $t0, 6                 # Each cell is 6 characters wide
    mul $t0, $t0, $s1         # $t0 = column * 6
    add $t0, $s0, $t0         # $t0 = address of start of current column
    addi $t0, $t0, 2          # skip first 2 chars
    
    li $t4, 38                # Skip to the second row (first actual game row)
    add $t0, $t0, $t4         # Now at the first game row
    li $s2, 0                 # consecutive XX counter
    li $s3, 0                 # position in column (row index for game rows only)
    li $s4, 0                 # actual row index including grid lines
    
xx_check_loop:
    beq $s3, 6, xx_check_done # Checked all 6 game positions in the column
    lb $t1, 0($t0)            # Load first character
    lb $t2, 1($t0)            # Load second character
    li $t3, 'X'			# LOad "x" into $t3
    bne $t1, $t3, xx_not_match	# if $T1 != $T3 go to xx_notmatch
    bne $t2, $t3, xx_not_match# if $T2 != $T3 go to xx_notmatch
    addi $s2, $s2, 1          # Increment consecutive counter
    j xx_check_next		# jump to xx_check_next
    
xx_not_match:
    li $s2, 0                 # Reset consecutive counter
    
xx_check_next:
    beq $s2, 4, xx_win_found  # 4 in a row found
    li $t4, 38                # Each row is 38 characters (37 chars + newline)
    add $t0, $t0, $t4         # Skip the grid line row
    add $t0, $t0, $t4         # Move to next game row in the same column
    addi $s3, $s3, 1          # Increment game row position counter
    addi $s4, $s4, 2          # Increment actual row counter by 2 (skipped grid line)
    j xx_check_loop	       # jump to xx_check_loop
    
xx_check_done:
    li $s2, 0                 # consecutive OO counter
    li $s3, 0                 # position in column (row index for game rows only)
    li $s4, 0                 # actual row index including grid lines
    li $t0, 6                 # Each cell is 6 characters wide
    mul $t0, $t0, $s1         # $t0 = column * 6
    add $t0, $s0, $t0         # $t0 = address of start of current column
    addi $t0, $t0, 2          # Skip first 2 chars
    
oo_check_loop:
    beq $s3, 6, oo_check_done # Checked all 6 game positions in the column
    lb $t1, 0($t0)            # Load first character
    lb $t2, 1($t0)            # Load second character
    li $t3, 'O'			# load character "O" into $t3	
    bne $t1, $t3, oo_not_match	# if $T1 != "O" go to oo_notmatch
    bne $t2, $t3, oo_not_match# if $T2 != "O" go to oo_notmatch
    addi $s2, $s2, 1          # Increment consecutive counter
    j oo_check_next		# jump to oo_check_next
    
oo_not_match:
    li $s2, 0                 # Reset consecutive counter
    
oo_check_next:
    beq $s2, 4, oo_win_found  # 4 in a row found
    li $t4, 38                # Each row is 38 characters (37 chars + newline)
    add $t0, $t0, $t4         # Skip the grid line row
    add $t0, $t0, $t4         # Move to next game row in the same column
    addi $s3, $s3, 1          # Increment game row position counter
    addi $s4, $s4, 2          # Increment actual row counter by 2 (skipped grid line)
    j oo_check_loop		# jump to oo_check_loop
    
oo_check_done:
    addi $s1, $s1, 1          # Increment column counter
    blt $s1, 6, column_loop   # continue if $s1 <6
    j wincheckdone		# jump to wincheckdone
    
xx_win_found:
    li $a0, 100               # load 100 into $a0 for pitch of volume output
    li $a3, 200               # load 200 into $a3 for volume of sound output
    li $a1, 1000              # load 1000 into $a1 for length of sound
    li $v0, 31                # syscall code for MIDI out
    syscall
    li $a0, 150               # load 150 into $a0 for pitch of volume output
    li $a3, 200               # load 200 into $a3 for volume of sound output
    li $a1, 1400              # load 1400 into $a1 for length of sound
    li $v0, 31                # syscall code for MIDI out
    syscall	
    la $a0, x_win_msg         # load address of x win msg into $a0
    li $v0, SysPrintString    # service call: print string
    syscall                   # run system call
    li $s6, 1                 # XX wins
    j wincheckdone
    
oo_win_found:
    li $a0, 20                # load 20 into $a0 for pitch of volume output
    li $a3, 200               # load 200 into $a3 for volume of sound output
    li $a1, 1000              # load 1000 into $a1 for length of sound
    li $v0, 31                # syscall code for MIDI out
    syscall
    la $a0, o_win_msg         # load address of o win msg into $a0
    li $v0, SysPrintString    # service call: print string
    syscall                   # run system call
    li $s6, 2                 # OO wins
    j wincheckdone	       # jump to wincheckdone
    
wincheckdone:
    lw $ra, 0($sp)            # restore return address
    lw $s0, 4($sp)            # restore $s0
    lw $s1, 8($sp)            # restore $s1
    lw $s2, 12($sp)           # restore $s2
    lw $s3, 16($sp)           # restore $s3
    lw $t0, 20($sp)	       # restore $t0
    lw $t1, 24($sp)	       # restore $t1
    lw $t2, 28($sp)		# restore $t2
    addi $sp, $sp, 32         # Restore stack pointer
    
    jr $ra                    # jump to return address