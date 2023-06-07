	.global main
	.data
buf:	.space	100

	.text
main:
	li	a7, 8
	la 	a0, buf
	li	a1, 100
	ecall
	
	la 	t0, buf
	la 	t1, buf
	li	t4, '9'
	li	t5, '0'
	
len:
	lb	t3, (t1)
	beqz	t3, loop
	addi 	t1, t1, 1
	b 	len
loop:
	lb 	t6, (t0)
	blt	t1, t0, end
	bgt	t6, t4, increment
	blt	t6, t5, increment
loop2:
	addi 	t1, t1, -1
	blt	t1, t0, end
	lb 	t3, (t1)
	bgt	t3, t4, loop2
	blt	t3, t5, loop2
	sb	t6, (t1)
	sb 	t3, (t0)
increment:
	addi 	t0, t0, 1
	b 	loop
end:
	li	a7, 4
	ecall
	li 	a7, 10
	ecall
	
	
	