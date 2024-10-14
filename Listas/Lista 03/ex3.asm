.data
	v: .word 0, 0, 0, 0, 0, 0
.text
main:
	# v=[1,3,2,1,4,5] 
	la $s0, v
	
	li $t0, 1
	sw $t0, 0($s0)
	
	li $t0, 3
	sw $t0, 4($s0)
	
	li $t0, 2
	sw $t0, 8($s0)
	
	li $t0, 1
	sw $t0, 12($s0)
	
	li $t0, 4
	sw $t0, 16($s0)
	
	li $t0, 5
	sw $t0, 20($s0)
	
	li $v0, 10  # Carrega 10 no registrador $v0, que é o código para encerrar o programa
	syscall     # Faz a chamada do sistema para encerrar o programa