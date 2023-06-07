.data 
	
	x: .word 3501057      
	s: .word 0            
	c: .word 0x10012000            
	

	angles: .align 4
   		.byte 0, 0   
   		 .word 553648128, 324910005, 171194370, 86950446, 43690607, 21846381, 10923129, 5463120, 2731561, 1365782, 682894, 341447, 170724, 85362, 42681, 21341, 10670, 5335, 2667, 1333
.text
cordic:
	li t0, 20            
	li t1, 0x3ff00000   
	lw t2, x          
	li t3, 0             
    
cordic_loop:

	la t5, angles       
	add t4, t5, t0     
	lw t4, 4(t4)          
		
	slt t5, t2, zero
	bne t5, zero, cordic_rotate_left
cordic_rotate_right:
   	add t3, t3, t4      
    	add t2, t2, t1     
   	 j cordic_continue
cordic_rotate_left:
    	sub t3, t3, t4     
    	sub t2, t2, t1      
cordic_continue:
    	srai t1, t1, 1     
   	 addi t0, t0, -1    
    	bnez t0, cordic_loop 

   	 la t0, s    
   	 sw t3, 0(t0) 
   	 lui t6, 0x33732 
   	 addi t6, t6, -0x6ad 
   	 sub t6, t6, t2    
   	 jal cordic       
   	 la t0, c     
   	 sw t3, 0(t0) 
	 jr ra

main:
   	 li t0, 18
	 li t1, 8621
   	 slli t1, t1, 16
   	 or t2, t0, t1
   	 la t0, x
    	 sw t2, 0(t0)
    
    	 jal cordic
    

    	lw t1, s
    	srai t1, t1, 15
    	mv a0, t1
	li a7, 1
    
   	lw t1, c
    	srai t1, t1, 15
    	mv a0, t1
    	li a7, 1