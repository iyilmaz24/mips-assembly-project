.data

prompt_dec: .asciiz "Please enter a decimal number: "
prompt_seq: .asciiz "Please enter a number for the length of the sequence: "
prompt_sum: .asciiz "The sum of the sequence is: "
newline: .asciiz "\n"

.text
.globl main

main: 
    li $v0, 4
    la $a0, prompt_dec # get decimal number
    syscall

	li $v0, 5            
	syscall   
	move $t1,$v0  # save decimal number

    li $v0, 4
    la $a0, newline # print newline
    syscall  

    li $v0, 4
    la $a0, prompt_seq # get sequence length
    syscall      

	li $v0, 5            
	syscall   
	move $t2,$v0  # save sequence length

    li $v0, 4
    la $a0, newline # print newline
    syscall

    li $t3, 0 # loop iteration
    li $t4, 0 # total sum
    li $t5, 0 # current number

loop_start: 
    bge $t3, $t2, loop_end # if loop iteration >= sequence length, end loop

    add $t5, $t1, $t3 # current number
    add $t4, $t4, $t5 # total sum

    li $v0, 1
    move $a0, $t5 # print current number
    syscall

    li $v0, 4
    la $a0, newline # print newline
    syscall

    addi $t3, $t3, 1 # increment loop iteration
    j loop_start

loop_end:
    li $v0, 4
    la $a0, prompt_sum # provide context for total sum
    syscall

    li $v0, 1
    move $a0, $t4 # print total sum
    syscall

    li $v0, 10 # exit program
    syscall
