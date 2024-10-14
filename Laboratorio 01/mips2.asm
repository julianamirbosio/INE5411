.data 
	# Variáveis alocadas na memória
	prompt_b: .asciiz "Insira um inteiro b: "
	prompt_d: .asciiz "Insira um inteiro d: "
	prompt_e: .asciiz "Insira um inteiro e: "
	c: .word 
.text
main:	
	la $a0, prompt_b 	# Escreve uma msg na tela
	li $v0, 4
	syscall
	li $v0, 5 		# Comando para ler inteiro 'b'
	syscall
	add $t0, $v0, $zero 	# Resultado é salvo em $t0
	
	la $a0, prompt_d 	# Escreve uma msg na tela
	li $v0, 4
	syscall
	li $v0, 5 		# Comando para ler inteiro 'd'
	syscall
	add $t1, $v0, $zero 	# Resultado é salvo em $t1
	
	la $a0, prompt_e 	# Escreve uma msg na tela
	li $v0, 4
	syscall
	li $v0, 5 		# Comando para ler inteiro 'e'
	syscall
	add $t2, $v0, $zero 	# Resultado é salvo em $t2


	addi $t0, $t0, 35  	# $t0 = a = b + 35
	
	add $t0, $t0, $t2	# $t0 = a + e
		
	mul $t3, $t1, $t1	# $t3 = d^2
	mul $t3, $t3, $t1	# $t3 = d^3
	
	sub $t0, $t2, $t0	# $t0 = (d^3) - $t0
	
	sw $t0, c		# Alocar o valor final na memória            

