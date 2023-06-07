.data
	prompt: .asciz "Enter angle in degrees: "
	cos: .asciz "\ncos: "
	sin: .asciz "\nsin: "
	arctan: .word 785398163, 463647609, 244978663, 124354994, 6241880, 31239833, 156237286, 7812341, 3906230, 1953122, 976562, 488281, 244140, 122070, 61035, 30517
	PI_180: .word 17453292
	X_0: .word 607253320
.text
.globl main

main:
	# Get an input
    	la 	a0, prompt
    	li 	a7, 4 
    	ecall

    	li 	a7, 5
    	ecall
    	
    	jal 	adjust   	
    	
    	jal 	convert
    	
    	li 	t1, 0 			# starting angle
    	li 	t2, 16			# iterator
    	lw 	t3, X_0 		# x = sin
    	li 	t4, 0 			# y = cos
    	li 	t5, 0 			# shifter
    	la 	t6, arctan		# arctan table
    	
    	jal 	cordic
    	
    	jal 	sign
    	
    	jal 	convert_to_float
    	jal 	print
    	
    	
    	 # Exit program
        li a7, 10 # exit
        ecall

convert:
	# Converts degrees to radians
	lw 	t0, PI_180 		# Store PI/180 left shifted 9
    	mul 	t0, a0, t0  	
    	ret

cordic:

	loop:
		beqz 	t2 , end_loop
		# Choose direction of rotation
		blt	t1, t0, rotate_left
    		b 	rotate_right
    	rotate_left:
    		sra 	s0, t4, t5 	# old_x_shifted
    		sra 	s1, t3, t5 	# old_y_shifted
    		sub 	t3, t3, s0 	# new_y
    		add	t4, t4, s1	# new_x
    		
    		lw 	s2, 0(t6) 	# load arctan
    		add 	t1, t1, s2 	# increse starting angle
    		b 	inc_dec
    	
    	rotate_right:
    		sra 	s0, t4, t5 	# old_x_shifted
    		sra 	s1, t3, t5 	# old_y_shifted
    		add 	t3, t3, s0 	# new y
    		sub 	t4, t4, s1 	# new x
    		
    		lw 	s2, 0(t6) 	# load arctan
    		sub 	t1, t1, s2 	# increse starting angle
    		b 	inc_dec
    	
    	inc_dec:
    		addi 	t2, t2, -1	# decrement iterator
    		addi 	t5, t5, 1	# increment shifter
    		addi 	t6, t6, 4	# next pos in arctan ar
    		b 	loop
    	end_loop:
    		# Store sin and cos results
    		mv	a1, t3 		# Store x(cos) in a1
    		mv 	a2, t4		# Store y(sin) in a2
    		ret

print:
	# Print result
    	la 	a0, sin
    	li 	a7, 4
    	ecall
    	fmv.s  	fa0, f3
    	li 	a7, 2
    	ecall
    	la 	a0, sin
    	li 	a7, 4
    	ecall
    	mv  	a0, a2
    	li 	a7, 1
    	ecall
    	la 	a0, cos
    	li 	a7, 4
    	ecall
    	fmv.s  	fa0, f2 
    	li 	a7, 2
    	ecall
    	la 	a0, cos
    	li 	a7, 4
    	ecall
    	mv  	a0, a1
    	li 	a7, 1
    	ecall
    	ret
    	
convert_to_float:
	li 	s7, 1000000000
    	fcvt.s.w f0, s7  
    	fcvt.s.w f1, a1
    	fdiv.s 	f2, f1, f0
    	fcvt.s.w f1, a2
    	fdiv.s 	f3, f1, f0
    	ret
    	
adjust:
	li 	s10, 90
	li 	s11, -90
	li	s3, 0		# counter dec
	li 	s4, 0 		# counter inc
	li	s9, 360	
	rem 	a0, a0, s9
	li	s9, 180	
	bgt 	a0, s10, dec
	blt	a0, s11, inc
	ret
	dec:
		addi	s3, s3, 1
		sub 	a0, s9, a0
		ret
	inc:
		addi 	s4, s4, 1
		add 	a0, a0, s9
		ret

sign:
	bgtz 	s3, one
	bgtz	s4, two
	ret
	one:
		neg a1, a1
		ret
	two:
		neg a1, a1
		neg a2, a2
		ret