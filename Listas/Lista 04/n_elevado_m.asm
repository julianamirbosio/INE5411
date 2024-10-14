.data
	prompt_base: .asciiz	"Insira a base (n): "
	prompt_exp:  .asciiz	"Insira o expoente (m): "
	out: 	     .asciiz	"n elevado a m eh: "
	base:	     .word	0
	exp:	     .word	0
	resultado:   .word	0
.text
main:
	li $v0, 4              # Código da syscall para imprimir uma string (syscall 4)
	la $a0, prompt_base    # Carrega o endereço da mensagem
	syscall                # Executa a syscall para exibir a mensagem
	li $v0, 5              # Código da syscall para ler um número inteiro (syscall 5)
	syscall                # Executa a syscall para ler o número
	sw $v0, base
	
	li $v0, 4              # Código da syscall para imprimir uma string (syscall 4)
	la $a0, prompt_exp     # Carrega o endereço da mensagem
	syscall                # Executa a syscall para exibir a mensagem
	li $v0, 5              # Código da syscall para ler um número inteiro (syscall 5)
	syscall                # Executa a syscall para ler o número
	sw $v0, exp
	
	jal n_na_m
	
	li $v0, 4              # Código da syscall para imprimir string (syscall 4)
    	la $a0, out            # Carrega o endereço da mensagem "n elevado a m eh: "
    	syscall                
    	
    	lw $a0, resultado
	li $v0, 1              # Código da syscall para imprimir inteiro
    	syscall                # Executa a syscall para imprimir a raiz

	li $v0, 10             # Código da syscall para terminar o programa (syscall 10)
	syscall                # Executa a syscall para sair do programa

n_na_m:	
	lw $s0, base
	lw $s1, exp
	
	li $t0, 1		# Inicializa uma variavel acumulativa do $t0 (valor)
	iteracao:
		beqz $s1, fim
		
		mul $t0, $t0, $s0	# valor *= base
		
		addi $s1, $s1, -1
		j iteracao
	fim: 
		sw $t0, resultado
		jr $ra