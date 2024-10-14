.data
	A: .word 10
	B: .word 15
	C: .word 20
	D: .word 25
	E: .word 30
	F: .word 35
	G: .word 0, 0, 0, 0
	H: .word 0, 0, 0, 0
.text
carregamento:
	lw $s0, A
	lw $s1, B
	lw $s2, C
	lw $s3, D
	lw $s4, E
	lw $s5, F
	
	la $s6, G
	la $s7, H

main:
	# G[0] = (A – (B + C) + F);
	add $t0, $s1, $s2
	sub $t0, $s0, $t0
	add $t0, $t0, $s5
	sw  $t0, 0($s6)
	
	# G[1] = E – (A – B) * (B – C);
	sub $t0, $s0, $s1
	sub $t1, $s1, $s2
	mul $t3, $t0, $t1
	sub $t4, $s4, $t3
	sw  $t4, 4($s6)
	 
	# G[2] = G[1] – C;
	lw $t0, 4($s6)
	sub $t1, $t0, $s2
	sw  $t1, 8($s6)
	 
	# G[3] = G[2] + G[0];
	lw $t0, 8($s6)
	lw $t1, 0($s6)
	add $t2, $t0, $t1
	sw  $t2, 12($s6)

	# H[0] = B – C;
	sub $t0, $s1, $s2 
	sw  $t0, 0($s7)

	# H[1] = A + C;
	add $t0, $s0, $s2
	sw  $t0, 4($s7)

 	# H[2] = B – C + G[3];
 	sub $t0, $s1, $s2
 	lw  $t1, 12($s6)
 	add $t3, $t0, $t1
 	sw  $t3, 8($s7)

	# H[3] = B – G[0] + D;
	lw $t0, 0($s6)
	sub $t1, $s1, $t0
	add $t2, $t1, $s3
	sw  $t2, 12($s7)
	
	li $v0, 10  # Carrega 10 no registrador $v0, que é o código para encerrar o programa
	syscall     # Faz a chamada do sistema para encerrar o programa
	
	