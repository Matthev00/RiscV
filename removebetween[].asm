	.global main
	.data
string: .asciz "]a[asd][asds]\n"
	
	.text
main:
	la 	a0, string
	jal	remove
	b 	end
remove:
	addi 	t0, a0, 0
	addi 	t1, a0, 0
	li  	t2, '['
	li	t3, ']'
	li	t4, 0x00
	li 	t5, 0x01
loop:
	lbu 	t6, (t0)
	sb	t6, (t1)
	beqz 	t6, endloop
	addi 	t0, t0, 1
	beq 	t6, t2, skip1
	beq	t4, t5, skip2
x:
	addi	t1, t1, 1
	b 	loop
skip1:
	addi 	t4, t4, 1
	bne 	t6, t5, x	
	bne 	t6, t3, loop
	addi 	t4, t4, 1
skip2:
	beq 	t6, t3, x
	b 	loop
endloop:
	sub 	a1, t1, a0
	addi 	a1, a1, -1
	ret
end:
	li 	a7, 4
	ecall
	
	addi 	a0, a1, 0
	li 	a7, 1
	ecall
	li	a7, 10
	ecall
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	