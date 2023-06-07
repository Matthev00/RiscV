.data
angle_msg: .asciz "Enter angle in degrees: "
cos_msg: .asciz "Value of cosine: "
sin_msg: .asciz "\nValue of sine: "
arctan_values: .word 785398163, 463647609, 244978663, 124354994, 6241880, 31239833, 156237286, 7812341, 3906230, 1953122
PI_180: .word 17453292
X_0: .word 607253320
liczba: .float  10000.0

.text
.globl main

main:
    # Print angle message
    la a0, angle_msg
    li a7, 4 # print string
    ecall

    # Read angle from terminal
    li a7, 5
    ecall
	jal convert
	
    li t1, 0 # starting angle
    li s4, 11 # iterator
    lw t2, X_0 # x value
    li t3, 0 # y value
    li s5, 0 # shifter
    la t4, arctan_values
    jal cordic_loop
    li s7, 1000000000    
	fcvt.s.w f0, s7 
    fcvt.s.w f1, a2
	fdiv.s f2, f1, f0    

    jal end
    b exit

cordic_loop:
    # Test for end of loop
    # bge s4, s5, cordic_done
    beqz s4 , end_loop

    # Determine direction of rotation
    blt t1, s0, cordic_rotate_left
    b cordic_rotate_right

cordic_rotate_left:
    sra t5, t3, s5 # bit shift y
    sra t6, t2, s5 # bit shift x
    sub t2, t2, t5 # new x
    add t3, t3, t6 # new y
    lw s1, 0(t4) # load new angle
    add t1, t1, s1 # change angle
    addi s4, s4, -1
    addi s5, s5, 1
    addi t4, t4, 4
    b cordic_loop

cordic_rotate_right:
    sra t5, t3, s5 # bit shift y
    sra t6, t2, s5 # bit shift x
    add t2, t2, t5 # new x
    sub t3, t3, t6 # new y
    lw s1, 0(t4) # load new angle
    sub t1, t1, s1 # change angle
    addi s4, s4, -1
    addi s5, s5, 1
    addi t4, t4, 4
    b cordic_loop

end_loop:
    # Store sine and cosine results
    mv a2, t3 # Store cosine in a2
    mv a3, t2 # Store sine in a3
    ret



end:

    # Print result
    la a0, cos_msg
    li a7, 4 # print string
    ecall

    fmv.d  fa0, f2 # print cosine
    li a7, 2 # print integer
    ecall
    la a0, sin_msg
    li a7, 4 # print string
    ecall
    mv a0, a3 # print sine
    li a7, 1 # print integer
    ecall

exit:
    # Exit program
        li a7, 10 # exit
        ecall
        
convert:
	# Converts degrees to radians
	lw 	s0, PI_180 # Store PI/180 left shifted 5
    	mul 	s0, a0, s0  	
    	ret
