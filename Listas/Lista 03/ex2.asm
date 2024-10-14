.data
	soma: .word 0
.text
main:
	lw $s0, soma
	li $t0, 5	# Carrega i
	
	iteracao:
		beqz $t0, fim		# Se i=0, a contagem acaba
		add $s0, $s0, $t0	# soma += i;
		addi $t0, $t0, -1	# i--;
		j iteracao
	fim:
		sw $s0, soma
		move $a0, $s0         	# Carregar o valor de $s0 no registrador $a0
		li $v0, 1          	# Syscall para imprimir um inteiro (código 1)
		syscall            	# Executar a syscall

		li $v0, 10         	# Syscall para encerrar o programa (código 10)
		syscall            	# Encerrar o programa