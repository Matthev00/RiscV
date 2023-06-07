	.global main
	.data
prompt:	.asciz	"Enter text:\n"
header:	.asciz	"\nOutput\n"
buff:	.space	100
	.text
main:	
	li 	a7, 4
	la 	a0, prompt
	ecall
	
	li 	a7, 8
	la 	a0, buff
	li 	a1, 100
	ecall
	
	la 	t0, buff
	li 	t1, 'a'
	li 	t2, 'z'
	li 	t3, 0x20
loop:	
	lb 	t4, (t0)
	beqz 	t4, end
	bgt 	t4, t2, skip
	blt 	t4, t1, skip
	sub 	t4, t4, t3
	sb 	t4, (t0)
skip:
	addi 	t0, t0, 1
	b 	loop
end:
	li	a7, 4
	la	a0, header
	ecall
	li	a7, 4
	la	a0, buff
	ecall
	li	a7, 10
	ecall
	
	
	