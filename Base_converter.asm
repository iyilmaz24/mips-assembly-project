.data

prompt_start: .asciiz "Please enter an integer: "
prompt_restart: .asciiz "Would you like to convert another integer? (0 or 1): "
prompt_binary: .asciiz "The binary is: "
prompt_hexadecimal: .asciiz "The hexadecimal is: "
newline: .asciiz "\n"
binary_str: .space 33
hex_str: .space 9
hexLookup:  .byte '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'
hex_prefix: .asciiz "0x"

.text
.globl main

main: 
    li $t1, 1 # loop continue - 1 = yes, 0 = no
    li $t2, 0 # for loop comparison
    li $t3, 0 # user input number
    # $t4 = user input number
    # $t5 = binary number
    # $t6 = hexadecimal number

loop_start:
    li $v0, 4
    la $a0, prompt_start # get integer from user
    syscall

	li $v0, 5            
	syscall   
	move $t4,$v0  # save integer to from user

    li $v0, 4
    la $a0, newline # print newline
    syscall  
    move $t5, $t4 

    la $t7, binary_str
    li $t8, 0  
    li $s0, 31

    addi $sp, $sp, -4 # adds to stack for jr
    sw $ra, 0($sp)
    jal convert_binary # jump & link to convert_binary

    lw $ra, 0($sp)
    addi $sp, $sp, 4

    # Print hexadecimal prompt
    li $v0, 4
    la $a0, prompt_hexadecimal    # print the prompt for hexadecimal
    syscall

    li $v0, 4
    la $a0, hex_prefix            # print hex prefix:
    syscall

    la $t6, hex_str               # load the address of hex_str
    jal convert_hex               # convert decimal to hexadecimal and print

    li $v0, 4 
    la $a0, newline               # prints a new line
    syscall

    li $v0, 4
    la $a0, prompt_restart # ask user if they want to convert another integer
    syscall

    li $v0, 5
    syscall
    move $t9, $v0 # save user input to $t9

    ble $t9, $t2, loop_end # if loop continue <= for loop comparison (int 0), end loop
    bgt $t9, $t1, loop_end # if user input is greater than 1 end the loop

    j loop_start

loop_end:
    li $v0, 10 # exit program
    syscall

# Decimal -> Binary

convert_binary:
    beq $t4, $zero, zero_edge_case # if the only integer input is 0, branch to the zero edge case
    move $t5, $t4
    la $t7, binary_str # load the address of binary_tsr
    li $t8, 0 
    li $s0, 31

convert_binary_loop:
    srlv $t0, $t5, $s0 # shift $t5 right by $s0 to LSB
    andi $t0, $t0, 1 # isolate by ANDing w/ 1

    beq $t8, $zero, check_first_one # branch if $t8 is 0, go to check_first_one
    j store_bit # otherwise it's 1, jump to store_bit

check_first_one:
    beq $t0, $zero, skip_bit # skip if 0
    li $t8, 1 # else if it's 1, set $t8 to 1

store_bit:
    addi $t0, $t0, '0' # convert the bit value to '0' or '1', 0 = 48, 1 = 49 in ASCII
    sb $t0, 0($t7) # store it in the current address at $t7
    addi $t7, $t7, 1 # move to next bit

skip_bit:
    addi $s0, $s0, -1 # decrease counter
    bgez $s0, convert_binary_loop # branch back to loop if greater than or equal to 0

binary_done:
    li $t0, 0 # null terminator
    sb $t0, 0($t7) # store null terminator 

    li $v0, 4 # print prompt
    la $a0, prompt_binary 
    syscall

    li $v0, 4
    la $a0, binary_str # print the binary string
    syscall

    li $v0, 4 
    la $a0, newline  # prints a new line
    syscall

    jr $ra 

zero_edge_case:
    li $t0, '0'
    sb $t0, 0($t7)
    addi $t7, $t7, 1
    j binary_done


# Decimal -> Hexadecimal

convert_hex:
    move $t0, $t4                # copy the input num to $t0
    beqz $t0, zero_hex_case            
    li $t3, 0                    # count for the number of hex digits (size of str)
    la $t6, hex_str              # load the address of hex_str

convert_hex_loop:
    beqz $t0, reverse_start      # If quotient is zero, we're done with conversion

    li $t4, 16                   # load divisor, 16
    div $t0, $t4                 # divide by 16
    mfhi $t5                     # $t5 = remainder
    mflo $t0                     # $t0 = $t0 (quotient) / 16

    lb $t8, hexLookup($t5)       # t8 = hex value of remainder
    sb $t8, 0($t6)               # store the hex character in hex_str
    addi $t6, $t6, 1             # increment hex_str[i]
    addi $t3, $t3, 1             # increment hex digit counter
    j convert_hex_loop           # repeat the loop

reverse_start:
    # Prepare for printing hex string in reverse:
    sb $zero, 0($t6)              # null terminate the hex string
    la $t6, hex_str               # t6 = address of hex_str
    addi $t7, $t3, -1             # $t7 = end index (size (t3) - 1)    

reverse_print_loop:
    # Print hex_str[i]:
    add $t0, $t6, $t7              # $t0 = address of hex_str[i]
    lb $a0, 0($t0)                 # load hex_str[i] into $a0
    li $v0, 11                     # 11 = print character
    syscall                     

    addi $t7, $t7, -1              # i = i - 1

    bgez $t7, reverse_print_loop   # continue loop if index is >= 0

    jr $ra                         # return to caller
                            
zero_hex_case:
    li $v0, 11               # 11 = print character syscall
    li $a0, 48               # 48 = ASCII code for '0'
    syscall                  # print "0"
    jr $ra                   # return to caller