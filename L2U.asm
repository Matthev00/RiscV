	.global main
	.data
input:	.asciz "Enter string:\n"
output: .asciz "Output:\n"
buf1:	.space 100
buf2:	.space 100

	.text
main:	
	li	a7, 4
	la	a0, input
	ecall				#printing input string
	
	li	a7, 8
	la	a0, buf1
	li	a1, 100
	ecall				#storing given string into buf1
	
	la	t1, buf1		#reading pointer
	la	t2, buf2		#writing pointer
	li	t3, 0			#length of string
	
loop1:
	lbu	t4, (t1)		#reading char from buf1	
	beqz 	t4, endOfString 	#reading pointer pointing to null
	addi	t1, t1, 1		#next char
	addi	t3, t3, 1		#incrementing string length 
	b	loop1			

endOfString:
	addi	t1, t1, -1		#reading pointer pointing to last (not null) char
	
loop2:
	sb	t1, (t2)		#char from reading pointer to writing pointer (buf2)
	addi	t3, t3, -1		#decrementing length of string 
	beqz	t3, end			#if end of string go to end
	addi	t1, t1, -1		#next char 
	b 	loop2

end:
	li	t4, 0		
	sb	t4, (t2)		#adding null terminator to buf2

	li	a7, 4
	la	a0, output
	ecall				#printing output
	
	li	a7, 4
	la	a0, buf2
	ecall				#printing reversed string from buf2
	
	li	a7, 10
	ecall
