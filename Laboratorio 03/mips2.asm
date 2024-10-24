.data 
	prompt: 	.asciiz "Informe um numero inteiro (x) para descobrir seu seno: "
	out:		.asciiz "O seno de x eh: "
	
	n: 		.word 10	# numero de iterações (inteiro)
	x: 		.word 0 	# numero fornecido
	res_seno:	.double 0.0
	
	# variaveis auxiliares das funçoes folha
	base:	     	.word	0
	exp:	     	.word	0
	res_potencia:   .word	0
	
	fatorando:	.word	0
	res_fatorial:	.word	0
.text

main:
	li $v0, 4              # Código da syscall para imprimir uma string (syscall 4)
	la $a0, prompt         # Carrega o endereço da mensagem
	syscall                # Executa a syscall para exibir a mensagem
    
	li $v0, 5              # Código da syscall para ler um número inteiro (syscall 5)
	syscall                # Executa a syscall para ler o número
    
	sw $v0, x   	       # Armazena o valor x na memória 
	
	jal funcao_seno
	
	li $v0, 4              # Código da syscall para imprimir string (syscall 4)
    	la $a0, out            # Carrega o endereço da mensagem "O seno de x eh: "
    	syscall                # Executa a syscall para imprimir
	
	l.d $f12, res_seno     # Carrega o resultado final da memória
	
	li $v0, 3              # Código da syscall para imprimir float
    	syscall                # Executa a syscall para imprimir o seno de x
    	
    	li $v0, 10             # Código da syscall para terminar o programa (syscall 10)
	syscall                # Executa a syscall para sair do programa
	
funcao_seno:
	lw $s0, x 	       # Carrega x em $f0
	lw $t0, n	       # Carrega o numero de iterações da memória
	l.d $f0, res_seno
	
	iteracao_seno:
		beqz $t0, fim_seno 	# Se (n==0), fim do loop
		
		# (-1)^n
		li $t3, -1
		sw $t3, base		# $t3 = -1
		sw $t0, exp		# $t0 = n
		jal potencia
		
		# (2n + 1)!
		li $t3, 2		# $t3 = 2
		mul $t3, $t3, $t0	# $t3 = 2*n
		addi $t3, $t3, 1	# $t3 = 2*n + 1.data
    negativo_um:      .double -1
    um:               .double 1
    prompt:           .asciiz "Digite um número para calcular o seno (em radianos): "
    resultado_msg:    .asciiz "O valor aproximado do seno é: "

.text

    j   main

# ===== FUNÇÃO: FATORIAL =====
# Calcula n!
# Parâmetro: n ($a0)
# Saída: n! ($f4)

fatorial:
    addi    $sp, $sp, -8          # Aloca espaço na pilha para o endereço de retorno e variável
    sw      $ra, 0($sp)           # Armazena o endereço de retorno
    sw      $s0, 4($sp)           # Armazena o valor atual de n

    l.d     $f4, um                # Inicializa o resultado em 1
    beq     $a0, $zero, terminar   # Se n é 0, finaliza a função

    move    $s0, $a0               # Copia n para $s0
    addi    $a0, $a0, -1            # Decrementa n
    jal     fatorial                # Chamada recursiva

    mtc1    $s0, $f14              # Move n para o registrador de ponto flutuante para multiplicação
    cvt.d.w $f14, $f14              # Converte inteiro para double

    mul.d   $f4, $f14, $f4          # Calcula n! = n * (n-1)!

terminar:    
    lw      $ra, 0($sp)            # Restaura o endereço de retorno
    lw      $s0, 4($sp)            # Restaura n
    addi    $sp, $sp, 8             # Desaloca espaço na pilha
    jr      $ra                      # Retorna

# ===== FUNÇÃO: POTÊNCIA =====
# Calcula x elevado a n
# Parâmetros: x ($f2) e n ($a0)
# Saída: x^n ($f8)

potencia:
    l.d     $f8, um                # Inicializa o resultado em 1

    beq     $a0, 0, sair_potencia  # Se n = 0, retorna 1

    li      $t0, 0                  # Contador do loop

loop_potencia:
    mul.d   $f8, $f8, $f2           # Multiplica resultado por x
    addi    $t0, $t0, 1             # Incrementa contador
    bne     $t0, $a0, loop_potencia # Continua até n ser alcançado

sair_potencia:
    jr      $ra                     # Retorna

# ===== FUNÇÃO: SENO =====
# Calcula seno usando a série (((-1)^n) / (2*n + 1)! ) *  x^(2*n + 1) para n em [0, 20]
# Parâmetro: x ($f0)
# Saída: valor do seno ($f12)

