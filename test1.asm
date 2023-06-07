	.global main
	.data
string: .asciz "Implemented in ANGOL!"
buf: 	.space 100

	.text
main:
	la 	a0, string
	jal 	remove
	b 	end
remove:
	addi 	t3, a0, 0
	addi 	t4, a0, 0
	
	li 	t0, 'a'
	li 	t1, 'z'
loop:
	lbu  	t5, (t4)
	sb 	t5, (t3)
	beqz	t5, endloop
	blt	t5, t0, skip
	bgt 	t5, t1, skip
	addi	t3, t3, 1
skip:
	addi 	t4, t4, 1
	b	loop
endloop:
	sub 	a1, t3, a0
	ret
end:
	li 	a7, 4
	ecall
	addi 	a0, a1, -1
	li 	a7, 1
	ecall
	li	a7, 10
	ecall
	
	 
