.data
	v: .word 0, 0, 0, 0, 0, 0
	valores: .word 1, 3, 2, 1, 4, 5
	
.text
main:
	la $s0, v
	la $s1, valores
	li $t1, 0	# Carrega i
	li $t2, 20	# Guarda o ultimo endereço do vetor
	
iteracao:
    # Carregar o valor correspondente de 'valores' em $t0
    lw $t0, $t1($s1)       # Carregar o valor de valores[i] em $t0

    # Armazenar o valor no vetor
    sw $t0, $t1($s0)       # Armazenar o valor de $t0 no endereço base do vetor

    # Avançar para o próximo elemento
    addi $t1, $t1, 4     # Incrementar o índice i em 4

    # Verificar se o índice atingiu o tamanho do vetor
    blt $t1, $t2, iteracao # Se &i < 20, continuar o loop

fim:
    li $v0, 10           # Syscall para encerrar o programa (código 10)
    syscall               # Chamar syscall
		
