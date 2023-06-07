	.global main
	.data
prompt: .asciz "Enter first str\n"
prompt2:.asciz "\nEnter second str\n"
header:	.asciz "\noutput\n"
buf1:	.space	100
buf2:	.space 100

	.text
main:
	li 	a7, 4
	la 	a0, prompt
	ecall
	
	li	a7, 8
	la 	a0, buf1
	li	a1, 100
	ecall
	
	li 	a7, 4
	la 	a0, prompt2
	ecall
	
	li	a7, 8
	la 	a0, buf2
	li	a1, 100
	ecall
	
	la 	t0, buf1
	la	t1, buf2
	la 	t5, buf1

loop:
	lb	t2, (t0)
	sb	t2, (t5)
	beqz	t2, end
loop2:
	lbu	t3, (t1)
	beqz	t3, increment
	beq	t3, t2, remove
	addi	t1, t1, 1
	b	loop2
increment:
	addi 	t0, t0, 1
	addi 	t5, t5, 1
	la 	t1, buf2
	b 	loop
remove:
	addi 	t0, t0, 1
	la 	t1, buf2
	b 	loop
end: 
	li 	a7, 4
	la 	a0, header
	ecall
	
	li 	a7, 4
	la 	a0, buf1
	ecall
	li 	a7, 10
	ecall
	
	
	
	
	
	  
