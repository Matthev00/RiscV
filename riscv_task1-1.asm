#===================================================
#author:  Natalia Pieczko 
#date:   24.03.1023
#description: RISC-V function modifying string
#		removes all chars besides digits 
#		returns length of modified string
#===================================================
	.data
test_case_01: .asciz "7*8=56\n"

msg1: .asciz "\nSource> "
msg2: .asciz "\nResult> "
	.text
main:
#print string
	li a7, 4
	la a0, msg1
	ecall
	
	li a7, 4
	la a0, test_case_01
	ecall
	
#function call
	la a0, test_case_01
	jal remove
	
	li a7, 1
	ecall

	li a7, 4
	la a0, msg2
	ecall
	
	li a7, 4
	la a0, test_case_01
	ecall
	

	
exit:
	li a7, 10
	ecall
	
remove: 
	mv t0, a0
	mv t1, a0
	li t2, '0'
	li t3, '9'
	
remove_loop:
	lb t4, (t0)
	addi t0, t0, 1
	beqz t4, end_loop
	bgt t4, t3, remove_loop
	blt t4, t2, remove_loop
	
save_char: 
	sb t4, (t1)
	addi t1, t1, 1
	j remove_loop
end_loop:
	sb zero, (t1) #dodawanie null na koniec wyrazu
	sub t5, t1, a0 
	mv a0, t5
	jr ra