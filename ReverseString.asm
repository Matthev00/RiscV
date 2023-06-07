	.global main
	.data
prompt: .asciz "Enter text:\n"
header: .asciz "\nOutput:\n"
buff1:	.space 100
buff2:	.space 100

	.text
main:
	li 	a7, 4
	la 	a0, prompt
	ecall
	
	li 	a7, 8
	la 	a0, buff1
	li 	a1, 100
	ecall

	la 	t0, buff1
	la 	t1, buff2
	li 	t3, 0

loop:
	lbu 	t4, (t0)
	beqz	t4, endOfString
	addi	t0, t0, 1
	addi	t3, t3, 1
	b	loop
endOfString:
	addi 	t0, t0, -1
loop2:
	sb  	t0, (t1)
	addi 	t1, t1, 1
	addi 	t3, t3, -1
	beqz 	t3, end
	addi 	t0, t0, -1
	b	loop2
end:
	li	t4, 0		
	sb	t4, (t1)
	
	li a7, 4
	la a0, header
	ecall
	
	li a7, 4
	la a0, buff2
	ecall
	
	li a7, 10
	ecall
	
	
	 

	