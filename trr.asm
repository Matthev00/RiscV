.globl main
.data
prompt:	.asciz "Input two strings: \n"
buf1:	.space 100
buf2:	.space 100
buf3:	.space 100
zero:	0
.text
main:
	li a7, 4
	la a0, prompt
	ecall
	li a7, 8
	la a0, buf1
	li a1, 100
	ecall
	li a7, 8
	la a0, buf2
	li a1, 100
	ecall
	la t0, buf1
	la t1, buf2
	li t5, 0x7f
loop1:
	lb t3, (t0)
	beqz t3, endloop
loop2:
	lb t4, (t1)
	beq t4, t3, remove
	b incrementfirst
remove:
	sb t5 ,(t1)
incrementfirst:
	addi t1, t1, 1
	lb t6, (t1)
	bnez t6, loop2
icrementsecond:
	la t1, buf2
	addi t0, t0, 1
	b loop1
endloop:
	la t2, buf3
	li a7, 4
	la a0, buf2
	ecall
