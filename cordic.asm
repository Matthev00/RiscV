.data 
	# Det fine variables
	x: .word 3501057      # value of x in radians * (2^15)
	s: .word 0            # value of sin(x) in radians * (2^30)
	c: .word 0x10012000            # value of cos(x) in radians * (2^30)
	
	# Define lookup table of arctangent values
	angles: .align 4
   		.byte 0, 0   # padding bytes to align array to word boundary
   		 .word 553648128, 324910005, 171194370, 86950446, 43690607, 21846381, 10923129, 5463120, 2731561, 1365782, 682894, 341447, 170724, 85362, 42681, 21341, 10670, 5335, 2667, 1333
.text
# COR DIC algorithm implementation
cordic:
    # Set initial values
    li t0, 20             # n = N
    li t1, 0x3ff00000   # factor = 1.0 in fixed-point representation
    lw t2, x            # z = x in radians * (2^15)
    li t3, 0             # y = 0 in fixed-point representation
    
cordic_loop:
    # Load angle value from lookup table
    la t5, angles         # load base address of angles array
    add t4, t5, t0        # add offset to base address
    lw t4, 4(t4)          # load word from memory at address (t5 + t0)
    # Determine direction to rotate
    slt t5, t2, zero
    bne t5, zero, cordic_rotate_left
cordic_rotate_right:
    add t3, t3, t4      # y += factor * angle
    add t2, t2, t1      # z -= factor * pow(2, i)
    j cordic_continue
cordic_rotate_left:
    sub t3, t3, t4      # y -= factor * angle
    sub t2, t2, t1      # z += factor * pow(2, i)
cordic_continue:
    srai t1, t1, 1      # factor *= 0.5 in fixed-point representation
    addi t0, t0, -1     # i--
    bnez t0, cordic_loop # loop while i > 0

    la t0, s     # load address of s into t0
    sw t3, 0(t0) # store value of t3 (result of sine calculation) at address s          # store result of sin(x) in s
    lui t6, 0x33732    # load upper 20 bits of the value into t6
    addi t6, t6, -0x6ad # add lower 12 bits of the value to t6 (sign-extend to 32 bits)
    sub t6, t6, t2      # pi/2 - x in fixed-point representation
    jal cordic          # compute cos(pi/2 - x)
    la t0, c     # load address of s into t0
    sw t3, 0(t0)            # store result of cos(x) in c
    jr ra

# Main function
main:
    # Set x = 0.5236 in radians * (2^15)
    li t0, 18
    li t1, 8621
    slli t1, t1, 16
    or t2, t0, t1
    la t0, x
    sw t2, 0(t0)
    
    # Call CORDIC algorithm to compute sin(x) and cos(x)
    jal cordic
    
    # Print results
    #la t0, sin_msg
    lw t1, s
    srai t1, t1, 15
    mv a0, t1
    li a7, 1
    #la t0, cos_msg
    lw t1, c
    srai t1, t1, 15
    mv a0, t1
    li a7, 1
