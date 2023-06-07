	.global main
	.data
str1:	.asciz "Mateuszxxxxxxxxxxxx\n"
str2: 	.asciz "Mtsx"

 	.text
main:
	la 	a0, str1
	la 	a2, str2
	addi 	t0, a0, 0 #pisz¹cy
	addi 	t5, a0, 0 #czytaj¹cy
	addi 	t1, a2, 0	
loop:
	addi 	t1, a2, 0
	lbu	t2,(t5)
	sb 	t2,(t0)
	addi 	t5, t5, 1
	beqz 	t2, endl
loop2:
	lbu 	t3, (t1)
	beqz	t3, increment
	beq	t3, t2, loop
	addi 	t1, t1, 1
	b 	loop2
increment:
	addi 	t0, t0, 1	
	b 	loop
endl:
	sub	a1, t0, a0
end:
	li 	a7, 4
	ecall
	addi 	a0, a1, -1
	li 	a7, 1
	ecall
	li	a7, 10
	ecall
