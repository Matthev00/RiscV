#==========================================================
#author:
#date:
#description: RISK-V - function modyfying the input string
#		Riversing the string
#		Return length of the string 
#==========================================================

.data
test_case_01: .asciz "\nWind On The Hill\n"


test_begin:		.asciz "\n>>>"
test_end:		.asciz "<<<\n"

input: .space 80
prompt: .asciz "\nInput string: "
msg1: .asciz "\nConverted string: "



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
	
.section .rodata
len_input: .-input
.text
	
#reverse function call
	la a0, input
	jal reverse
	
#return length

	li a7, 1
	la a0, len_input
	ecall
	
#print reversed string
	li a7, 4
	la a0, msg1
	ecall
	
	li a7, 4
	la a0, input
	ecall
	
exit:
	li a7, 10
	ecall
	


reverse:
	get_length:
		lb t1, (a0)
		beq t1, zero, reverse_string
		addi t0, t0, 1
		addi a0, a0, 1
		j get_length
	reverse_string:
		mv t1, zero
		mv t2, zero
		mv t3, zero
	
		la a0, input #address of string
		mv a2, t0 #str length
		add t1, a0, a2 # last position of the string (null)
		addi t1, t1, -1 #last char of the string
		loop:
			lb t2, (a0) #position of first char
			lb t3, (t1) #position of last char
			ble t1, a0, reverse_exit #exit if we are in the middle
			sb t3, (a0)
			sb t2, (t1)
			addi a0, a0, 1
			addi t1, t1, -1
			j loop
		
reverse_exit:
	mv a0, t0
	addi a0, a0, -1 #loose enter on the begining as a char
	jr ra		
		
	