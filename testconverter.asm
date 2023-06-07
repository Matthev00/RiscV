	.data
	.align 3

max:
	.word 0x3ffffff
cordic_ctab:
	.word 0x2d413ccc # 0.7071067811865476 (Q30.2 format)
	.word 0x28be60db # 0.6324555320336759 (Q30.2 format)
	.word 0x2673cfd6 # 0.6135719910778963 (Q30.2 format)
	.word 0x25c891dc # 0.6088339125177524 (Q30.2 format)
	.word 0x25a20b29 # 0.6076482562561682 (Q30.2 format)
	.word 0x25918c80 # 0.6073517701412959 (Q30.2 format)
	.word 0x258cfdb0 # 0.6072776440935262 (Q30.2 format)
	.word 0x258c89f2 # 0.6072591122988927 (Q30.2 format)
	.word 0x258c6f8c # 0.6072544793325624 (Q30.2 format)
	.word 0x258c68f2 # 0.6072533210898752 (Q30.2 format)
	.word 0x258c6564 # 0.6072530315291348 (Q30.2 format)
	.word 0x258c646f # 0.6072529591389449 (Q30.2 format)
	.word 0x258c641f # 0.6072529410413974 (Q30.2 format)
	.word 0x258c63f8 # 0.6072529375170312 (Q30.2 format)
	.word 0x258c63e9 # 0.6072529370968615 (Q30.2 format)
	.word 0x258c63e5 # 0.6072529370152495 (Q30.2 format)
	.word 0x258c63e4 # 0.6072529370042073 (Q30.2 format)
	.word 0x258c63e4 # 0.6072529370039497 (Q30.2 format)
	.word 0x258c63e4 # 0.6072529370039048 (Q30.2 format)
	.word 0x258c63e4 # 0.6072529370038946 (Q30.2 format)
	.word 0x258c63e4 # 0.6072529370038929 (Q30.2 format)
	
	.text
	.global main

main:
	addi a0, zero, 0# ?/4 in Q30.2 format
	jal cordic
	b end
	
cordic:
	# Fixed-point CORDIC algorithm for computing sin and cos
	# Uses 20 iterations and precomputed CORDIC constants
	# Inputs: $a0 = angle in radians (Q30.2 format)
	# Outputs: $a0 = cos($a0) (Q30.2 format), $a1 = sin($a0) (Q30.2 format)
	.set num_iter, 20
	la t0, cordic_ctab
	la t6, max
	add s0, zero, t6
	#addi s0, zero, 1# x = cos(0) = 1 (Q30.2 format)
	addi s1, zero, 0 # y = sin(0) = 0 (Q30.2 format)
	mv a1, a0 # save angle in a1
	addi t3, zero, 2
	sll a0, a0, t3 # convert angle to Q30.2 format
	srl a2, a0, t3 # factor = 1.0 (Q30.2 format)
	li t1, 0 # k = 0
cordic_loop:
    lw t2, (t0) # load CORDIC constant into $t0
    mul t2, t2, a2 # factor * CORDIC constant
    add a3, a1, t2 # z = theta - factor * CORDIC constant (Q30.2 format)
    sub s3, zero, t2 # -factor * CORDIC constant (Q30.2 format)
    addi t3, zero, 1
    srl a2, a2, t3 # factor /= 2.0 (Q30.2 format)
    sub s2, s0, s3 # tx = x - factor * y (Q30.2 format)
    mul s4, s3, s1 # factor * y (Q30.2 format)
    sub s0, s2, s4 # x = tx (Q30.2 format)
    add s4, s3, s0 # factor * x (Q30.2 format)
    add s1, s1, s4 # y = y + factor * x (Q30.2 format)
    addi t1, t1, 1 # k++
    addi t4, zero, 20
    bne t1, t4, cordic_loop # repeat until k == num_iter
    mv a0, s2 # cos(theta) = x
    mv a1, s1 # sin(theta) = y
    ret
end:
	addi t3, zero, 2
	srl a0, a0, t3
	li a7, 1 # print float
	ecall
	li a7, 1 # print float
	add a0, a1, zero # sin(?/4)
	ecall
	li a7, 10 # exit
	ecall