.data
clockPrompt: .asciiz "Please enter in a time: "
morningStr: .asciiz "It is morning"
noonStr: .asciiz "It is noon"
afternoonStr: .asciiz "It is afternoon"

.text
.globl main

main:
	li $v0,4               # 4 = print string
	la $a0,clockPrompt      
	syscall

	li $v0, 5              # 5 = read integer
	syscall   
	move $t1,$v0           # Copy time from input into $t1

	li $t2,1               # $t2 = 1 for comparisons
	
	# Check for morning
	sge $t3,$t1,$t2         # if time >= 1, $t3 = 1
	slti $t4,$t1,12         # if time < 12, $t4 = 1
	and $t5,$t4,$t3         # if both are true, $t5 = 1
	beq $t5,$t2,morning     # Branch to morning

	# Check for noon
	li $t3,12
	seq $t4,$t1,$t3         # if time == 12, $t4 = 1
	beq $t4,$t2,noon        # Branch to noon

	# Check for afternoon
	li $t3,13
	sge $t4,$t1,$t3         # if time >= 13
	slti $t5,$t1,25         # if time < 25
	and $t6,$t5,$t4         # if both are true, $t6 = 1
	beq $t6,$t2,afternoon   # Branch to afternoon

	# Exit program for else cases
	j exit

morning:
	li $v0,4               # 4 = print string
	la $a0,morningStr      
	syscall
	j exit
	
noon:
	li $v0,4      
	la $a0,noonStr
	syscall
	j exit
	
afternoon:
	li $v0,4               
	la $a0,afternoonStr
	syscall
	j exit
	
exit:
	li $v0,10
	syscall