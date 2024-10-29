.globl main 
.data
    prompt:       .asciiz "Please enter an integer (0-15): "
    output:       .asciiz "The hexadecimal representation is: "
    hexLookup:    .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
    error:        .asciiz "Invalid input. Please enter a number between 0 and 15.\n"

.text
main:
    li $v0, 4 # system call print
    la $a0, prompt # load the address of the prompt to the argument register
    syscall

    li $v0, 5 # system call read int
    syscall
    move $t0, $v0 # move $v0 to $t0

    blt $t0, 0, invalid # branch to see if it's less than 0, if so send to error function
    bgt $t0, 15, invalid # branch to see if it's greater than 15, if so send to error function

    la $t1, hexLookup # load the adress of the hex character into $t1
    move $t2, $t0 # move $t0 to $t2
    add $t2, $t1, $t2 # add $t1 and $t2
    lb $t3, 0($t2) # load byte from memory to $t3

    li $v0, 4 # system call print
    la $a0, output # argument for the output
    syscall

    li $v0, 11 # system call print char
    move $a0, $t3 # move the corresponding hex to the argument register
    syscall

    li $v0, 10 # system call exit
    syscall

invalid:
    li $v0, 4 # system call print
    la $a0, error # print defined error message
    syscall

    j main # jump to main to allow re-input
