#=================================================
# author:     Natalia Pieczko
#date:        22.03.2023
#description: RISC-V - function modifying the input string
# 		Changing capital letters into '*' symbol
# 			return number of changed symbols
#=================================================
.data
test_case_01: .asciz "\nWind On The Hill\n"

input: .space 80
prompt: "\nInput string: "
msg1: "\nConverted string: "

.text
main:
#print prompt
	li a7, 4
	la a0, prompt
	ecall
	
#input string
	li a7, 8
	li a1, 80
	la a0, input
	ecall

#print string
	li a7, 4
	la a0, input
	ecall
	
#modify string function calll
	la a0, input
	jal modify_string
	
#return number of changed symbols
	li a7, 1
	ecall

#print output prompt
	li a7, 4
	la a0, msg1
	ecall
	
#print modified string
	li a7, 4
	la a0, input
	ecall
	
exit:
	li a7, 10
	ecall
	
#functions
modify_string:
	mv t0, zero
	li t2, '*'
	li t3, 'A'
	li t4, 'Z'
modify_string_loop:
	lb t1, (a0)
	beq t1, zero, modify_string_exit
	addi a0, a0, 1
	bgt t1, t3, modify_string_loop
	blt t1, t4, modify_string_loop
	addi t0, t0, 1
	sb t2, -1(a0)
	j modify_string_loop
modify_string_exit:
	mv a0, t0
	jr ra