seno:
    move    $s1, $ra                # Salva o endereço de retorno em $s1

    li      $t0, 0                   # Inicializa seno em 0
    mtc1    $t0, $f12
    cvt.d.w $f12, $f12               # Converte inteiro para double

    li      $t1, 0                   # Inicializa n para a somatória

loop_soma:
    l.d     $f2, negativo_um         # Carrega -1
    move    $a0, $t1                 # Define o parâmetro n

    jal     potencia                  # Calcula (-1)^n

    add     $t2, $t1, $t1            # Calcula 2*n
    addi    $t2, $t2, 1              # Calcula 2*n + 1

    move    $a0, $t2                 # Define o parâmetro para fatorial
    jal     fatorial                  # Calcula (2*n + 1)!

    div.d   $f4, $f8, $f4            # Calcula fator = (-1)^n / (2*n + 1)!

    mov.d   $f2, $f0                 # Move x para $f2
    move    $a0, $t2                 # Define o parâmetro para potência
    jal     potencia                  # Calcula x^(2*n + 1)

    mul.d   $f6, $f4, $f8            # Calcula fator * x^(2*n + 1)
    add.d   $f12, $f12, $f6          # Atualiza a soma do seno

    addi    $t1, $t1, 1              # Incrementa n
    bne     $t1, 20, loop_soma       # Continua o loop se n < 20

    move    $ra, $s1                 # Restaura o endereço de retorno
    jr      $ra                       # Retorna

# ======== FUNÇÃO PRINCIPAL ===========

main:
    # ----- Prompt de Entrada -----
    la      $a0, prompt              # Carrega mensagem do prompt
    li      $v0, 4                    # Syscall para imprimir string
    syscall

    # ----- Lê Entrada -----
    li      $v0, 7                    # Syscall para ler double
    syscall                             # O valor de entrada está agora em $f0

    # ----- Chama Função Seno -----
    jal     seno

    # ----- Saída do Resultado -----
    la      $a0, resultado_msg        # Carrega mensagem do resultado
    li      $v0, 4                    # Syscall para imprimir string
    syscall

    li      $v0, 3                    # Syscall para imprimir double
    syscall                             # Saída do valor do seno em $f12

    # ----- Fim do Programa -----
    li      $v0, 10                   # Syscall de saída
    syscall
		sw $t3, fatorando	# fatorial($t3)
		jal fatorial
		
		# (-1)^n/(2n + 1)!
		lw $t4, res_potencia   	# $t4 = (-1)^n
		mtc1 $t4, $f2	       	# Move o valor inteiro lido para registrador de ponto flutuante $f2
		cvt.d.w $f2, $f2      	# Converte o valor word para double
		lw $t4, res_fatorial   	# $t4 = fatorial($t3)
		mtc1 $t4, $f4	       	# Move o valor inteiro lido para registrador de ponto flutuante $f4
		cvt.d.w $f4, $f4       	# Converte o valor word para double
		
		div.d $f6, $f2, $f4    	# $f6 = $f2/$f4
		
		# x^(2n+1)
		sw $s0, base		# $s0 = x
		sw $t3, exp		# $t3 = 2*n + 1
		jal potencia
		
		# [(-1)^n/(2n + 1)!].x^(2n+1)
		lw $t4, res_potencia	# $t4 = x^(2n+1)
		mtc1 $t4, $f8		# Move o resultado para um registrador de ponto flutuante
		cvt.d.w $f8, $f8	# Converte o valor word para double
		mul.d $f10, $f6, $f8	# $f10 = [(-1)^n/(2n + 1)!].x^(2n+1)
		add.d $f0, $f0, $f10	# resultado += $f10
		
		addi $t0, $t0, -1	# n--;
		j iteracao_seno		# Repete o laço
		
	fim_seno:
		s.d $f0, res_seno	# Carrega o resultado final na memória
		jr $ra
	

# Procedimentos folha:
potencia:	
	lw $s1, base
	lw $s2, exp
	
	li $t1, 1			# Inicializa uma variavel acumulativa em $t2 (valor = 1)
	iteracao_potencia:
		beqz $s2, fim_potencia
		
		mul $t1, $t1, $s1	# valor *= base
		
		addi $s2, $s2, -1
		j iteracao_potencia
	fim_potencia: 
		sw $t1, res_potencia
		jr $ra
		
fatorial:
	lw $s3, fatorando
	
	li $t2, 1			# Inicializa uma variavel acumulativa em $t2 (valor = 1)
	iteracao_fatorial:
		beq $s3, 1, fim_fatorial		# Se (fatorando = 1), pule para o fim do procedimento
		
		mul $t2, $t2, $s3	# valor acumulado *= fatorando
		addi $s3, $s3, -1	# fatorando--
		
		j iteracao_fatorial
	fim_fatorial: 
		sw $t2, res_fatorial
		jr $ra