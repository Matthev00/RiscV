#=====================================================
#author: Natalia Pieczko
#date: 24.03.2023
#description: RISC-V - function modyfiying input string
#			deleting small letters
#			return the length of new word
#======================================================
	.data
test_case_01: .asciz "WindOnTheHillH"

input: .space 80
prompt: .asciz "\nInput string: "
ans_msg: .asciz "\nConverted string: "

	.text
#print string
	li a7, 4
	la a0, prompt
	ecall
	li a7, 8
	li a1, 80
	la a0, input
	ecall
	
#call function
	la a0, input
	jal remove

#return length
	li a7, 1
	ecall

#display new string
	la a0, ans_msg
	li a7, 4
	ecall
	
	la a0, input
	ecall
	
exit:
	li a7, 10
	ecall
	
	
remove:
	la t0, input
	la t1, input
	li t2, 'a'
	li t3, 'z'
remove_loop:
	lb t4, (t0)
	addi t0, t0, 1
	beqz t4, end_loop
	blt t4, t2, save_char
	bgt t4, t3, save_char
	b remove_loop
save_char:
	sb t4, (t1)
	addi t1, t1, 1
	j remove_loop
end_loop:
	sb zero, (t1) #dodawanie null na koncu wyrazu
	addi t1, t1, -1 #usuwanie z dlugosci znaku null
	sub t5, t1, a0
	mv a0, t5
	jr ra
	