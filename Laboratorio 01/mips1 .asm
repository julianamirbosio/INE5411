.data 
	# Variáveis alocadas na memória
	b: .word 1
	d: .word 2
	e: .word 1
	c: .word 
.text
main:	
	lw $t0, b		# Carregar o reg $t0 com a variável b
	addi $t0, $t0, 35  	# $t0 = a = b + 35
	
	lw $t1, e		# Carregar o reg $t1 com a variável e
	add $t0, $t0, $t1	# $t0 = a + e
		
	lw $t1, d		# Carregar o reg $t1 com a variável d
	
	mul $t2, $t1, $t1	# $t2 = d^2
	mul $t2, $t2, $t1	# $t2 = d^3
	
	sub $t0, $t2, $t0	# $t0 = (d^3) - $t0
	
	sw $t0, c		# Alocar o valor final na memória            
syscall
