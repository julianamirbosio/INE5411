.data 
	prompt: .asciiz "Informe um n�mero para descobrir sua raiz: "
	out:	.asciiz "A raiz eh: "
	
	n: 	.word 10	# numero de itera��es (inteiro)
	
	x: 	.double 0.0 	# numero fornecido
	e: 	.double 1.0
	raiz:	.double 0.0
	dois:	.double 2.0
.text

main:

	li $v0, 4              # C�digo da syscall para imprimir uma string (syscall 4)
	la $a0, prompt         # Carrega o endere�o da mensagem
	syscall                # Executa a syscall para exibir a mensagem
    
	li $v0, 5              # C�digo da syscall para ler um n�mero inteiro (syscall 5)
	syscall                # Executa a syscall para ler o n�mero
    
	mtc1 $v0, $f0          # Move o valor inteiro lido em $v0 para o registrador de ponto flutuante $f0
	cvt.d.w $f0, $f0       # Converte o valor inteiro em precis�o dupla (double)

	s.d $f0, x   	       # Armazena o valor em double na mem�ria (endere�o x)
	
	lw $t0, n	       # Carrego o numero de itera��es da mem�ria
	
	jal raiz_quadrada
	
	li $v0, 4              # C�digo da syscall para imprimir string
    	la $a0, out            # Carrega o endere�o da mensagem "A raiz eh: "
    	syscall                # Executa a syscall para imprimir

    	l.d $f12, raiz         # Carrega o valor da raiz calculada
    	li $v0, 3              # C�digo da syscall para imprimir float
    	syscall                # Executa a syscall para imprimir a raiz

	li $v0, 10             # C�digo da syscall para terminar o programa (syscall 10)
	syscall                # Executa a syscall para sair do programa

raiz_quadrada:
	l.d $f0, x 	       	  # Carrega x em $f0
	l.d $f2, e		  # Carrega e em $f1
	l.d $f4, dois
	
	# e_novo = ((x/e) + e)/2
	iteracao:
		beqz $t0, fim		# Se $t0 (n) == 0, fim das itera��es
		
		div.d $f6, $f0, $f2 	# $f3 = (x/e)
		add.d $f6, $f6, $f2 	# $f3 += e
		div.d $f2, $f6, $f4 	# e = ($f3)/2
		
		addi $t0, $t0, -1  	# Decrementa o valor de n
		j iteracao
	fim:
		s.d $f2, raiz
		jr $ra

# sqrt.d