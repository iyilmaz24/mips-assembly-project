.data

prompt_start: .asciiz "Please enter an integer: "
prompt_restart: .asciiz "Would you like to convert another integer? (0 or 1): "
prompt_binary: .asciiz "The binary is: "
prompt_hexadecimal: .asciiz "The hexadecimal is: "
newline: .asciiz "\n"

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



    # TODO: convert $t4 to binary and save to $t5, then print prompt + print $t5 binary + print newline


    # TODO: convert $t4 to hexadecimal and save to $t6, then print prompt + print $t6 hexadecimal + print newline



    li $v0, 4
    la $a0, prompt_restart # ask user if they want to convert another integer
    syscall

    li $v0, 5
    syscall
    move $t1, $v0 # save user input to $t1

    ble $t1, $t2, loop_end # if loop continue <= for loop comparison (int 0), end loop
    j loop_start

loop_end:
    li $v0, 10 # exit program
    syscall
