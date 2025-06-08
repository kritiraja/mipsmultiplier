#	CS2340 Term Project
#
#	Author: Kriti Raja
#	Date: 04/15/2025
#	Location: UTD
#	Description: edit board (computer's turn)

.include "Syscalls.asm"

.data
	X: 	.asciiz "O "
	N:	.asciiz " "
	msgnotfound: .asciiz "Number already chosen. Choose another number\n"
.text

.globl editboardcomp

editboardcomp:
    addi $sp, $sp, -12       # move stack pointer down by 20
    sw $s2, 0($sp)            # store return address in stack
    sw $s3, 4($sp)            # store saved register in stack
    
    move $t9, $t6            # $t9 = $t6 (address of display)
    move $s0, $t1		# preserve value of user input
    li $t3, 0                # $t3 = 0 (position of character in string)
   
search:
    lb $t1, 0($t9)           # load byte from string to $t1
    beq $t1, $zero, notfound # if byte == null character go to not found
    
    li $s5, 10		      # $s5 = 10
    div $t2, $s5             # divide $t2 by $s5 (10)
    mflo $t7                 # $t7 = quotient (tens digit)
    mfhi $t8                 # $t8 = remainder (ones digit)
    
    addi $t8, $t8, 48        # add 48 to convert to ASCII character
    
    beq $t7, $zero, check_single_digit	# if tens digit == 0, go to single digit number check
    
    addi $t7, $t7, 48        # add 48 to convert to ASCII character
    
    beq $t1, $t7, check_double_digit	#check if pos is the start of double digit number
    j next_position
    
check_single_digit:
    lb $s3, 1($t9)
    la $t4, N	      # load address of X into $t4
    lb $t5, 0($t4)	      # load byte "X" into $t5
    bne $t5, $s3, next_position
    
    lb $s3, -1($t9)
    la $t4, N	      # load address of X into $t4
    lb $t5, 0($t4)	      # load byte "X" into $t5
    bne $t5, $s3, next_position
    
    beq $t1, $t8, found
    
check_double_digit:
    lb $t4, 1($t9)
    beq $t4, $zero, next_position  # If end of string, not a match
    beq $t4, $t8, found
    j next_position
    
next_position:
    addi $t9, $t9, 1         # add 1 to address of string to go to next byte
    addi $t3, $t3, 1         # add 1 to count
    j search                 # jump to search

    
found:
    la $t4, X		      # load address of X into $t4
    lb $t5, 0($t4)	      # load byte "X" into $t5
    add $t9, $t6, $t3	      # go to position in string
    
    beq $t7, $zero, foundsingle
    sb $t5, -1($t9)	      # store byte character "X" into string
    sb $t5, 0($t9)	      # store byte character "X" into string
    la $t4, N
    lb $t5, 0($t4)
    sb $t5, 1($t9)
    
    move $t9, $t6	      # $t9 == $t6
    j print_loop

foundsingle:

    sb $t5, -1($t9)	      # store byte character "X" into string
    sb $t5, 0($t9)	      # store byte character "X" into string
    move $t9, $t6	      # $t9 == $t6
    j print_loop

   
print_loop:
    lb $a0, 0($t9)           # load byte from string
    beqz $a0, done	      # if character == null terminator, go to done
   
    li $v0, 11               # service call: print character
    syscall                  # run system call
    
    addi $t9, $t9, 1         # add 1 to go to next byte of string
    j print_loop 
    
    j done                   # Jump to done
    
notfound:
    lw $s2, 0($sp)            # store return address in stack
    lw $s3, 4($sp)            # store saved register in stack
    addi $sp, $sp, 12       # move stack pointer up by 12
    la $a0, msgnotfound
    li $v0, SysPrintString
    syscall
    move $t1, $s0		# restore value of userinput
    li $v0, -1
    jr $ra
    
done:
    lw $s2, 0($sp)            # store return address in stack
    lw $s3, 4($sp)            # store saved register in stack
    addi $sp, $sp, 12       # move stack pointer up by 12
    move $t1, $s0		# restore value of userinput
    jr $ra
    
    
    
  
